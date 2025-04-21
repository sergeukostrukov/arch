#!/bin/bash

#################################################################
#################################################################
#-----назначение переменных----------
namedisk=""
boot=""
root=""

#################################################################
region="Europe/Moscow"
name="ArchLinux"
mirror_="RU,NL"

#################################################################
#################################################################

clear
stop_() {
#---заглушка остановка для просмотра вывода комманд
read -p "Press key to continue.. " -n1 -s
}
#---------------------------------------------------------------------


setfont ter-v32b
#setfont cyr-sun16
#-----------Подключение к Enternet---------
#--------fynction  "mywifi"----- WIFI conect-------------
mywifi() {
#clear
iwctl device list
read -p '                                    -> Введите определившееся значение, например "wlan0" : ' namelan
iwctl station $namelan scan
iwctl station $namelan get-networks
read -p '                                    -> Введите название вашей сети из списка  : ' namewifi
iwctl station $namelan connect $namewifi
iwctl station $namelan show
sleep 5
 }
#-------------------------------------------------------
#clear
echo '



		        	ПОДКЛЮЧЕНИЕ  ENTERNET CONNECT 

            
                 
'
PS3="Выберите тип соединения 1 или 2  если 3 - не настраивать  4 - Прервать установку :"
select choice in "WiFi" "Lan" "ПРОПУСТИТЬ" "Прервать установку exit"; do
case $REPLY in
    1) mywifi;break;;
    2) systemctl restart dhcpcd ;dhcpcd;break;;
    3) break;;
    4) echo "see you next time";exit;;
    *) echo "Неправильный выбор !";;
esac
done
echo "     Проверка подключения к Enternet"
ping -c 3 8.8.8.8  || exit
#==========================================================================
mount /dev/$boot /mnt/boot/efi  # EFI-раздел
#==========================================================================
sub='rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,subvol'
sub1='nodatacow,subvol'
mount -o ${sub}=@ /dev/$root /mnt
mount -o ${sub}=@home /dev/$root /mnt/home
mount -o ${sub1}=@tmp /dev/$root /mnt/tmp
mount -o ${sub1}=@log /dev/$root /mnt/var/log
mount -o ${sub1}=@pkg /dev/$root /mnt/var/cache/pacman/pkg
#==========================================================================
arch-chroot /mnt