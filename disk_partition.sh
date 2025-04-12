#!/bin/bash

disk_partition() {
    if [[ -z "$DISK" ]]; then
        echo "Ошибка: Сначала выберите диск через select_disk.sh!"
        exit 1
    fi

    # Убираем лишний /dev/ если он есть
    local disk="${DISK#/dev/}"
    disk="/dev/$disk"

    if [[ ! -b "$disk" ]]; then
        echo "Ошибка: Устройство $disk не найдено!"
        return 1
    fi

    read -p "ВСЕ ДАННЫЕ НА $disk БУДУТ УДАЛЕНЫ! Продолжить? (y/N): " confirm
    [[ "$confirm" != "y" ]] && return 1

    # Очистка диска
    wipefs --all "$disk" >/dev/null 2>&1
    printf "g\nw" | fdisk "$disk" >/dev/null 2>&1

    local remaining_sectors=$(fdisk -l "$disk" | grep "Disk $disk" | awk '{print $5}')
    local part_num=1

    while :; do
        echo "──────────────────────────────────────────────────────"
        echo "Доступное пространство: $((remaining_sectors / 2 / 1024))МБ"
        echo "1. EFI System (обязательно)"
        echo "2. Linux Filesystem"
        echo "3. Swap"
        echo "4. Другой тип"
        echo "5. Завершить разметку"
        read -p "Выберите тип раздела (1-5): " type_choice

        case $type_choice in
            1) type_code="1"; default_size=512 ;;
            2) type_code="20"; default_size=$((remaining_sectors / 2 / 1024 - 1)) ;;
            3) type_code="19"; default_size="" ;;
            4) read -p "Введите HEX-код типа: " type_code; default_size="" ;;
            5) break ;;
            *) echo "Неверный выбор"; continue ;;
        esac

        while :; do
            read -p "Размер в МБ [по умолчанию: ${default_size}]: " size
            size=${size:-$default_size}
            sectors=$((size * 1024 * 2))
            
            if (( sectors <= remaining_sectors )); then
                remaining_sectors=$((remaining_sectors - sectors))
                break
            else
                echo "Недостаточно места! Доступно: $((remaining_sectors / 2 / 1024))МБ"
            fi
        done

        (
            echo n
            echo $part_num
            echo 
            echo +${size}M
            echo t
            echo $type_code
            echo w
        ) | fdisk "$disk" >/dev/null 2>&1

        ((part_num++))
    done

    if (( remaining_sectors > 0 )); then
        (
            echo n
            echo $part_num
            echo 
            echo 
            echo w
        ) | fdisk "$disk" >/dev/null 2>&1
    fi

    echo "Разметка завершена!"
    fdisk -l "$disk"
    read -p "Нажмите любую клавишу для продолжения.. " -n1 -s
}