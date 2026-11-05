#!/bin/bash
## Mounting the partition for new system.
set -e

read -p "The script should be executed after disk partition. Continue? [y/N] " CONFIRM
if [ x"$CONFIRM" != x"y" -a x"$CONFIRM" != x"Y" ]; then
  exit
fi

read -p "Enter the root partition: " ROOT
mount -v $ROOT /mnt
read -p "Mount the EFI partition? [y/N] " CONFIRM
if [ x"$CONFIRM" == x"y" -o x"$CONFIRM" == x"Y" ]; then
  read -p "Enter the EFI partition: " EFI
  mkdir -p /mnt/boot/efi
  mount -v $EFI /mnt/boot/efi
fi
lsblk
