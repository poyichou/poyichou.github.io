# Notes-networking  

## Bind a binary to a local port
```bash
# method 1
ncat -vc [binary] -kl 127.0.0.1 [port] 
# method 2
rm -f /tmp/f; mkfifo /tmp/f
while [ 1 ]; do cat /tmp/f | [binary] 2>&1 | nc -l 127.0.0.1 [port] > /tmp/f; done
rm -f /tmp/f
```
---
## ssh: connect to host xxx.xxx.xxx.xxx port 22: Connection refused   
```bash
# add "ssh: ALL"
$ sudo vim /etc/hosts.allow
$ sudo systemctl restart sshd
```
---
## establish a wireless connection with netctl
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
---
## netctl configuration file for 802.1X (PEAP-MSCHAP v2)
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
---
## netctl configuration file for 802.1X (PEAP-MSCHAP v2) while hash password instead of plaintext
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
---
## error when establishing a wireless connection with netctl
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
---
## Monitor 802.11 packets
```
# put WiFi interface in monitor mode
sudo iw dev <wlan interface> interface add mon0 type monitor
sudo ip link set mon0 up
sudo wireshark -I # in monitor mode, monitor on mon0
# remove virtual interface afterwards
sudo iw dev mon0 interface del
```
