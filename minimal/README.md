## Gentoo Linux Installation Scripts
#### Architecture: AMD64
#### Boot Method: GRUB, UEFI & GPT
#### Init System: Systemd
#### Handbook: <https://wiki.gentoo.org/wiki/Handbook:AMD64>

1. 下载必要的文件。

   ```sh
   # any user
   bash 1_fetch.sh
   ```

2. 参考[Gentoo文档](https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Disks)磁盘分区, 若无特殊需求, 推荐分配`EFI`分区和根目录分区。挂载分区, 需要注意的是, 此文档中Gentoo的根目录是`/mnt`, 而非`/mnt/gentoo`。

   ```sh
   # root
   bash 2_mount.sh
   ```

3. 解压`stage3`压缩包, 为`chroot`做准备工作。

   ```sh
   # root
   bash 3_stage.sh
   ```

4. 进入`chroot`环境。

   ```sh
   # root
   chroot /mnt /bin/bash
   ```

5. 安装基本系统。

   ```sh
   # (chroot) root
   source /etc/profile && export PS1="(chroot) ${PS1}"
   bash 4_base.sh
   env-update && source /etc/profile && export PS1="(chroot) ${PS1}"
   ```

6. 安装内核。

   ```sh
   # (chroot) root
   bash 5_kernel.sh
   ```
