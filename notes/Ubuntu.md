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
#### Check if Ubuntu needs a reboot (usually after apt upgrade)
```
# needs if file exists
cat /var/run/reboot-required
# list packages cause the need of reboot
cat /var/run/reboot-required.pkgs
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

# Example 2
$ sudo apt upgrade
E: Could not get lock /var/lib/dpkg/lock-frontend - open (11: Resource temporarily unavailable)
E: Unable to acquire the dpkg frontend lock (/var/lib/dpkg/lock-frontend), is another process using it?

# Solution
# Get process id using this file and kill SIGKILL to it
sudo kill -s 9 $(sudo fuser /var/lib/dpkg/lock-frontend)
```
#### grub still hides after GRUB_TIMEOUT set > 0
```
sudo vim /etc/default/grub # add GRUB_TIMEOUT_STYLE="menu"
sudo update-grub
```
#### Disable autosuspend in GDM3 login screen
```
# To print setting, which print suspend and 1200 respectively
sudo dbus-launch gsettings get org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type
sudo dbus-launch gsettings get org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout
# To turn off suspension
sudo dbus-launch gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type nothing
```
