#!/bin/bash
## Installing a stage tarball(https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Stage).
set -e

GENTOO_MIRROR_URL="https://mirrors.ustc.edu.cn/gentoo"
GENTOO_PORTAGE_MIRROR_URL="rsync://rsync.mirrors.ustc.edu.cn/gentoo-portage"

tar -xpvf cache/stage3-*.tar.xz --xattrs-include="*.*" --numeric-owner -C /mnt
cat > /mnt/etc/portage/make.conf << EOF
COMMON_FLAGS="-march=native -O2 -pipe"
CFLAGS="\${COMMON_FLAGS}"
CXXFLAGS="\${COMMON_FLAGS}"
FCFLAGS="\${COMMON_FLAGS}"
FFLAGS="\${COMMON_FLAGS}"
L10N="zh-CN"
MAKEOPTS="-j$(nproc)"
GENTOO_MIRRORS="$GENTOO_MIRROR_URL"
EMERGE_DEFAULT_OPTS="--quiet --verbose --jobs 4"
GRUB_PLATFORMS="efi-64"
EOF
mkdir -pv /mnt/etc/portage/repos.conf
cat > /mnt/etc/portage/repos.conf/gentoo.conf << EOF
[DEFAULT]
main-repo = gentoo

[gentoo]
location = /var/db/repos/gentoo
sync-type = rsync
sync-uri = $GENTOO_PORTAGE_MIRROR_URL
auto-sync = yes
sync-rsync-verify-jobs = 1
sync-rsync-verify-metamanifest = yes
sync-rsync-verify-max-age = 24
sync-openpgp-key-path = /usr/share/openpgp-keys/gentoo-release.asc
sync-openpgp-key-refresh-retry-count = 40
sync-openpgp-key-refresh-retry-overall-timeout = 1200
sync-openpgp-key-refresh-retry-delay-exp-base = 2
sync-openpgp-key-refresh-retry-delay-max = 60
sync-openpgp-key-refresh-retry-delay-mult = 4
EOF
cp -v /etc/resolv.conf /mnt/etc
mount --types proc /proc /mnt/proc
mount --rbind /sys /mnt/sys
mount --make-rslave /mnt/sys
mount --rbind /dev /mnt/dev
mount --make-rslave /mnt/dev
mount --bind /run /mnt/run
mount --make-slave /mnt/run
if [ -L /dev/shm ]; then
  rm -rf /dev/shm
  mkdir -v /dev/shm
  mount --types tmpfs --options nosuid,nodev,noexec shm /dev/shm
  chmod 1777 /dev/shm
fi
