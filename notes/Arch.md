### Notes-Arch  

#### Problem solution  
stuck on boot (displaying \_)  
```bash
# method 1
1.boot into live usb with arch iso installed
2.mount /dev/sdxx properly(ex.mount /dev/sda3 /mnt)
3.arch-chroot /mnt
4.pacman -Syu
5.poweroff
6.remove live usb and boot
# method 2: downgrade kernel version
1.boot into live usb with arch iso installed
2.mount /dev/sdxx properly(ex.mount /dev/sda3 /mnt)
3.arch-chroot /mnt
4.pacman -U /var/cache/pacman/pkg/linux-4.20.3.arch1-1-x86_64.pkg.tar.xz # example filename
5.poweroff
6.remove live usb and boot
```
