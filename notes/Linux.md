### Notes-Linux  

#### Mount a new deivce  
if your device file is /dev/hda1  
```bash
# Create a new filesystem using the ext4 filesystem type:  
$ mke2fs -t ext4 /dev/hda1
# Mount
$ mount -t ext4 /dev/hda1 /wherever
```
#### Change time zone (for example: change to CDT)  
```bash
$ cp /usr/share/zoneinfo/America/Chicago /etc/localtime
```
#### Analyze size of folder content
```bash
$ ncdu
```
#### Bind a binary to a local port
```bash
# method 1
ncat -vc [binary] -kl 127.0.0.1 [port] 
# method 2
rm -f /tmp/f; mkfifo /tmp/f
while [ 1 ]; do cat /tmp/f | [binary] 2>&1 | nc -l 127.0.0.1 [port] > /tmp/f; done
rm -f /tmp/f
```
#### Disk Scheduler  
```bash
# check available disk schedulers (in my case, cfq is in use).
$ cat /sys/block/sda/queue/scheduler
noop deadline [cfq]
# enable specific disk scheduler (for example, cfq)
# SCHEDNAME = Desired I/O scheduler
# DEV = device name (e.g., hda)
$ echo SCHEDNAME > /sys/block/DEV/queue/scheduler
# To make it consistent after reboot
# On Grub 2
# Add "elevator=noop" to the GRUB_CMDLINE_LINUX_DEFAULT line.
$ vim /etc/default/grub
$ update-grub
```
#### ssh: connect to host xxx.xxx.xxx.xxx port 22: Connection refused   
```bash
# add "ssh: ALL"
$ sudo vim /etc/hosts.allow
$ sudo systemctl restart sshd
```
#### big5 garbled in compressed file (take zip for example)
```
$ sudo apt-get install convmv
$ LANG=C unzip file.zip
$ convmv -f big5 -t utf8 -r --notest *
```
#### unzip produce 'unsupported compression method 99'
```
# may caused by WinRAR/WinZIP default encryption method (i.e. AES)
# currently not supported by unzip
# alternative: 7z, take ubuntu for example
$ sudo apt install p7zip-full
$ 7z x <file.zip>
```
#### USB is read only in Nautilus when it is not
```
# it's a bug of Nautilus
killall nautilus
```
#### crontab  
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
#### tmux
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
#### gdm-plymouth  
```bash
# After `systemctl status gdm-plymouth.service`

# gdm-password][691]: PAM unable to dlopen(/usr/lib/security/pam_gnome_keyring.so): ****
# gdm-password][691]: PAM adding faulty module: /usr/lib/security/pam_gnome_keyring.so

# Install gnome-keyring
# Example
$ sudo pacman -S gnome-keyring
```
#### establish a wireless connection with netctl
```bash
# require package "wpa_passphrase"
# dhcpcd.service should be active

# If profile file is not exists
# generate profile file and establish a connection 
# set -o flag to obfuscate the wireless passphrase
$ sudo wifi-menu -o # choose the ssid, enter the password if required

# Once profile file has been generated
# to establish/stop a connection
# <profile file> is only the file name, not full path
$ sudo netctl [start|stop] <profile file>

# To enable/reenable a profile to start at boot
# use reenable after changing profile file
$ sudo netctl [enable|reenable] <profile file>

# If you want to use dhcpcd manually
$ sudo dhcpcd <interface> # check interface with "ip link"

## netctl-auto
# To enable auto connect to exist profile
$ sudo systemctl enable netctl-auto@<wireless interface>.service
$ sudo systemctl start netctl-auto@<wireless interface>.service

# Switch to another ssid
$ sudo netctl-auto switch-to <profile file>
```
#### netctl configuration file for 802.1X (PEAP-MSCHAP v2)
```
Description='A descriptive name'
Interface=wlp2s0
Connection=wireless
Security=wpa-configsection
ESSID=SSID
IP=dhcp
WPAConfigSection=(
    'ssid="SSID"'
    'key_mgmt=WPA-EAP'
    'eap=PEAP'
    'identity="MYIDENTITY"'
    'password="MYPASSWORD"'
    'phase2="auth=MSCHAPV2"'
)
```
#### netctl configuration file for 802.1X (PEAP-MSCHAP v2) while hash password instead of plaintext
```
Description='A descriptive name'
Interface=wlp2s0
Connection=wireless
Security=wpa-configsection
ESSID=SSID
IP=dhcp
WPAConfigSection=(
    'ssid="SSID"'
    'key_mgmt=WPA-EAP'
    'eap=PEAP'
    'identity="MYIDENTITY"'
    'password=hash:NT_HASH_OF_PASSWORD_HERE'
    'phase2="auth=MSCHAPV2"'
)
```
To generate nthash of password
```
echo -n MYPASSWORD | iconv -t utf16le | openssl md4
```
#### error when establishing a wireless connection with netctl
```bash
# error code
Job for netctl@xxxxxx.service failed because the control process exited with error code.
See "systemctl status "netctl@xxxxxx.service"" and "journalctl -xe" for details.
# solution
sudo systemctl stop dhcpcd.service
sudo systemctl disable dhcpcd.service
sudo rm /var/lib/dhcpcd/*.lease # and reboot
sudo wifi-menu -o
sudo dhcpcd <interface> # check interface with "ip link"
```
#### "No cast destinations found" in Chromium and Google Chrome on Linux
`chrome://flags/#load-media-router-component-extension` -> `Load Media Router Component Extension`, change `Default` to `Enabled`.
#### beep sound
```
# To enable the beep sound, make sure that pcspkr module is exist
lsmod | grep pcspkr
# If doesn't exist, to install related package, take ubuntu for example
sudo apt install beep
# remove pcspkr in blacklist
sudo vim /etc/modprobe.d/blacklist.conf # remove "blacklist pcspkr"
reboot # reboot to make change of /etc/modprobe.d/blacklist.conf take effect
```
#### Disable/re-enable suspend
```
# disable
sudo systemctl mask sleep.target suspend.target hibernate.target hybrid-sleep.target
# re-enable
sudo systemctl unmask sleep.target suspend.target hibernate.target hybrid-sleep.target
```
#### Monitor 802.11 packets
```
# put WiFi interface in monitor mode
sudo iw dev <wlan interface> interface add mon0 type monitor
sudo ip link set mon0 up
sudo wireshark -I # in monitor mode, monitor on mon0
# remove virtual interface afterwards
sudo iw dev mon0 interface del
```
#### Make Grub remember last choice
```
# put following in /etc/default/grub
#GRUB_DEFAULT=saved
#GRUB_SAVEDEFAULT=true
$ sudo update-grub
# or for some distribution without update-grub
$ sudo grub-mkconfig -o /boot/grub/grub.cfg
```
