#!/bin/bash

setfont ter-v32b

#################################################################
#-----назначение переменных----------
region="Europe/Moscow"
name="ArchLinux"
mirror_="RU,NL"
DISK="--"
export DISK
boot="--"
root="--"
#################################################################
#################################################################


# Подключаем функции из других скриптов


suurce ./stop_ # заглушка остановить и осмотрерься

source ./internet_connect.sh
source ./select_disk.sh
source ./disk_partition.sh
source ./sel_met_part.sh
source ./select_partitions.sh


#_____ОСНОВНАЯ ПРОГРАММА________

stop_ "$region" "$name" "$mirror_" "$DISK" "$boot" "$root"

# подключаем интернет
internet_connect
stop_ "$region" "$name" "$mirror_" "$DISK" "$boot" "$root"
# Выбираем диск
select_disk

stop_ "$region" "$name" "$mirror_" "$DISK" "$boot" "$root"
# Шаг : Разметка
# Выбор метода разметки РАЗМЕТКА
sel_met_part "$DISK"

stop_ "$region" "$name" "$mirror_" "$DISK" "$boot" "$root"

# Размечаем разделы
select_partitions "$DISK"
stop_ "$region" "$name" "$mirror_" "$DISK" "$boot" "$root"

nazn_part "$DISK"

stop_ "$region" "$name" "$mirror_" "$DISK" "$boot" "$root"


stop_ # Проверяем результат

