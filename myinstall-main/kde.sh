#!/bin/bash
#
#
#
# ЭТОТ ФАЙЛ НУЖНО ИСПОЛНЯТЬ ОТ ПОЛЬЗОВАТЕЛЯ ROOT
# или   sudo ./kde.sh
#
#
nmtui
#pacman -Sy reflector archlinux-keyring sl --noconfirm
#reflector --sort rate -l 20 --save /etc/pacman.d/mirrorlist
reflector --verbose -c RU -l 10 -p https --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syy
pacman -S sl --noconfirm
pacman -S xf86-video-intel xorg-server xorg-xinit xorg-drivers --noconfirm
pacman -S xf86-video-vesa --noconfirm
pacman -S plasma-meta --noconfirm
pacman -S plasma-wayland-session --noconfirm 
pacman -S kde-applications --noconfirm
#pacman -S plasma --noconfirm
pacman -S flatpak --noconfirm
pacman -S sddm --noconfirm
pacman -S bluez bluez-utils pulseaudio-bluetooth blueman
#pacman -S bluez bluez-utils pipewire-alsa pipewire-jack pipewire-pulse pipewire-zeroconf # --noconfirm
pacman -S cups --noconfirm
#-------Kodeki-to--yandex-browser
pacman -S gst-libav gst-plugins-bod gst-plugins-ugly --noconfirm

systemctl enable sddm
systemctl enable bluetooth
systemctl enable cups
localectl set-x11-keymap --no-convert us,ru pc105 "" grp:alt_shift_toggle
pacman -S timeshift --noconfirm
sl






