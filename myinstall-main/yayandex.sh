!/bin/bash
clear
#--------!!!!!!!!! ne root____!!!!!!!!
# Скрипт запускать из корневой домашней директории пользователя
# Установка YAY срабатывает только от имени обычного
# пользователя имеющего права sudo



sudo pacman -S git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay -S wget jq
yay -S yandex-browser
