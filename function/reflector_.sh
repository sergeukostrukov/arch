#!/bin/bash

#__________Обновление ключей и репозитариев для уверенной установки_____
reflector_() {
pacman -Syy archlinux-keyring --noconfirm
pacman -Syy reflector --noconfirm
#reflector --sort rate -l 20 --save /etc/pacman.d/mirrorlist
#reflector --verbose -c 'Russia' -l 10 -p https --sort rate --save /etc/pacman.d/mirrorlist
reflector --verbose -c $mirror_ -l 20 -p https --sort rate --save /etc/pacman.d/mirrorlist
#pacman -Syy archlinux-keyring --noconfirm
#------------------------Настройка Pacman--------------------------------|
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
sed -i s/'#ParallelDownloads = 5'/'ParallelDownloads = 10'/g /etc/pacman.conf
sed -i s/'#VerbosePkgLists'/'VerbosePkgLists'/g /etc/pacman.conf
sed -i s/'#Color'/'ILoveCandy'/g /etc/pacman.conf
}
#------------------------------------------------------------------------

#reflector_   # команда запуска
