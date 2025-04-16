#!/bin/bash

#################################################
#  Подключение принтера HP LJ P10005
#
#       http://localhost:631/admin
# 
# пользователя добавить в групу lp
#  sudo usermod -a -G имя_группы имя_пользователя
#
##################################################

sudo pacman -Sy cups ghostscript gsfonts

yay -S foo2zjs

sudo systemctl enable cups.service
sudo systemctl restart cups.service
