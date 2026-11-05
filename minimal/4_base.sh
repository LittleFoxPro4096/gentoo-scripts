#!/bin/bash
## Installing the Gentoo base system(https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Base).
set -e

HOSTNAME="Gentoo"
LANG="en_US.UTF-8"
TIMEZONE="Asia/Shanghai"

echo $HOSTNAME > /etc/hostname
ln -sfv ../usr/share/zoneinfo/$TIMEZONE /etc/localtime
echo "LANG=$LANG" > /etc/locale.conf
cat > /etc/locale.gen << "EOF"
en_US.UTF-8 UTF-8
zh_CN.UTF-8 UTF-8
EOF
locale-gen
cat > /etc/issue << "EOF"
Welcome to Gentoo Linux! (\l)
Kernel \r on an \m

EOF
nano /etc/security/passwdqc.conf
read -s -p "Changing password for root: " PASSWORD
echo root:$PASSWORD | chpasswd
read -p "Create a new user? [y/N] " CONFIRM
if [ x"$CONFIRM" == x"y" -o x"$CONFIRM" == x"Y" ]; then
  read -p "Enter the username: " USERNAME
  useradd -m -s /bin/bash -G wheel,audio,video,usb,cdrom $USERNAME
  read -s -p "Changing password for user $USERNAME: " PASSWORD
  echo $USERNAME:$PASSWORD | chpasswd
fi
emerge-webrsync
systemd-machine-id-setup
systemctl preset-all
