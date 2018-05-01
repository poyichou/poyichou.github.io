{% include Navigate.html %}  
### Notes  

### Ubuntu  
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
