### Notes-Linux  

#### Mount a new deivce  
if your device file is /dev/hda1  
```bash
# Create a new filesystem using the ext4 filesystem type:  
$ mke2fs -t ext4 /dev/hda1
# Mount
$ mount -t ext4 /dev/hda1 /wherever
```
#### Change time zone (for example: change to CDT)  
```bash
$ cp /usr/share/zoneinfo/America/Chicago /etc/localtime
```
#### Analyze size of folder content
```bash
$ ncdu
```
#### Bind a binary to a local port
```bash
# method 1
ncat -vc [binary] -kl 127.0.0.1 [port] 
# method 2
rm -f /tmp/f; mkfifo /tmp/f
while [ 1 ]; do cat /tmp/f | [binary] 2>&1 | nc -l 127.0.0.1 [port] > /tmp/f; done
rm -f /tmp/f
```
#### Disk Scheduler  
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
#### ssh: connect to host xxx.xxx.xxx.xxx port 22: Connection refused   
```bash
# add "ssh: ALL"
$ sudo vim /etc/hosts.allow
$ sudo systemctl restart sshd
```
#### big5 garbled in compressed file (take zip for example)
```
$ sudo apt-get install convmv
$ LANG=C unzip file.zip
$ convmv -f big5 -t utf8 -r --notest *
```
#### unzip produce 'unsupported compression method 99'
```
# may caused by WinRAR/WinZIP default encryption method (i.e. AES)
# currently not supported by unzip
# alternative: 7z, take ubuntu for example
$ sudo apt install p7zip-full
$ 7z x <file.zip>
```
#### USB is read only in Nautilus when it is not
```
# it's a bug of Nautilus
killall nautilus
```
#### crontab  
```bash
# run a script as a normal user
$ crontab -e
# run a script as root
$ sudo crontab -e
# file format
# '*' implies every interval
# '*/n' implies every n interval
# 'x-y' implies every interval between x and y
# 'x,y,z' implies particular times x, y, z
[minute(1-59)] [hour(1-23)] [date(1-31)] [month(1-12)] [day(0-6(Sunday-Friday))] [command]

# Example: upgrade packages with apt-get every 2 hours
00 */2 * * * /usr/bin/apt-get update && /usr/bin/apt-get upgrade -y
```
#### tmux
```bash
# Commands
# start a new session
$ tmux [|new -s <session name>]
# list running sessions
$ tmux ls
# attach
$ tmux a [|-t <session name>]
# delete a session
$ tmux kill-session -t <session_name>
# delete all sessions
$ tmux kill-session -a

# Shortcut
# Help
Ctrl+b ?
# detach
Ctrl+b d
# create a window
Ctrl+b c
# switch to previous/next/specific window
# according to the order in status bar
Ctrl+b p/n/<number>
# navigate panes
Ctrl+b <arrow>
# split a pane into a left and a right pane
Ctrl+b %
# split a pane into a top and a buttom pane
Ctrl+b "
```
#### gdm-plymouth  
```bash
# After `systemctl status gdm-plymouth.service`

# gdm-password][691]: PAM unable to dlopen(/usr/lib/security/pam_gnome_keyring.so): ****
# gdm-password][691]: PAM adding faulty module: /usr/lib/security/pam_gnome_keyring.so

# Install gnome-keyring
# Example
$ sudo pacman -S gnome-keyring
```
#### establish a wireless connection with netctl
```bash
# require package "wpa_passphrase"
# dhcpcd.service should be active

# If profile file is not exists
# generate profile file and establish a connection 
# set -o flag to obfuscate the wireless passphrase
$ sudo wifi-menu -o # choose the ssid, enter the password if required

# Once profile file has been generated
# to establish/stop a connection
# <profile file> is only the file name, not full path
$ sudo netctl [start|stop] <profile file>

# To enable/reenable a profile to start at boot
# use reenable after changing profile file
$ sudo netctl [enable|reenable] <profile file>

# If you want to use dhcpcd manually
$ sudo dhcpcd <interface> # check interface with "ip link"

## netctl-auto
# To enable auto connect to exist profile
$ sudo systemctl enable netctl-auto@<wireless interface>.service
$ sudo systemctl start netctl-auto@<wireless interface>.service

# Switch to another ssid
$ sudo netctl-auto switch-to <profile file>
```
#### netctl configuration file for 802.1X (PEAP-MSCHAP v2)
```
Description='A descriptive name'
Interface=wlp2s0
Connection=wireless
Security=wpa-configsection
ESSID=SSID
IP=dhcp
WPAConfigSection=(
    'ssid="SSID"'
    'key_mgmt=WPA-EAP'
    'eap=PEAP'
    'identity="MYIDENTITY"'
    'password="MYPASSWORD"'
    'phase2="auth=MSCHAPV2"'
)
```
#### netctl configuration file for 802.1X (PEAP-MSCHAP v2) while hash password instead of plaintext
```
Description='A descriptive name'
Interface=wlp2s0
Connection=wireless
Security=wpa-configsection
ESSID=SSID
IP=dhcp
WPAConfigSection=(
    'ssid="SSID"'
    'key_mgmt=WPA-EAP'
    'eap=PEAP'
    'identity="MYIDENTITY"'
    'password=hash:NT_HASH_OF_PASSWORD_HERE'
    'phase2="auth=MSCHAPV2"'
)
```
To generate nthash of password
```
echo -n MYPASSWORD | iconv -t utf16le | openssl md4
```
#### error when establishing a wireless connection with netctl
```bash
# error code
Job for netctl@xxxxxx.service failed because the control process exited with error code.
See "systemctl status "netctl@xxxxxx.service"" and "journalctl -xe" for details.
# solution
sudo systemctl stop dhcpcd.service
sudo systemctl disable dhcpcd.service
sudo rm /var/lib/dhcpcd/*.lease # and reboot
sudo wifi-menu -o
sudo dhcpcd <interface> # check interface with "ip link"
```
#### "No cast destinations found" in Chromium and Google Chrome on Linux
`chrome://flags/#load-media-router-component-extension` -> `Load Media Router Component Extension`, change `Default` to `Enabled`.
#### beep sound
```
# To enable the beep sound, make sure that pcspkr module is exist
lsmod | grep pcspkr
# If doesn't exist, to install related package, take ubuntu for example
sudo apt install beep
# remove pcspkr in blacklist
sudo vim /etc/modprobe.d/blacklist.conf # remove "blacklist pcspkr"
reboot # reboot to make change of /etc/modprobe.d/blacklist.conf take effect
```
#### Disable/re-enable suspend
```
# disable
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
# re-enable
sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
```
#### Monitor 802.11 packets
```
# put WiFi interface in monitor mode
sudo iw dev <wlan interface> interface add mon0 type monitor
sudo ip link set mon0 up
sudo wireshark -I # in monitor mode, monitor on mon0
# remove virtual interface afterwards
sudo iw dev mon0 interface del
```
#### Make Grub remember last choice
```
# put following in /etc/default/grub
#GRUB_DEFAULT=saved
#GRUB_SAVEDEFAULT=true
$ sudo update-grub
# or for some distribution without update-grub
$ sudo grub-mkconfig -o /boot/grub/grub.cfg
```
#### Disable GDM auto suspend
```
# configure policy on ac, for battery, change ac below to battery
sudo su gdm -s /bin/bash -c "dbus-launch gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'"
sudo su gdm -s /bin/bash -c "dbus-launch gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0"
# To verify changes
sudo su gdm -s /bin/bash -c "gsettings list-recursively org.gnome.settings-daemon.plugins.power"
# Restart GDM to activate your changes. 
```
#### Laptop modify backlight fail
xbacklight -get
No outputs have backlight property
add file `/etc/X11/xorg.conf.d/20-intel.conf`
first check if `/sys/class/backlight/intel_backlight` exists
```
Section "Device"
    Identifier  "Intel Graphics"
    Driver      "intel"
    Option      "Backlight"  "intel_backlight"
EndSection
```
#### Move whole os to smaller drive (w/ example, i.e. sdc->sdd)
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
