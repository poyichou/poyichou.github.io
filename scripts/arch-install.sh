#!/bin/sh

# Note:
#     Install archlinux on an "amd64" machine with "UEFI" by default.
#     To check whether your host running uefi or not, check /sys/firmware/efi exist or not.
#     Network connection and root privilege are required.
#     For those who are not using Virtualbox, comment out the "For virtualbox (efi)" block.


timedatectl set-ntp true

efi_gpt_partition() {
    # 
    # ============ GPT/UEFI Partition Table ==============
    # /boot     /dev/sda1 	EFI System Partition    511 M
    # [SWAP]    /dev/sda2 	Linux swap              1.5 G
    # /         /dev/sda3 	Linux                   rest 
    # ====================================================
    # 
    # both 
    #   parted /dev/sda --script set 1 esp on
    #   parted /dev/sda --script set 1 boot on
    # would work
    parted /dev/sda --script \
        mklabel gpt \
        mkpart ESP fat32 1MiB 512MiB \
        set 1 boot on \
        mkpart primary linux-swap 512MiB 2GiB \
        mkpart primary ext4 2GiB 100%
    mkfs.fat -F32 /dev/sda1
    mkfs.ext4 /dev/sda3
    # initialize partition for swap
    mkswap /dev/sda2
    swapon /dev/sda2
    
    # mount
    mount /dev/sda3 /mnt
    mkdir -p /mnt/boot/EFI
    mount /dev/sda1 /mnt/boot/EFI
}

bios_mbr_partition() {
    # ============ MBR/BIOS Partition Table ==============
    # [SWAP]    /dev/sda1 	Linux swap              1   G
    # /         /dev/sda2 	Linux                   rest 
    # ====================================================
    parted /dev/sda --script \
        mklabel msdos \
        mkpart primary linux-swap 1MiB 1GiB \
        mkpart primary ext4 1GiB 100% \
        set 2 boot on
    mkfs.ext4 /dev/sda2
    # initialize partition for swap
    mkswap /dev/sda1
    swapon /dev/sda1
    
    # mount
    mount /dev/sda2 /mnt
}

efi_gpt_partition
# different choice
#bios_mbr_partition

## select mirrors
#cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
## extract all the servers of Taiwan for old version of mirrorlist
#awk '
#/^## Taiwan$/ { f=1; print $0; next }
#f==0 { next }
#/^$/ { exit }
#{ print $0; f=0 }' /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist
## uncomment every mirror
#sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist
## only output the 6 fastest mirrors
##rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist

# Install the base packages
pacman -Sy --noconfirm archlinux-keyring
pacstrap /mnt base base-devel

# genfstab
genfstab -U /mnt >> /mnt/etc/fstab

# create a script to use afterward
echo "#!/bin/bash

echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
locale-gen
echo 'LANG=en_US.UTF-8' > /etc/locale.conf

# time zone
ln -sf /usr/share/zoneinfo/Asia/Taipei /etc/localtime
hwclock --systohc --utc

echo arch > /etc/hostname
echo '127.0.0.1	localhost.localdomain	localhost	 arch
::1	localhost.localdomain	localhost	 arch' >> /etc/hosts

# Initramfs
pacman -S --noconfirm linux linux-firmware
mkinitcpio -p linux

# boot loader (grub)
pacman -S --noconfirm grub efibootmgr
grub-install /dev/sda --target=x86_64-efi --bootloader-id=grub_uefi --recheck
# For MBR/BIOS
#grub-install /dev/sda
# For intel CPU
pacman -S --noconfirm intel-ucode
# For those who want to have dual OS with win10 installed
#pacman -S --noconfirm os-prober
#os-prober
# Generate the main configuration file
grub-mkconfig -o /boot/grub/grub.cfg

# create /home
mkdir /home
echo '/home created'

# Previous problem solution
# For virtualbox (efi) (Remember to enable EFI in Machine->System->Extended Features)
# Method1
#mkdir/boot/EFI/BOOT
#cp /boot/EFI/GRUB/grubx64.efi /boot/EFI/BOOT/BOOTX64.EFI
# Method2
#echo 'fs0:\EFI\grub\grubx64.efi' > /boot/startup.nsh

# Pre-installation
pacman -Syu --noconfirm --needed bash-completion gcc gdb vim openssh git valgrind dialog wget curl tmux zip unzip sudo wpa_supplicant netctl dhcpcd man-db man-pages texinfo

# Dhcpcd (Network)
systemctl enable dhcpcd.service

# ============================================================================
# ==================== Remember to change it after reboot ====================
# ============================================================================
# set defualt password
echo -e 'root\nroot' | passwd root
" > /mnt/archsetup.sh
# chroot
arch-chroot /mnt /bin/bash /archsetup.sh
rm -f /mnt/archsetup.sh

umount -R /mnt
sync
poweroff

# Remember to remove the installation media before booting again
