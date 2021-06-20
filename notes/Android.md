### Notes-Android  

#### Problem solution
in adb shell, even w/ root privilege  
note that android 10 seems to prevent anything from mounting system as R/W, so solution above may not work anymore.
```bash
# mv xxx /system/bin
#mv: /system/bin/xxx: Read-only file system
# mount # to check mount information
# mount -o remount -o rw /
```
tshark in android
```
# binary, it require root access with user name "root"
# Note that in some rooted devices, the user name from following command is shell rather than root
#  adb shell
#  su
#  echo $USER # the answer shoud be root
https://github.com/hasanbulat/tshark-arm64
# check esp related option
tshark -G currentprefs | grep 'esp\.'
# esp auto decode if null decryption
tshark -o esp.enable_null_encryption_decode_heuristic:TRUE [other option]
```
