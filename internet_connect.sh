#!/bin/bash

#======================================================
#          функция-Подключение к Internet
#======================================================

internet_connect() {


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
#pacman -Syy termius-font
#setfont ter-v32b
#ping -c 5 8.8.8.8  || exit
#clear
echo '
                 there is an Internet connection!!!!!!
                      Есть подключение !!!!!!!!'
                   }

#--------------------------------------------------
#internet_connect  # вызов функции