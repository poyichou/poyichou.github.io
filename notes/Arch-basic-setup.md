### Notes-Arch-basic-setup  

#### Basic setup after installation of Arch Linux with Script/arch-install.sh  
#### user  
```bash
#### log in root ####
# change root password
passwd root
useradd --create-home --groups wheel --shell /bin/bash <user_name>
# change <user_name> password
passwd <user_name>
```
#### configuration  
```bash
export EDITOR=vim
visudo # comment out '%wheel ALL=(ALL) ALL'
#### log in normal user ####
# personal vim initializations
wget -O .vimrc https://poyichou.github.io/notes/myvimrc
# system wide vim initializations
sudo cp .vimrc /etc/vimrc
wget -O .bashrc https://poyichou.github.io/notes/mybashrc
```
#### for virtualbox  
```bash
sudo pacman -S virtualbox-guest-utils # choose 2
```
#### destop  
```bash
sudo pacman -S gnome-shell gdm
sudo systemctl enable gdm
sudo pacman -S gnome-tweak-tool sakura # terminal emulator

sudo pacman -S firefox
# reboot to see if succeeded
```
#### remain  
```bash
sudo pacman -S gnome-control-center
# set chewing in gnome-control-center => Region & Language afterward
sudo pacman -S ibus ibus-chewing

# font
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji
# solve terminal emulator character overlap
sudo pacman -S ttf-dejavu

# install  yaourt
sudo pacman -S --needed base-devel git wget yajl
cd /tmp
git clone https://aur.archlinux.org/package-query.git
cd package-query/
makepkg -si && cd /tmp/
git clone https://aur.archlinux.org/yaourt.git
cd yaourt/
makepkg -si

# ajust with gnome-tweak-tool afterward
# theme
sudo pacman -S arc-gtk-theme
# icon theme
yaourt -S paper-icon-theme-git # mustn't as root

# Plymouth
yaourt -S plymouth # mustn't as root
# Add plymouth to the HOOKS array in mkinitcpio.conf.
# It must be added after base and udev for it to work.
# Example: HOOKS="base udev plymouth [...] "
sudo vim /etc/mkinitcpio.conf
# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
sudo vim /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo mkinitcpio -p linux
# change gdm to gdm-plymouth
sudo systemctl disable gdm
sudo pacman -R gdm
# libgdm-plymouth and libgdm are in conflict. Remove libgdm? [y/N] y
yaourt -S gdm-plymouth
sudo systemctl enable gdm-plymouth.service

# plymouth theme
# Example: Mageia ColdFire (https://www.opendesktop.org/c/1460735505)
wget -O 170783-Mageia-ColdFire.tar.gz <download_link>
tar zxvf 170783-Mageia-ColdFire.tar.gz
sudo cp -r Mageia-ColdFire/ /usr/share/plymouth/themes/
sudo plymouth-set-default-theme -R Mageia-ColdFire
# reboot to check if succeeded
```
#### media  
```bash
# photo management
sudo pacman -S gthumb
# player
sudo pacman -S vlc
```
