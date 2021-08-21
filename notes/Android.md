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
---
#### Log in to Termux environment
Termux is a good tool if you need to run program such as python, tshark in android
You can later install tsu to get `sudo` in Termux
Prerequisite
```
rooted Android phone
Install Termux from Google Play
```
In Termux
```
$ pkg install root-repo # don't append other package here, install it until you succeed
$ pkg install openssh
$ sshd # to kill later, killall sshd
$ mkdir ~/.ssh
```
In Linux
```
$ adb push .ssh/id_rsa.pub /sdcard # generate your own ssh key before
$ adb shell su
# cd /data/data/com.termux/files/home/.ssh/
# cat /sdcard/id_rsa.pub >> authorized_keys
# chmod 600 authorized_keys
```
To use in Linux
```
## option 1, plug phone with usb
adb forward tcp:8022 tcp:8022
ssh -p 8022 root@localhost
## option 1, through wifi
ssh root@<local ip address>
```
To get `sudo`
```
# Magisk user
$ pkg install tsu
# Super SU user
# follow https://gitlab.com/st42/termux-sudo
```
