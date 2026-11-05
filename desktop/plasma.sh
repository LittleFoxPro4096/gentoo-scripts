#!/bin/bash
## Installing KDE Plasma desktop environment.
set -e

cat >> /etc/portage/make.conf << "EOF"
VIDEO_CARDS="intel nvidia"
INPUT_DEVICES="libinput synaptics"
EOF
eselect profile list
read -p "Choose the expected profile: " ESELECT_PROFILE
eselect profile set $ESELECT_PROFILE
PACKAGES+="app-arch/p7zip app-arch/unrar "
PACKAGES+="media-fonts/source-code-pro media-fonts/wqy-zenhei "
PACKAGES+="app-i18n/fcitx app-i18n/fcitx-libpinyin app-i18n/kcm-fcitx "
PACKAGES+="media-sound/alsa-utils media-libs/mesa media-sound/pulseaudio x11-base/xorg-drivers x11-base/xorg-server "
PACKAGES+="kde-apps/ark kde-apps/dolphin media-gfx/flameshot kde-apps/gwenview kde-apps/kate kde-apps/konsole kde-apps/kwalletmanager kde-plasma/plasma-meta kde-apps/okular kde-plasma/plasma-pa "
emerge --ask n --autounmask --autounmask-write $PACKAGES
etc-update --automode -5
emerge --ask n $PACKAGES
emerge --ask n --update --deep --newuse @world
usermod -a -G video sddm
systemctl enable bluetooth sddm NetworkManager

cat > /etc/profile.d/im-config.sh << "EOF"
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
EOF
cat > /etc/polkit-1/rules.d/10-admin.rules << "EOF"
polkit.addAdminRule(function(action, subject) {
  return ["unix-group:wheel"];
});
EOF
