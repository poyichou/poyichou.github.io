# Notes-disk  

## Mount a new deivce  
if your device file is /dev/hda1  
```bash
# Create a new filesystem using the ext4 filesystem type:  
$ mke2fs -t ext4 /dev/hda1
# Mount
$ mount -t ext4 /dev/hda1 /wherever
```
---
## Disk Scheduler  
```bash
# check available disk schedulers (in my case, cfq is in use).
$ cat /sys/block/sda/queue/scheduler
noop deadline [cfq]
# enable specific disk scheduler (for example, cfq)
# SCHEDNAME = Desired I/O scheduler
# DEV = device name (e.g., hda)
$ echo SCHEDNAME > /sys/block/DEV/queue/scheduler
# To make it consistent after reboot
# On Grub 2
# Add "elevator=noop" to the GRUB_CMDLINE_LINUX_DEFAULT line.
$ vim /etc/default/grub
$ update-grub
```
---
## Move whole os to smaller drive (w/ example, i.e. sdc->sdd)
```
$ lsblk # not related blocks truncated
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
sdc      8:32   1 235.5G  0 disk 
├─sdc1   8:33   1   512M  0 part 
└─sdc2   8:34   1   235G  0 part
sdd      8:48   1 114.6G  0 disk 
└─sdd1   8:49   1 114.6G  0 part
```
To shrink, shrink filesystem then partition  
To enlarge, enlarge partition then filesystem  
Check filesystem  
```
$ sudo e2fsck /dev/sdc2
e2fsck 1.46.2 (28-Feb-2021)
/dev/sdc2: clean, 204536/15409152 files, 3147421/61608704 blocks
$ sudo e2fsck -f /dev/sdc2
e2fsck 1.46.2 (28-Feb-2021)
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/sdc2: 204536/15409152 files (0.2% non-contiguous), 3147421/61608704 block
```
resize ext2/ext3/ext4 file system  
```
$ sudo resize2fs /dev/sdc2 114G
resize2fs 1.46.2 (28-Feb-2021)
Resizing the filesystem on /dev/sdc2 to 29884416 (4k) blocks.
The filesystem on /dev/sdc2 is now 29884416 (4k) blocks long.

```
Shrink partition  
```
$ sudo fdisk /dev/sdc

Welcome to fdisk (util-linux 2.36.2).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.


Command (m for help): p
Disk /dev/sdc: 235.52 GiB, 252888219648 bytes, 493922304 sectors
Disk model: USB3.0 CRW   -SD
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 080B7B7D-7982-4AE4-A8A9-F1FB34D18F97

Device       Start       End   Sectors  Size Type
/dev/sdc1     2048   1050623   1048576  512M EFI System
/dev/sdc2  1050624 493920255 492869632  235G Linux filesystem

Command (m for help): d
Partition number (1,2, default 2): 2

Partition 2 has been deleted.

Command (m for help): n
Partition number (2-128, default 2): 
First sector (1050624-493922270, default 1050624): 
Last sector, +/-sectors or +/-size{K,M,G,T,P} (1050624-493922270, default 493922270): +119537664K

Created a new partition 2 of type 'Linux filesystem' and of size 114 GiB.
Partition #2 contains a ext4 signature.

Do you want to remove the signature? [Y]es/[N]o: N

Command (m for help): p

Disk /dev/sdc: 235.52 GiB, 252888219648 bytes, 493922304 sectors
Disk model: USB3.0 CRW   -SD
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: gpt
Disk identifier: 080B7B7D-7982-4AE4-A8A9-F1FB34D18F97

Device       Start       End   Sectors  Size Type
/dev/sdc1     2048   1050623   1048576  512M EFI System
/dev/sdc2  1050624 240125951 239075328  114G Linux filesystem

Command (m for help): w
The partition table has been altered.
Calling ioctl() to re-read partition table.
Syncing disks.

```
Recheck filesystem  
```
$ sudo e2fsck -f /dev/sdc2
e2fsck 1.46.2 (28-Feb-2021)
Pass 1: Checking inodes, blocks, and sizes
Inode 8 extent tree (at level 2) could be narrower.  Optimize<y>? yes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/sdc2: 204536/7471104 files (0.8% non-contiguous), 2649209/29884416 blocks
```
Move whole os from sdc to sdd  
```
$ sudo dd if=/dev/sdc of=/dev/sdd # traditional way
#or
$ sudo su -s /bin/bash -c 'pv -s 122944486912 -S < /dev/sdc > /dev/sdd' # speed up and show progress, 122944486912 equals 240125951 (end of partition) * 512 byte
65.4GiB 0:47:32 [22.2MiB/s] [============>                                    ] 27% ETA 2:03:31
```
partition sdd if you want to use 100% unallocated space
```
$ sudo parted /dev/sdd
GNU Parted 3.4
Using /dev/sdd
Welcome to GNU Parted! Type 'help' to view a list of commands.
(parted) p
Model: SanDisk Ultra USB 3.0 (scsi)
Disk /dev/sdd: 123GB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start   End    Size   File system  Name                  Flags
 1      1049kB  538MB  537MB  fat32        EFI System Partition  boot, esp
 2      538MB   123GB  122GB  ext4

(parted) resizepart 2
End?  [123GB]? 100%
(parted) q
Information: You may need to update /etc/fstab.
```
```
$ sudo e2fsck -f /dev/sdd2
e2fsck 1.46.2 (28-Feb-2021)
Pass 1: Checking inodes, blocks, and sizes
Inode 8 extent tree (at level 2) could be narrower.  Optimize<y>? yes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
/dev/sdd2: 204544/7471104 files (0.8% non-contiguous), 2653626/29884416 blocks
```
resize ext4 filesystem to fit
```
$ sudo resize2fs /dev/sdd2
resize2fs 1.46.2 (28-Feb-2021)
Resizing the filesystem on /dev/sdd2 to 29912827 (4k) blocks.
The filesystem on /dev/sdd2 is now 29912827 (4k) blocks long.

```
---
## clone disk in windows (msys, slow speed but easy)
```
# find out device names
 $ cat /proc/partitions
major minor  #blocks  name   win-mounts

    8     0 1953514584 sda
    8     1     16384 sda1
    8     2 1023983616 sda2   D:\
    8     3 929512448 sda3   F:\
    8    16 244198584 sdb
    8    17    460800 sdb1
    8    18    102400 sdb2
    8    19     16384 sdb3
    8    20 242815689 sdb4   C:\
    8    21    800768 sdb5
    8    32 3907018584 sdc
    8    33     16384 sdc1
    8    34 1023983616 sdc2
    8    35 929512448 sdc3
# may need to run msys in administrator mode 
# specify bs since default value (512 bytes) might causing slow speed
 $ dd if=/dev/sda of=/dev/sdc status=progress bs=128K
```
---
## clone disk in windows (native, cmd, fast)
download [dd for windows](http://www.chrysocome.net/downloads/dd-0.5.zip) in [website](http://www.chrysocome.net/dd)  
find out device names, Partition0 is the entire disk  
```
C:\Dowload\Path\dd-0.5>dd --list
rawwrite dd for windows version 0.5.
Written by John Newbigin <jn@it.swin.edu.au>
This program is covered by the GPL.  See copying.txt for details
Win32 Available Volume Information
\\.\Volume{xxx-xxx-xxx-xxx-xxx}\
  link to \\?\Device\HarddiskVolume2
  fixed media
  Mounted on \\.\d:

\\.\Volume{xxx-xxx-xxx-xxx-xxx}\
  link to \\?\Device\HarddiskVolume3
  fixed media
  Mounted on \\.\f:

\\.\Volume{xxx-xxx-xxx-xxx-xxx}\
  link to \\?\Device\HarddiskVolume4
  fixed media
  Not mounted

\\.\Volume{xxx-xxx-xxx-xxx-xxx}\
  link to \\?\Device\HarddiskVolume7
  fixed media
  Mounted on \\.\c:

\\.\Volume{xxx-xxx-xxx-xxx-xxx}\
  link to \\?\Device\HarddiskVolume8
  fixed media
  Not mounted

\\.\Volume{xxx-xxx-xxx-xxx-xxx}\
  link to \\?\Device\HarddiskVolume5
  fixed media
  Not mounted

\\.\Volume{xxx-xxx-xxx-xxx-xxx}\
  link to \\?\Device\CdRom0
  CD-ROM
  Mounted on \\.\e:


NT Block Device Objects
\\?\Device\CdRom0
  size is 2147483647 bytes
\\?\Device\Harddisk0\Partition0
  link to \\?\Device\Harddisk0\DR0
  Fixed hard disk media. Block size = 512
  size is 2000398934016 bytes
\\?\Device\Harddisk0\Partition1
  link to \\?\Device\HarddiskVolume1
  Fixed hard disk media. Block size = 512
  size is 16777216 bytes
\\?\Device\Harddisk0\Partition2
  link to \\?\Device\HarddiskVolume2
\\?\Device\Harddisk0\Partition3
  link to \\?\Device\HarddiskVolume3
\\?\Device\Harddisk1\Partition0
  link to \\?\Device\Harddisk1\DR1
  Fixed hard disk media. Block size = 512
  size is 250059350016 bytes
\\?\Device\Harddisk1\Partition1
  link to \\?\Device\HarddiskVolume4
  Fixed hard disk media. Block size = 512
  size is 471859200 bytes
\\?\Device\Harddisk1\Partition2
  link to \\?\Device\HarddiskVolume5
  Fixed hard disk media. Block size = 512
  size is 104857600 bytes
\\?\Device\Harddisk1\Partition3
  link to \\?\Device\HarddiskVolume6
  Fixed hard disk media. Block size = 512
  size is 16777216 bytes
\\?\Device\Harddisk1\Partition4
  link to \\?\Device\HarddiskVolume7
\\?\Device\Harddisk1\Partition5
  link to \\?\Device\HarddiskVolume8
  Fixed hard disk media. Block size = 512
  size is 819986432 bytes
\\?\Device\Harddisk2\Partition0
  link to \\?\Device\Harddisk2\DR4
  Fixed hard disk media. Block size = 512
  size is 4000787030016 bytes

Virtual input devices
 /dev/zero   (null data)
 /dev/random (pseudo-random data)
 -           (standard input)

Virtual output devices
 -           (standard output)
```
--progress make it show copied block  
--size makes sure dd not to read past end of an entire device  
specify bs since default value (512 bytes) might causing slow speed  
```
C:\Dowload\Path\dd-0.5>dd if=\\?\Device\Harddisk0\Partition0 of=\\?\Device\Harddisk2\Partition0 bs=16M --progress --size
```
