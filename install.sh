#!/bin/bash

#setfont ter-v32b

# Подключаем функции из других скриптов
suurce ./stop_ # заглушка остановить и осмотрерься


source ./internet_connect.sh
source ./select_disk.sh
source ./disk_partition.sh
source ./sel_met_part.sh
source ./select_partitions.sh


#_____ОСНОВНАЯ ПРОГРАММА________

# подключаем интернет
internet_connect

# Выбираем диск
select_disk

# Шаг : Разметка
# Выбор метода разметки РАЗМЕТКА
sel_met_part "$DISK"

# Размечаем разделы
select_partitions "$DISK"
stop_
nazn_part


stop_ # Проверяем результат

