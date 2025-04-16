#!/bin/bash
#--------!!!!!!!!! ne root____!!!!!!!!
# Скрипт запускать из корневой домашней директории пользователя
# Установка YAY срабатывает только от имени обычного
# пользователя имеющего права sudo

clear
sudo pacman -S libreoffice-still libreoffice-still-ru --noconfirm

#----------SHRIFT----------------
sudo pacman -S ttf-caladea ttf-carlito ttf-dejavu ttf-liberation ttf-linux-libertine-g noto-fonts adobe-source-code-pro-fonts adobe-source-sans-fonts adobe-source-serif-fonts --noconfirm

yay -S ttf-gentium-basic ttf-ms-fonts
