#!/bin/bash

# функция разбиения диски на партиции по умолчанию 
# удаляется полностью вся разметка и создиется GPT заново 
# 1 радел 512Мгб EFI System
# 2 раздел всё остальное Linux FileSystem
# входные данные - $DISK-диск для разметки
disk_() {
wipefs --all /dev/$DISK
(
echo g;
echo n;
echo ;
echo ;
echo +512M;
echo n;
echo ;
echo ;
echo ;
echo t;
echo 1;
echo 1;
echo t;
echo ;
echo 20;
echo w;
) | fdisk /dev/$DISK
}