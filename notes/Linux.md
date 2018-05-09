### Notes-Linux  

#### Mount a new deivce  
if your device file is /dev/hda1  
```bash
#Create a new filesystem using the ext4 filesystem type:  
$ mke2fs -t ext4 /dev/hda1
#Mount
$ mount -t ext4 /dev/hda1 /wherever
```
#### Change time zone (for example: change to CDT)  
```bash
$ cp /usr/share/zoneinfo/America/Chicago /etc/localtime
```
#### Disk Scheduler  
```bash
#check available disk schedulers (in my case, cfq is in use).
$ cat /sys/block/sda/queue/scheduler
noop deadline [cfq]
#enable specific disk scheduler (for example, cfq)
#SCHEDNAME = Desired I/O scheduler
#DEV = device name (e.g., hda)
$ echo SCHEDNAME > /sys/block/DEV/queue/scheduler
#To make it consistent after reboot
#On Grub 2
#Add "elevator=noop" to the GRUB_CMDLINE_LINUX_DEFAULT line.
$ vim /etc/default/grub
$ update-grub
```
