### Notes-Android  

#### Problem solution
in adb shell, even w/ root privilege  
```bash
# mv xxx /system/bin
#mv: /system/bin/xxx: Read-only file system
# mount # to check mount information
# mount -o remount -o rw /
```
#### Note
- Android 10 seems to prevents anything from mounting system as R/W, so solution above may not work anymore.
