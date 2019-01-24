### Notes-Arch  

#### Problem solution  
stuck at booting screen  
```bash
1.boot into live usb with arch iso installed
2.mount /dev/sdxx properly(ex.mount /dev/sda3 /mnt)
3.arch-chroot /mnt
4.pacman -Syu
5.poweroff
6.remove live usb and boot
```
