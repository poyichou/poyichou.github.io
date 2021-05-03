#!/bin/sh
# basic setup and graphic support after installation of ubuntu server
apt update && apt upgrade
apt install gdm3
apt install gnome-shell gnome-control-center gnome-tweaks gnome-shell-extensions arc-theme
apt install sakura vim
add-apt-repository ppa:snwh/ppa # for paper icon
apt install paper-icon-theme
apt install ibus ibus-chewing
apt install fonts-noto fonts-noto-cjk fonts-noto-color-emoji
# pip3 install --upgrade pip
# pip3 install paramiko
apt install gcc make libc6-dev-i386 liballegro4-dev zip python3-pip wireshark-qt # for development
apt install firefox nautilus
