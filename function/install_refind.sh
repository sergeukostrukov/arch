#!/bin/bash

install_refind() {
    # Проверка наличия смонтированного EFI раздела
    local efi_mount_point="/mnt/boot/efi"
    if ! mount | grep -q "$efi_mount_point"; then
        echo "Ошибка: EFI раздел не смонтирован в $efi_mount_point"
        return 1
    fi

    # Установка необходимых пакетов
    if ! pacman -Qs refind >/dev/null; then
        echo "Установка rEFInd..."
        pacman -Sy refind --noconfirm || return 1
    fi

    # Создание необходимых директорий
    mkdir -p "${efi_mount_point}/EFI/refind/drivers" || return 1

    # Копирование драйверов файловых систем для обнаружения Windows
    echo "Копирование драйверов NTFS..."
    cp /usr/share/refind/drivers_x64/* "${efi_mount_point}/EFI/refind/drivers/" || return 1

    # Установка rEFInd в EFI раздел
    echo "Установка rEFInd в EFI раздел..."
    refind-install \
        --root /mnt \
        --alldrivers \
        --yes \
        --localkeys \
        --keepname || return 1

    # Настройка конфигурации для двойной загрузки
    local refind_conf="${efi_mount_point}/EFI/refind/refind.conf"
    echo "Настройка конфигурации rEFInd..."
    
    # Включение сканирования всех дисков
    sed -i 's/#\(scan_all_linux_kernels\)/\1/' "$refind_conf"
    sed -i 's/#\(scan_for\)/\1/' "$refind_conf"
    
    # Добавление автоматического обнаружения Windows
    if ! grep -q "Windows Boot Manager" "$refind_conf"; then
        echo -e "\n# Автоопределение Windows" >> "$refind_conf"
        echo 'menuentry "Windows" {' >> "$refind_conf"
        echo '    icon /EFI/refind/icons/os_win.png' >> "$refind_conf"
        echo '    loader /EFI/Microsoft/Boot/bootmgfw.efi' >> "$refind_conf"
        echo '}' >> "$refind_conf"
    fi

    # Удаление возможных конфликтов с systemd-boot
    rm -f "${efi_mount_point}/EFI/systemd/systemd-bootx64.efi"
    rm -f "${efi_mount_point}/EFI/BOOT/BOOTX64.EFI"

    # Обновление ядерных образов
    if [ -d /mnt/boot ]; then
        kernel-install add-all /mnt/boot/vmlinuz-linux /mnt/boot/initramfs-linux.img
    fi

    echo "rEFInd успешно установлен!"
    echo "Не забудьте проверить настройки Secure Boot в BIOS"
}

# Пример вызова функции
# Убедитесь, что EFI раздел смонтирован в /mnt/boot/efi перед выполнением
# install_refind