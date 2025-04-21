#!/bin/bash

# Функция установки rEFInd и настройки двойной загрузки
install_refind_with_windows() {
    local boot_partition="$1"  # Получаем раздел EFI (например, "nvme0n1p1")

    # Проверка наличия аргумента
    if [[ -z "$boot_partition" ]]; then
        echo "Ошибка: Укажите EFI-раздел как параметр (например, nvme0n1p1)"
        return 1
    fi

    # Пути монтирования (для установки Arch)
    local efi_mount_point="/mnt/boot/efi"
    local dev_path="/dev/${boot_partition}"

    # Проверка существования раздела
    if [[ ! -b "$dev_path" ]]; then
        echo "Ошибка: Раздел $dev_path не найден!"
        return 1
    fi

    # Создаем точку монтирования, если не существует
    echo "Создаем точку монтирования EFI..."
    mkdir -p "$efi_mount_point" || {
        echo "Не удалось создать $efi_mount_point"
        return 1
    }

    # Монтируем EFI-раздел
    echo "Монтируем EFI-раздел $dev_path в $efi_mount_point..."
    mount "$dev_path" "$efi_mount_point" || {
        echo "Ошибка монтирования EFI-раздела!"
        return 1
    }

    # Установка rEFInd через pacman
    echo "Устанавливаем пакет refind..."
    pacman -Sy refind --noconfirm || {
        echo "Ошибка установки refind!"
        umount "$efi_mount_point"
        return 1
    }

    # Установка загрузчика
    echo "Устанавливаем rEFInd в EFI-систему..."
    refind-install --root /mnt || {
        echo "Ошибка выполнения refind-install!"
        umount "$efi_mount_point"
        return 1
    }

    # Настройка конфига rEFInd
    local refind_conf="/mnt/boot/efi/EFI/refind/refind.conf"
    echo "Настраиваем конфигурационный файл rEFInd..."

    # Резервная копия конфига
    cp "$refind_conf" "${refind_conf}.bak"

    # Включаем сканирование других ОС
    sed -i 's/#scan_all_linux_kernels false/scan_all_linux_kernels true/' "$refind_conf"
    sed -i 's/#scanfor internal,external,optical,manual/scanfor internal,external,manual/' "$refind_conf"

    # Добавляем ручную запись для Windows (если автоматика не сработает)
    if ! grep -q "Windows Boot Manager" "$refind_conf"; then
        echo -e "\n# Ручная запись для Windows 11" >> "$refind_conf"
        echo 'menuentry "Windows 11" {' >> "$refind_conf"
        echo '    loader /EFI/Microsoft/Boot/bootmgfw.efi' >> "$refind_conf"
        echo '    icon /EFI/refind/icons/os_win.png' >> "$refind_conf"
        echo '}' >> "$refind_conf"
    fi

    # Обновляем initramfs (для корректного обнаружения ядер)
    echo "Обновляем initramfs..."
    arch-chroot /mnt mkinitcpio -P || {
        echo "Ошибка обновления initramfs!"
        return 1
    }

    # Фиксируем загрузчик в UEFI
    echo "Добавляем rEFInd в UEFI-загрузку..."
    efibootmgr --create --disk "/dev/$(echo $boot_partition | sed 's/[0-9]*$//')" \
               --part "$(echo $boot_partition | grep -o '[0-9]*$')" \
               --loader /EFI/refind/refind_x64.efi \
               --label "rEFInd Boot Manager" \
               --verbose

    # Размонтируем EFI-раздел
    umount "$efi_mount_point"

    echo -e "\n[УСПЕШНО] rEFInd установлен и настроен для двойной загрузки с Windows 11!"
    echo "Проверьте настройки в файле: $refind_conf"
}

# Пример вызова функции
# install_refind_with_windows "nvme0n1p1"
