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
$ mkdir ~/.ssh # do if ~/.ssh not exist
```
In Linux
```
$ adb push .ssh/id_rsa.pub /sdcard # generate your own ssh key before
$ adb shell
$ su
# cd /data/data/com.termux/files/home/.ssh/
# cat /sdcard/id_rsa.pub >> authorized_keys
# chmod 600 authorized_keys # do if authorized_keys not 600
```
To use in Linux
```
## option 1, plug phone with usb
adb forward tcp:8022 tcp:8022
ssh -p 8022 root@localhost
## option 1, through wifi
ssh root@<local ip address>
```
To disable SSH host key checking for localhost
append following in "~/.ssh/config"
```
Host localhost
   StrictHostKeyChecking no
   UserKnownHostsFile=/dev/null
```
To get `sudo`
```
# Magisk user
$ pkg install tsu
# Super SU user
# follow https://gitlab.com/st42/termux-sudo
```
To install sklearn in termux
```
$ pkg install python wget proot clang fftw libzmq freetype libpng pkg-config
$ curl -LO https://its-pointless.github.io/setup-pointless-repo.sh
$ bash setup-pointless-repo.sh
$ pkg install openblas gcc-10
$ termux-chroot
$ pip install -U pip
$ pip uninstall joblib
$ pip install joblib==0.11 Cython wheel
$ ln -s /data/data/com.termux/files/usr/bin/gfortran-10 /data/data/com.termux/files/usr/bin/gfortran
$ ln -s /data/data/com.termux/files/usr/lib/libgfortran.so.5 /data/data/com.termux/files/usr/lib/libgfortran.so
# -v for verbose mode to recognize problems if failed
$ NPY_NUM_BUILD_JOBS=1 pip install scikit-learn==0.23.2 -v
```
