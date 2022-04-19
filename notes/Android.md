# Notes-Android  

## Problem solution
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
## Log in to Termux environment
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
---
## adb over WiFi(no root required)  
Plug the device to PC through usb.  
```bash
# list plugged devices,
# K1AXKN01F823YE5 is the ID of device in this case
$ adb devices
List of devices attached
K1AXKN01F823YE5	device

# show ip address of device,
# 192.168.1.125 is the IP of device in this case
$ adb -s K1AXKN01F823YE5 shell ip a show wlan0
22: wlan0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
    link/ether 40:b0:76:bc:39:30 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.125/24 brd 192.168.1.255 scope global wlan0
       valid_lft forever preferred_lft forever
    inet6 fe80::42b0:76ff:febc:3930/64 scope link 
       valid_lft forever preferred_lft forever

# restart the adbd daemon listening on TCP on the 5555 port.
$ adb -s K1AXKN01F823YE5 tcpip 5555

# connect to the device via TCP/IP
$ adb connect 192.168.1.125
connected to 192.168.1.125:5555

# show devices adb can find via usb and 192.168.1.125
$ adb devices
List of devices attached
K1AXKN01F823YE5 device
192.168.1.125:5555      device
```
Now you can connect to the device in following two ways.  
```bash
# through usb
adb -s K1AXKN01F823YE5 [commands]
# through WiFi
adb -s 192.168.1.125:5555 [commands]
```
So it's OK to unplug the usb cable now.  
To restart the adbd daemon listening on USB,  
```bash
# replace [ID of device] by K1AXKN01F823YE5 or 192.168.1.125:5555,
# depending on how the device and the PC are connected
$ adb -s [ID of device] usb
restarting in USB mode
```
