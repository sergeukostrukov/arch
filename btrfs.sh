#!/bin/bash

#----------------------------------------------------------
# Функнция разметки партиции в формате btrfs и создание волеумов
# На входе  $root_part = партиция для системы
# На выходе партиция готовая к установки системы
#----------------------------------------------------------

btrfs() {
#mkfs.vfat -F32 /dev/$boot
mkfs.btrfs -f /dev/$root
mount /dev/$root /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@log
btrfs su cr /mnt/@pkg
#btrfs su cr /mnt/@.snapshots
btrfs su cr /mnt/@tmp
#btrfs su cr /mnt/@swap
umount -R /mnt
sub='rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,subvol'
sub1='nodatacow,subvol'
mount -o ${sub}=@ /dev/$root /mnt
#mkdir -p /mnt/{boot,home,var/log,var/cache/pacman/pkg,.snapshots,tmp,swap}
mkdir -p /mnt/{boot,home,var/log,var/cache/pacman/pkg,tmp}
mount -o ${sub}=@home /dev/$root /mnt/home
#mount -o ${sub}=@.snapshots /dev/$root /mnt/.snapshots
mount -o ${sub1}=@tmp /dev/$root /mnt/tmp
#mount -o ${sub1}=@swap /dev/$root /mnt/swap
mount -o ${sub1}=@log /dev/$root /mnt/var/log
mount -o ${sub1}=@pkg /dev/$root /mnt/var/cache/pacman/pkg
#-----назначить запрет копирования при записи----------
#chattr +C /mnt/swap
chattr +C /mnt/tmp
chattr +C /mnt/var/log
chattr +C /mnt/var/cache/pacman/pkg
}

#-------------end  btrfs-------------------------------------------
