{% include Navigate.html %}  
### Notes  

### Linux  
#### Mount a new deivce  
if your device file is /dev/hda1  
```bash
#Create a new filesystem using the ext4 filesystem type:  
mke2fs -t ext4 /dev/hda1
#Mount
mount -t ext4 /dev/hda1 /wherever
```
#### Change time zone (for example: change to CDT)  
```bash
cp /usr/share/zoneinfo/America/Chicago /etc/localtime
```
