#!/bin/bash

#======================================================
# НАЗНАЧЕНИЕ ЭТОГО СКРИПТЕ ПРИМОНТИРОВАТЬ СИСТЕМУ
# ПРИ СБОЕ ЗАГРУЗЧИКА
#
# ЗАГРУЗИТСЯ С УСТАНОВОЧНОЙ ФЛЕШКИ И ЗАПУСТИТЬ СКРИПТ
# ДАЛЕЕ МОЖНО ПЕРЕУСТАНОВИТЬ ЗАГРУЗЧИК 
#======================================================

clear
lsblk
#------------Localizaciya-------------------------------
sed -i s/'#en_US.UTF-8'/'en_US.UTF-8'/g /etc/locale.gen
sed -i s/'#ru_RU.UTF-8'/'ru_RU.UTF-8'/g /etc/locale.gen
echo 'LANG=ru_RU.UTF-8' > /etc/locale.conf
echo 'KEYMAP=ru' > /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf
setfont cyr-sun16
locale-gen >/dev/null 2>&1; RETVAL=$?
#################################################################
#-----------Подключение к Enternet---------
#--------fynction  "mywifi"----- WIFI conect-------------
mywifi() {
#clear
iwctl device list
read -p '                                                              -> Введите определившееся значение, например "wlan0" : ' namelan
iwctl station $namelan scan
iwctl station $namelan get-networks
read -p '                                                              -> Введите название вашей сети из списка  : ' namewifi
iwctl station $namelan connect $namewifi
iwctl station $namelan show
sleep 5
 }
#-------------------------------------------------------
#clear
echo '



		        	ПОДКЛЮЧЕНИЕ  ENTERNET

            
                 
'
PS3="Выберите тип соединения 1 или 2  если 3 - не настраивать  4 - Прервать установку :"
select choice in "WiFi" "Lan" "Продолжить не настраивая" "Выйти из установки"; do
case $REPLY in
    1) mywifi;break;;
    2) systemctl restart dhcpcd ;dhcpcd;break;;
    3) break;;
    4) echo "see you next time";exit;;
    *) echo "Неправильный выбор !";;
esac
done
echo "     Проверка подключения к Enternet"
ping -c 10 8.8.8.8  || exit
clear
echo '


                Есть подключение !!!!!!!!'
sleep 2
#################################################################

############################################################################################
#-------------Диалог назначение партиций для boot root--------------------------------------
clear
lsblk -f
echo '
            Выбирете партиции для MOUNT разделов  BOOT b root'
read -p "
      Партиция зарузчика  boot: nvme0n1p1   sda1       -> Введите значение : " boot
read -p "
      Партиция системы Linux root:nvme0n1p2 sda2       -> Введите значение : " root


echo '                           boot = '$boot
echo '                           root = '$root
#sleep 3
PS3="Выберите действие :"
echo
select choice in "Продолжить с этими параметрами"  "Выйти из установки"; do
case $REPLY in
    1) break;;
    2) exit;;
    *) echo "Wrong choice!";;
esac
done

############################################################################################

#------------------------Монтирование------------------------------
sub='rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,subvol'
sub1='nodatacow,subvol'
mount -o ${sub}=@ /dev/$root /mnt
mount -o ${sub}=@home /dev/$root /mnt/home
mount -o ${sub1}=@tmp /dev/$root /mnt/tmp
mount -o ${sub1}=@log /dev/$root /mnt/var/log
mount -o ${sub1}=@pkg /dev/$root /mnt/var/cache/pacman/pkg
#-----назначить запрет копирования при записи----------
#chattr +C /mnt/swap
chattr +C /mnt/tmp
chattr +C /mnt/var/log
chattr +C /mnt/var/cache/pacman/pkg
#------------------------------------------------------
mount /dev/$boot /mnt/boot
arch-chroot /mnt
