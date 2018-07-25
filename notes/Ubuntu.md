### Notes-Ubuntu  

#### Use other kernel version  
```bash
# keep apt from upgrading kernel ver.
apt-mark hold linux-image-generic linux-headers-generic
# install other kernel ver.(for example: 4.8.0-52-generic)
apt install linux-image-4.8.0-52-generic
#(comment out `GRUB_HIDDEN_TIMEOUT=0` and `GRUB_HIDDEN_TIMEOUT_QUIET=true`)
vim /etc/default/grub
update-grub
# boot into other kernel ver.
reboot
# find other image on the host
dpkg --list | grep linux-image
# remove the target image (for example: 4.8.0-42-generic)
apt purge linux-image-4.8.0-42-generic
apt autoremove
```
#### Before kernel programming  
```bash
apt install module-assistant
m-a prepare
```
#### apt upgrade failed in desktop version  
```bash
# Example  
$ sudo apt upgrade
E: Could not get lock /var/lib/dpkg/lock - open (11: Resource temporarily unavailable)
E: Unable to lock the administration directory (/var/lib/dpkg/), is another process using it?

# Solution  
sudo systemctl stop apt-daily.timer
sudo systemctl stop apt-daily.service
```
