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
read -p '                                                              -> Введите название из списка  namewifi : ' namewifi
iwctl station $namelan connect $namewifi
iwctl station $namelan show
sleep 5
 }
#-------------------------------------------------------
#clear
echo '


                there is an Internet connection
		        	ПОДКЛЮЧЕНИЕ  INTERNET

            
                 
'
PS3="Выберите тип соединения 1 или 2  если 3 - FORWARD не настраивать  4 - Прервать установку EXIT :"
select choice in "WiFi" "Lan" "Продолжить не настраивая FORWARD" "Выйти из установки EXIT"; do
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
#clear
echo '
                 there is an Internet connection!!!!!!
                      Есть подключение !!!!!!!!'
