#!/bin/bash
# Скрипт для установки rEFInd в Arch Linux с двойной загрузкой Windows 11
# Требования:
# - ESP смонтирована в /mnt/boot/efi (nvme0n1p1)
# - Основная система смонтирована в /mnt
# - Выполняется из окружения установщика (до arch-chroot)

# Функция установки
install_refind() {
    # Шаг 1. Переход в chroot-окружение
    echo ">>> Переходим в chroot-окружение"
    arch-chroot /mnt bash -c '
    
    # Шаг 2. Установка rEFInd и зависимостей
    echo ">>> Устанавливаем пакеты: refind efibootmgr"
    pacman -Sy --noconfirm refind efibootmgr || exit 1

    # Шаг 3. Копирование файлов rEFInd в ESP
    echo ">>> Устанавливаем rEFInd в ESP (/boot/efi)"
    refind-install --root /mnt 2>/dev/null || { 
        echo "!!! Ошибка refind-install. Копируем вручную...";
        mkdir -p /boot/efi/EFI/refind;
        cp -r /usr/share/refind/{refind_x64.efi,drivers_x64,icons,fonts} /boot/efi/EFI/refind/;
        cp /usr/share/refind/refind.conf-sample /boot/efi/EFI/refind/refind.conf;
    }

    # Шаг 4. Настройка конфигурации rEFInd
    echo ">>> Настраиваем refind.conf"
    CONFIG_FILE="/boot/efi/EFI/refind/refind.conf"
    # Включаем сканирование всех ядер
    sed -i "s/#scan_all_linux_kernels false/scan_all_linux_kernels true/g" "$CONFIG_FILE"
    # Добавляем запись для Windows
    if ! grep -q "Windows Boot Manager" "$CONFIG_FILE"; then
        echo -e "\n# Загрузчик Windows
menuentry \"Windows 11\" {
    loader /EFI/Microsoft/Boot/bootmgfw.efi
    icon /EFI/refind/icons/os_win.png
}" >> "$CONFIG_FILE"
    fi

    # Шаг 5. Создание UEFI-записи
    echo ">>> Создаем UEFI-запись для rEFInd"
    efibootmgr -c -d /dev/$boot -p 1 -L "rEFInd" -l "\\EFI\\refind\\refind_x64.efi" || exit 1

    # Шаг 6. Проверка наличия Windows
    echo ">>> Проверяем наличие загрузчика Windows"
    if [[ ! -f /boot/efi/EFI/Microsoft/Boot/bootmgfw.efi ]]; then
        echo "!!! Внимание: Файл bootmgfw.efi не найден! Проверьте ESP."
    fi

    # Шаг 7. Пересборка initramfs (опционально)
    echo ">>> Пересобираем initramfs"
    mkinitcpio -P

    echo ">>> Установка rEFInd завершена!"
    '
}

### Выполнение функции ###
boot="nvme0n1p1"
install_refind $boot

# После перезагрузки:
echo -e "\n\nПосле перезагрузки выполните:"
echo "1. В BIOS выберите rEFInd как загрузчик по умолчанию"
echo "2. Для тем оформления: pacman -S refind-theme-regular (из AUR)"
echo "3. Для Secure Boot: https://wiki.archlinux.org/title/Unified_Extensible_Firmware_Interface/Secure_Boot"