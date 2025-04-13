#!/bin/bash

setfont ter-v32b

# Подключаем функции из других скриптов
source ./select_disk.sh
source ./disk_partition.sh
source ./select_partitions.sh

# Выбираем диск
select_disk "$DISK"

# Шаг 2: Разметка
disk_partition "$DISK"

# Размечаем разделы
select_partitions "$DISK"

# Проверяем результат
echo "Выбранные разделы:"
echo "BOOT: $boot_part"
echo "ROOT: $root_part"