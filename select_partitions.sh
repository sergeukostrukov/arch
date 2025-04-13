#!/bin/bash

#--------------------------------------------------
#  Функция для выбора разделов на указанном диске
#  Входные данные диск с которым работать - $DISK
#  На выходе назначенные партиции 
#  $boot_part для  EFI System
#  $root_part для  ROOT
#  эти переменные передаются дальше другим функциям в скриптах
#-------------------------------------------------
select_partitions() {
    local target_disk=$1
    
    # Проверка наличия диска в системе
    if [[ ! -b "$target_disk" ]]; then
        echo "Ошибка: Устройство $target_disk не найдено!"
        exit 1
    fi

    # Получаем информацию о разделах диска
    local partitions
    
    partitions=$(lsblk -pln -o NAME,SIZE,FSTYPE,TYPE,MOUNTPOINT "$target_disk" | awk 'NR>1')

    # Проверка наличия разделов
    if [[ -z "$partitions" ]]; then
        echo "На диске $target_disk не найдено разделов!"
        exit 1
    fi

    # Создаем массивы для хранения данных
    local part_numbers=()
    local part_list=()
    local i=1

    # Выводим заголовок
    echo "──────────────────────────────────────────────────────"
    echo "Диск: $target_disk"
    echo "Доступные разделы:"
    
    # Парсим информацию о разделах
    while IFS= read -r line; do
        read -r name size fstype type mountpoint <<< "$line"
        
        # Сохраняем разделы в массив
        part_numbers+=("$name")
        part_list+=("$i) $name | Размер: $size | Тип: ${fstype:-не задан} | Монтирование: ${mountpoint:-нет}")
        ((i++))
    done <<< "$partitions"

    # Выводим информацию о разделах
    printf "%s\n" "${part_list[@]}"
    echo "──────────────────────────────────────────────────────"

    # Функция для выбора раздела
    choose_partition() {
        local prompt=$1
        while :; do
            read -p "$prompt (1-$((i-1)) или 'пропустить': " choice
            # Обработка пропуска
            if [[ "$choice" == "пропустить" ]]; then
                echo "skip"
                return
            fi
            
            # Проверка корректности ввода
            if [[ "$choice" =~ ^[0-9]+$ ]] && 
               (( choice >= 1 && choice <= ${#part_numbers[@]} )); then
                echo "${part_numbers[$((choice-1))]}"
                return
            else
                echo "Некорректный ввод! Повторите попытку."
            fi
        done
    }

    # Выбор разделов
    echo "Выберите разделы (введите номер):"
    boot_part=$(choose_partition "  Раздел для /boot")
    root_part=$(choose_partition "  Раздел для /root")
    
    # Дополнительные разделы (пример для home)
    # home_part=$(choose_partition "  Раздел для /home")
    
    # Проверка выбора корневого раздела
    if [[ "$root_part" == "skip" ]]; then
        echo "Ошибка: Необходимо выбрать раздел для корневой файловой системы!"
        exit 1
    fi
}

# Пример использования:
# Выбираем диск (из предыдущего скрипта)
# select_disk
# DISK="/dev/sda" # Для теста

select_partitions "$DISK"

# Результаты выбора
echo "────────────────────────"
[[ "$boot_part" != "skip" ]] && echo "Boot раздел: $boot_part"
echo "Root раздел: $root_part"
# [[ "$home_part" != "skip" ]] && echo "Home раздел: $home_part"