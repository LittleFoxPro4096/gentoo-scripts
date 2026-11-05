#!/bin/bash
## Installing the kernel and generating the system boot(https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Kernel).
set -e

ln -sfv /proc/self/mounts /etc/mtab
PACKAGES+="linux-firmware gentoo-sources genfstab genkernel gentoolkit grub "
emerge --ask n --autounmask --autounmask-write $PACKAGES
etc-update --automode -5
emerge --ask n $PACKAGES
emerge --ask n --update --deep --newuse @world
eselect kernel list
eselect kernel set 1
cd /usr/src/linux
make menuconfig
make -j$(nproc)
make modules_install -j$(nproc)
make install
genkernel --install initramfs

genfstab / >> /etc/fstab
cat /etc/fstab
read -p "Would you like to modify the /etc/fstab manully? [y/N] " CONFIRM
if [ x"$CONFIRM" == x"y" -o x"$CONFIRM" == x"Y" ]; then
  vim /etc/fstab
fi

read -p "Would you like to generate the system boot? [y/N] " CONFIRM
if [ x"$CONFIRM" == x"y" -o x"$CONFIRM" == x"Y" ]; then
  grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GENTOO
  vim /etc/default/grub
  grub-mkconfig -o /boot/grub/grub.cfg
fi

eclean-dist
eclean-pkg
