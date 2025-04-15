#!/bin/bash

setfont ter-v32b

#################################################################
#-----назначение переменных----------
region="Europe/Moscow"
name="ArchLinux"
mirror_="RU,NL"
#DISK="--"
export DISK="--"
boot="--"
root="--"
#################################################################
#################################################################


# Подключаем функции из других скриптов


source ./stop_.sh # заглушка остановить и осмотрерься

source ./internet_connect.sh
source ./select_disk.sh
source ./disk_partition.sh
source ./sel_met_part.sh
source ./select_partitions.sh


#_____ОСНОВНАЯ ПРОГРАММА________
clear
stop_ "$region" "$name" "$mirror_" "$DISK" "$boot" "$root"

# подключаем интернет
clear
internet_connect
clear
stop_ "$region" "$name" "$mirror_" "$DISK" "$boot" "$root"
# Выбираем диск
clear
select_disk

stop_ "$region" "$name" "$mirror_" "$DISK" "$boot" "$root"
# Шаг : Разметка
# Выбор метода разметки РАЗМЕТКА
clear
lsblk -f /dev/$DISK
fdisk -l /dev/$DISK
sel_met_part "$DISK"

stop_ "$region" "$name" "$mirror_" "$DISK" "$boot" "$root"

# Размечаем разделы
clear
select_partitions "$DISK"
stop_ "$region" "$name" "$mirror_" "$DISK" "$boot" "$root"
clear
nazn_part "$DISK"

stop_ "$region" "$name" "$mirror_" "$DISK" "$boot" "$root"


stop_ # Проверяем результат

