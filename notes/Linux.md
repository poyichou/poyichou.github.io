# Notes-Linux  

## Change time zone (for example: change to CDT)  
```bash
$ cp /usr/share/zoneinfo/America/Chicago /etc/localtime
```
---
## Analyze size of folder content
```bash
$ ncdu
```
---
## big5 garbled in compressed file (take zip for example)
```
$ sudo apt-get install convmv
$ LANG=C unzip file.zip
$ convmv -f big5 -t utf8 -r --notest *
```
---
## unzip produce 'unsupported compression method 99'
```
# may caused by WinRAR/WinZIP default encryption method (i.e. AES)
# currently not supported by unzip
# alternative: 7z, take ubuntu for example
$ sudo apt install p7zip-full
$ 7z x <file.zip>
```
---
## USB is read only in Nautilus when it is not
```
# it's a bug of Nautilus
killall nautilus
```
---
## crontab  
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
---
## tmux
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
---
## gdm-plymouth  
```bash
# After `systemctl status gdm-plymouth.service`

# gdm-password][691]: PAM unable to dlopen(/usr/lib/security/pam_gnome_keyring.so): ****
# gdm-password][691]: PAM adding faulty module: /usr/lib/security/pam_gnome_keyring.so

# Install gnome-keyring
# Example
$ sudo pacman -S gnome-keyring
```
---
## "No cast destinations found" in Chromium and Google Chrome on Linux
`chrome://flags/#load-media-router-component-extension` -> `Load Media Router Component Extension`, change `Default` to `Enabled`.
---
## beep sound
```
# To enable the beep sound, make sure that pcspkr module is exist
lsmod | grep pcspkr
# If doesn't exist, to install related package, take ubuntu for example
sudo apt install beep
# remove pcspkr in blacklist
sudo vim /etc/modprobe.d/blacklist.conf # remove "blacklist pcspkr"
reboot # reboot to make change of /etc/modprobe.d/blacklist.conf take effect
```
---
## Disable/re-enable suspend
```
# disable
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
# re-enable
sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
```
---
## Make Grub remember last choice
```
# put following in /etc/default/grub
#GRUB_DEFAULT=saved
#GRUB_SAVEDEFAULT=true
$ sudo update-grub
# or for some distribution without update-grub
$ sudo grub-mkconfig -o /boot/grub/grub.cfg
```
---
## Disable GDM auto suspend
```
# configure policy on ac, for battery, change ac below to battery
sudo su gdm -s /bin/bash -c "dbus-launch gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'"
sudo su gdm -s /bin/bash -c "dbus-launch gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0"
# To verify changes
sudo su gdm -s /bin/bash -c "gsettings list-recursively org.gnome.settings-daemon.plugins.power"
# Restart GDM to activate your changes. 
```
---
## Laptop modify backlight fail
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
---
## Disable USB autosuspend (useful when your os is installed in USB drive)
```
# modify usbcore.autosuspend kernel module parameter, suppose the bootloader is grub2
# usbcore.autosuspend=<delay second>, -1 to disable
sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[a-z ]*/& usbcore.autosuspend=-1/' /etc/default/grub
sudo update-grub2
reboot
# to check result, should be -1
cat /sys/module/usbcore/parameters/autosuspend
```
