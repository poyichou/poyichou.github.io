### Notes-Arch-basic-setup  

#### Basic setup after installation of Arch Linux with shell script at [Scripts](https://poyichou.github.io/Scripts.html) -> arch-install.sh  
#### create an user  
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
wget -O .vimrc https://poyichou.github.io/config_file/myvimrc
# system wide vim initializations
sudo cp .vimrc /etc/vimrc
wget -O .bashrc https://poyichou.github.io/config_file/mybashrc
```
#### destop  
```bash
sudo pacman -S gnome-shell gdm gnome-tweak-tool
# To unlock option gnome-tweak-tool -> Appearance -> Shell,
# enable option gnome-tweak-tool -> Extensions -> User themes later
sudo pacman -S gnome-shell-extensions
sudo systemctl enable gdm
# terminal emulator
sudo pacman -S termite compton
mkdir -p ~/.config/termite/
wget -O ~/.config/termite/config https://poyichou.github.io/config_file/termite_config

# reboot to see if succeeded
```
#### for virtualbox  
```bash
sudo pacman -S virtualbox-guest-utils # choose 2
```
#### remain (After executing this block, refer [Arch Wiki](https://wiki.archlinux.org/index.php/GDM#Log-in_screen_background_image) to change login screen background image.)  
```bash
# set chewing in gnome-control-center -> Region & Language later
sudo pacman -S gnome-control-center ibus ibus-chewing

# font
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji
# solve terminal emulator character overlap
sudo pacman -S ttf-dejavu

# install yay (in substitution for yaourt)
cd /tmp
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

cd ~
# add option gnome-tweak-tool -> Extensions -> Dash to dock
yay -S gnome-shell-extension-dash-to-dock # mustn't as root
# change theme with gnome-tweak-tool later
# theme
sudo pacman -S arc-gtk-theme
# icon theme
yay -S paper-icon-theme-git # mustn't as root

# Plymouth
yay -S plymouth # mustn't as root
# Add plymouth to the HOOKS array in mkinitcpio.conf.
# It must be added after base and udev for it to work.
# Example: HOOKS="base udev plymouth [...] "
sudo vim /etc/mkinitcpio.conf
# GRUB_CMDLINE_LINUX_DEFAULT="quiet splash [...] "
sudo vim /etc/default/grub
# generate the main configuration file of grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo mkinitcpio -p linux
# replace gdm with gdm-plymouth
sudo systemctl disable gdm
sudo pacman -R gdm
# libgdm-plymouth and libgdm are in conflict. Remove libgdm? [y/N] y
yay -S gdm-plymouth # mustn't as root
sudo systemctl enable gdm-plymouth.service

# Plymouth Theme
# example: Mageia ColdFire (https://www.opendesktop.org/c/1460735505)
wget -O 170783-Mageia-ColdFire.tar.gz <download_link>
tar zxvf 170783-Mageia-ColdFire.tar.gz
sudo cp -r Mageia-ColdFire/ /usr/share/plymouth/themes/
sudo plymouth-set-default-theme -R Mageia-ColdFire

sudo pacman -S firefox
# reboot to check if succeeded
``` 
#### Useful-tool  
```bash
# photo management
sudo pacman -S gthumb
# player
sudo pacman -S vlc
# PDF reader
sudo pacman -S okular
# file manager, console file manager
sudo pacman -S nautilus ranger
# sound server, sound server for headphone and the front end (GUI)
sudo pacman -S pulseaudio pulseaudio-jack pavucontrol
# Screen capture
sudo pacman -S deepin-screenshot
# Managing email, calendars, contacts, tasks, and notes
sudo pacman -S evolution
```
#### cron (crontab)
```bash
sudo pacman -S cronie
sudo systemctl enable cronie.service
sudo systemctl start cronie.service
```
#### Problem solution  
```bash
# error: libexiv2: signature from "Eli Schwartz <schwartz@archlinux.org>" is unknown trust
sudo pacman -S archlinux-keyring
# changing login screen background image mentioned above doesn't work
=> Disable "High Contrast" option at the top bar on the login screen
```
