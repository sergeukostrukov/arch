setup_btrfs() { # ← функция переименована
    # Проверка переменных
    if [[ -z "$root_part" ]]; then
        echo "Ошибка: root_part не определена!"
        exit 1
    fi

    # Подтверждение форматирования
    read -p "Форматировать /dev/$root_part? (y/N) " -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi

    mkfs.btrfs -f "/dev/$root_part"
    mount "/dev/$root_part" /mnt

    # Создание подтомов с правильным синтаксисом
    btrfs subvolume create /mnt/@
    btrfs subvolume create /mnt/@home
    btrfs subvolume create /mnt/@log
    btrfs subvolume create /mnt/@pkg
    btrfs subvolume create /mnt/@tmp

    umount -R /mnt

    # Опции монтирования (nodatacow удалён)
    sub='rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,subvol'
    mount -o "${sub}=@" "/dev/$root_part" /mnt
    mkdir -p /mnt/{boot,home,var/log,var/cache/pacman/pkg,tmp}

    # Монтирование подтомов
    mount -o "${sub}=@home" "/dev/$root_part" /mnt/home
    mount -o "subvol=@tmp" "/dev/$root_part" /mnt/tmp
    mount -o "subvol=@log" "/dev/$root_part" /mnt/var/log
    mount -o "subvol=@pkg" "/dev/$root_part" /mnt/var/cache/pacman/pkg

    # Установка атрибутов nodatacow
    chattr +C /mnt/tmp
    chattr +C /mnt/var/log
    chattr +C /mnt/var/cache/pacman/pkg
}