### Notes-Arch-basic-setup  

#### Basic setup after installation of Arch Linux with Script/arch-install.sh  
#### user  
```bash
# change root password
passwd root
useradd --create-home --groups wheel --shell /bin/bash bob
# change bob password
passwd bob
```
#### configuration  
```bash
export EDITOR=vim
visudo # comment out '%wheel ALL=(ALL) ALL'
wget -O .vimrc https://poyichou.github.io/notes/myvimrc
wget -O .bashrc https://poyichou.github.io/notes/mybashrc
```
#### gnome desktop  
```bash
pacman -S xorg xorg-xinit xterm xorg-xeyes xorg-xclock

pacman -S gnome
sudo systemctl enable gdm.service
sudo systemctl start gdm.service
```
#### other  
```bash
# For virtualbox
sudo pacman -S virtualbox-guest-utils # choose 2

sudo pacman -S firefox
```
