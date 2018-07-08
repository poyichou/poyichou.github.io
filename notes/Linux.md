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
#### crontab  
```bash
# run a script as a normal user
crontab -e
# run a script as root
sudo crontab -e
# file format
# '*' implies every interval
# '*/n' implies every n interval
# 'x-y' implies every interval between x and y
# 'x,y,z' implies particular times x, y, z
[minute(1-59)] [hour(1-23)] [date(1-31)] [month(1-12)] [day(0-6(Sunday-Friday))] [command]

# Example: upgrade packages with apt every 2 hours
* */2 * * * /usr/bin/apt update && /usr/bin/apt upgrade -y
```
