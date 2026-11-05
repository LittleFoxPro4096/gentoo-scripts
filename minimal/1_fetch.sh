#!/bin/bash
## Downloading the essential files to install Gentoo.
set -e

MIRROR_URL="https://mirrors.ustc.edu.cn/gentoo/releases/amd64/autobuilds"

mkdir -pv cache
wget $MIRROR_URL/"latest-stage3-amd64-systemd.txt" -P cache
STAGE_PATH=`awk 'NR==3 {print $1}' cache/latest-stage3-amd64-systemd.txt`
wget $MIRROR_URL/$STAGE_PATH".sha256" -P cache
wget $MIRROR_URL/$STAGE_PATH -P cache
pushd cache
sed -n "/# SHA256 HASH/ {n;p}" *.sha256 | sha256sum --strict --check
popd
