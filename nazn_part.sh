#!/bin/bash

#-------------Функция назначение партиций для boot root--------------------------------------
# На входе переменная $DISK
# на выходе неременные $boot  $root
nazn_part() {
clear
lsblk -f /dev/$DISK
fdisk -l /dev/$DISK
echo '
            UKAZITE NAZBANIE PARTICII !!!<< '$DISK '>>!!! boot end root'
read -p "
        POLNOE NAZBANIE PARTICII (sda1...nvme0n1p1....) boot: -> Введите значение : " boot
read -p "
        POLNOE NAZBANIE PARTICII (sdb2...nvme0n1p2....) root: -> Введите значение : " root


echo '                Вы выьрали Disk = '$DISK
echo '                           boot = '$boot
echo '                           root = '$root
sleep 3
}