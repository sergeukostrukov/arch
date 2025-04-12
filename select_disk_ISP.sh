#!/bin/bash

select_disk() {
    # Получаем список всех блочных устройств
    local devices
    devices=$(lsblk -pl -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT | grep -v "loop" | awk 'NR>1')

    # Проверяем наличие устройств
    if [[ -z "$devices" ]]; then
        echo "Не найдено доступных устройств!"
        exit 1
    fi

    # Собираем информацию и формируем вывод
    echo "Доступные устройства:"
    local i=1
    local device_list=()
    
    while IFS= read -r line; do
        # Парсим строку устройства
        read -r name size type fstype mountpoint <<< "$line"
        
        # Для дисков - добавляем в список выбора
        if [[ "$type" == "disk" ]]; then
            device_list+=("$name")
            # Вывод диска с номером
            printf "%2d) [DISK] %-8s | Размер: %s\n" "$i" "$name" "$size"
            ((i++))
        else
            # Вывод разделов/устройств без номера
            printf "    [%s] %-8s | Размер: %s" "$type" "$name" "$size"
            [[ -n "$fstype" ]] && printf " | ФС: %s" "$fstype"
            [[ -n "$mountpoint" ]] && printf " | Смонтирован: %s" "$mountpoint"
            printf "\n"
        fi
    done <<< "$devices"

    # Проверяем наличие дисков для выбора
    if [[ ${#device_list[@]} -eq 0 ]]; then
        echo "Не найдено доступных дисков!"
        exit 1
    fi

    # Организуем выбор
    while :; do
        echo -n "Введите номер диска (1-$((i-1))) или 'q' для выхода: "
        read -r choice
        
        # Выход по запросу
        [[ "$choice" == "q" ]] && exit 1
        
        # Проверка корректности ввода
        if [[ "$choice" =~ ^[0-9]+$ ]] && 
           (( choice >= 1 && choice <= ${#device_list[@]} )); then
            DISK="${device_list[$((choice-1))]##*/}" # <-- Изменено здесь
            return 0
        else
            echo "Ошибка: введите число от 1 до ${#device_list[@]}"
        fi
    done
}

# Вызываем функцию выбора
select_disk

# Результат
echo "Выбранный диск: $DISK"








select_disk() {
    # ... (остальная часть функции без изменений)

    # Организуем выбор
    while :; do
        echo -n "Введите номер диска (1-$((i-1))) или 'q' для выхода: "
        read -r choice
        
        # Выход по запросу
        [[ "$choice" == "q" ]] && exit 1
        
        # Проверка корректности ввода
        if [[ "$choice" =~ ^[0-9]+$ ]] && 
           (( choice >= 1 && choice <= ${#device_list[@]} )); then
            DISK="${device_list[$((choice-1))]##*/}" # <-- Изменено здесь
            return 0
        else
            echo "Ошибка: введите число от 1 до ${#device_list[@]}"
        fi
    done
}

# Вызываем функцию выбора
select_disk

# Результат
echo "Выбранный диск: $DISK"