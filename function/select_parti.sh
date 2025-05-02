#!/bin/bash

#--------------------------------------------------
#  Функция для выбора разделов на указанном диске
#  Входные данные диск с которым работать - $DISK
#  формат (sda ... nvme0n1 ... без префикса /dev)
#  На выходе назначенные партиции 
#  $boot_part для  EFI System      13.04.25 19:05
#  $root_part для  ROOT
#
#  На выходе формат вида  /dev/sda1   /dev/sda2 !!!!
#
#  эти переменные передаются дальше другим функциям в скриптах
#-------------------------------------------------
#!/bin/bash

select_partitions() {
    local target_disk="/dev/$1"

    # Проверка наличия диска
    if [[ ! -b "$target_disk" ]]; then
        echo "Ошибка: Устройство $target_disk не найдено!"
        exit 1
    fi

    # Получаем ТОЛЬКО разделы (исключаем сам диск)
    local partitions
    partitions=$(lsblk -pln -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT "$target_disk" | awk '$4 == "part" {print $0}')

    if [[ -z "$partitions" ]]; then
        echo "На диске $target_disk нет разделов!"
        exit 1
    fi

    # Списки для вывода
    local part_numbers=()
    local part_list=()
    local i=1

    echo "──────────────────────────────────────────────────────"
    echo "Диск: $target_disk"
    echo "Доступные разделы:"

    # Парсим только разделы (part)
    while IFS= read -r line; do
        read -r name size fstype type mountpoint <<< "$line"
        part_numbers+=("$name")
        part_list+=("$i) $name | Размер: $size | Тип: ${fstype:-не задан} | Монтирование: ${mountpoint:-нет}")
        ((i++))
    done <<< "$partitions"

    printf "%s\n" "${part_list[@]}"
    echo "──────────────────────────────────────────────────────"

    # Функция выбора
    choose_partition() {
        local prompt=$1
        while :; do
            read -p "$prompt (1-$((i-1)) или 'пропустить': " choice
            if [[ "$choice" == "пропустить" ]]; then
                echo "skip"
                return
            fi
            if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#part_numbers[@]} )); then
                echo "${part_numbers[$((choice-1))]}"
                return
            else
                echo "Некорректный ввод!"
            fi
        done
    }

    echo "Выберите разделы:"
    boot_part=$(choose_partition "  Раздел для /boot")
    root_part=$(choose_partition "  Раздел для /root")

    if [[ "$root_part" == "skip" ]]; then
        echo "Ошибка: Выберите раздел для корневой системы (/root)!"
        exit 1
    fi
}

# Пример вызова:
DISK="sda"
select_partitions "$DISK"

echo "────────────────────────"
[[ "$boot_part" != "skip" ]] && echo "Boot: $boot_part"
echo "Root: $root_part"