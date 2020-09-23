### Notes-Android  

#### Problem solution
in adb shell, even w/ root privilege  
```bash
# mv xxx /system/bin
#mv: /system/bin/xxx: Read-only file system
# mount -o remount -o rw /
```
