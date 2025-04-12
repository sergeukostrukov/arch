#!/bin/bash




#################################################################
#-----назначение переменных----------
region="Europe/Moscow"
name="ArchLinux"
mirror_="RU,NL"
#################################################################
#################################################################


#  остановка до нажатия клавиши
stop_() {
 # Остановка до нажатия клавиш
    read -p "Press key to continue.. " -n1 -s
}

#======================================================
#          функция-Подключение к Internet
#======================================================

internet_connect() {
clear
#--------fynction  "mywifi"----- WIFI conect-------------
mywifi() {
#clear
iwctl device list
read -p '                                                      -> Введите определившееся значение, например "wlan0" : ' namelan
iwctl station $namelan scan
iwctl station $namelan get-networks
read -p '                                                      -> Введите название из списка  namewifi : ' namewifi
iwctl station $namelan connect $namewifi
iwctl station $namelan show
sleep 5
         }
#-------------------------------------------------------
#clear
echo '


                there is an Internet connection
		        	ПОДКЛЮЧЕНИЕ  INTERNET

            
                 
'
PS3="Выберите тип соединения 1 или 2  если 3 - FORWARD не настраивать  4 - Прервать установку EXIT :"
select choice in "WiFi" "Lan" "Продолжить не настраивая FORWARD" "Выйти из установки EXIT"; do
case $REPLY in
    1) mywifi;break;;
    2) systemctl restart dhcpcd ;dhcpcd;break;;
    3) break;;
    4) echo "see you next time";exit;;
    *) echo "Неправильный выбор !";;
esac
done
echo "     Проверка подключения к Enternet"
pacman -Syy termius-font
setfont ter-v32b
#ping -c 10 8.8.8.8  || exit
#clear
echo '
                 there is an Internet connection!!!!!!
                      Есть подключение !!!!!!!!'
                   }

#--------------------------------------------------
fontset() {
#------------Localizaciya-------------------------------
sed -i s/'#en_US.UTF-8'/'en_US.UTF-8'/g /etc/locale.gen
sed -i s/'#ru_RU.UTF-8'/'ru_RU.UTF-8'/g /etc/locale.gen
echo 'LANG=ru_RU.UTF-8' > /etc/locale.conf
echo 'KEYMAP=ru' > /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf
#setfont cyr-sun16
#setfont ter-132b
#------------------
#pacman -Syy terminus-font
setfont ter-v32b
}
#-----------------------------------------------------
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
            export DISK  # <-- Добавьте эту строку
            return 0
        else
            echo "Ошибка: введите число от 1 до ${#device_list[@]}"
        fi
    done


}


#--------------Disk_partition---------------------------------------------------------------

# Функция для интерактивной разметки диска
    
disk_partition() {
    # Проверка, определена ли переменная DISK
    if [[ -z "$DISK" ]]; then
        echo "Ошибка: переменная DISK не задана. Сначала выберите диск!"
        exit 1
    fi

    # Формирование полного пути к диску
    local disk="/dev/$DISK"
    
    # Проверка наличия диска
    if [[ ! -b "$disk" ]]; then
        echo "Ошибка: Устройство $disk не найдено!"
        return 1
    fi

    # Предупреждение об удалении данных
    read -p "ВСЕ ДАННЫЕ НА $disk БУДУТ УДАЛЕНЫ! Продолжить? (y/N): " confirm
    [[ "$confirm" != "y" ]] && return 1

    # Очистка диска и создание GPT
    wipefs --all "$disk"
    printf "g\nw" | fdisk "$disk" >/dev/null 2>&1

    # Основной цикл создания разделов
    local remaining_sectors=$(fdisk -l "$disk" | grep "Диск $disk" | awk '{print $5}')
    local part_num=1

    while :; do
        # Выбор типа раздела
        echo "──────────────────────────────────────────────────────"
        echo "Доступное пространство: $((remaining_sectors / 2 / 1024))МБ"
        echo "1. EFI System (обязательно)"
        echo "2. Linux Filesystem"
        echo "3. Swap"
        echo "4. Другой тип"
        echo "5. Завершить разметку"
        read -p "Выберите тип раздела (1-5): " type_choice

        case $type_choice in
            1)
                # EFI раздел
                type_code="1"
                default_size=512
                ;;
            2)
                # Linux Filesystem
                type_code="20"
                default_size=$((remaining_sectors / 2 / 1024 - 1))
                ;;
            3)
                # Swap
                type_code="19"
                default_size=""
                ;;
            4)
                read -p "Введите HEX-код типа: " type_code
                default_size=""
                ;;
            5)  break ;;
            *)  echo "Неверный выбор"; continue ;;
        esac

        # Ввод размера раздела
        while :; do
            read -p "Размер в МБ [по умолчанию: ${default_size}]: " size
            size=${size:-$default_size}
            
            # Конвертация в секторы (1 сектор = 512Б)
            sectors=$((size * 1024 * 2))
            
            if (( sectors <= remaining_sectors )); then
                remaining_sectors=$((remaining_sectors - sectors))
                break
            else
                echo "Недостаточно места! Доступно: $((remaining_sectors / 2 / 1024))МБ"
            fi
        done

        # Создание раздела
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

    # Создание последнего раздела на всё оставшееся пространство
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
    # Остановка до нажатия клавиш
    read -p "Press key to continue.. " -n1 -s
}

# Пример использования:
# export DISK="sda"
# disk_partition

### Основные особенности:
# 1. Интерактивное меню выбора типа раздела
# 2. Динамический расчет доступного пространства
# 3. Возможность создания:
#    - Обязательного EFI раздела
#    - Неограниченного количества разделов
#    - Swap-раздела
#    - Разделов с произвольными типами
# 4. Валидация вводимых размеров
# 5. Автоматическое создание последнего раздела на всё пространство
# 6. Подробные предупреждения о потере данных

### Улучшения по сравнению с оригиналом:
# 1. Сохранение данных до подтверждения
# 2. Гибкая настройка размеров
# 3. Возможность создания дополнительных разделов
# 4. Безопасная работа с пространством
# 5. Поддержка разных типов разделов

#     конец disk_partition
#===========================================================================================


# функция разбиения диски на партиции по умолчанию 
# удаляется полностью вся разметка и создиется GPT заново 
# 1 радел 512Мгб EFI System
# 2 раздел всё остальное Linux FileSystem
# входные данные - $DISK-диск для разметки
fdisk_() {
wipefs --all /dev/$DISK
(
echo g;
echo n;
echo ;
echo ;
echo +512M;
echo n;
echo ;
echo ;
echo ;
echo t;
echo 1;
echo 1;
echo t;
echo ;
echo 20;
echo w;
) | fdisk /dev/$DISK
}
#----------------end fdisk_----------------------------------------------

##---------Разметка диска выбор способа--------------------------------------

sel_met_part(){
clear
lsblk -f /dev/$DISK
fdisk -l /dev/$DISK
PS3="Выбирете действие :"
select choice in  "УНИВЕРСАЛЬНЫЙ" "AUTOMAT" "ERASE all and cfdisk SAMOST. " "NOT ERASE cfdisk WINDOWS!!!!! " "NOT ERASE NOT cfdisk" "EXIT"; do
case $REPLY in
    1) disk_partition;break;;
    2) fdisk_ || exit;break;;
    3) wipefs --all /dev/$DISK;cfdisk /dev/$DISK || exit;break;;
    4) cfdisk /dev/$DISK || exit;break;;
    5) echo "see you next time";break;;
    6) exit;;
    *) echo "Wrong choice!";;
esac
done
}
#========================конец set_met_partition=================================
############################################################################################

part_nazn() {
#-------------Диалог назначение партиций для boot root--------------------------------------
clear
lsblk -f /dev/$DISK
fdisk -l /dev/$DISK
echo '
            UKAZITE NAZBANIE PARTICII !!!<< '$DISK '>>!!! boot end root'
read -p "
        POLNOE NAZBANIE PARTICII (sda1...nvme0n1p1....) boot: -> Введите значение : " boot_part
read -p "
        POLNOE NAZBANIE PARTICII (sdb2...nvme0n1p2....) root: -> Введите значение : " root_part


echo '                Вы выьрали Disk = '$DISK
echo '                           boot = '$boot_part
echo '                           root = '$root_part
sleep 3
}
############################################################################################

#_______________Функция подготовки BOOT партиции
mkboot() {
    clear
    echo "
            ВНИМАНИЕ!! AHTUN!!! ATTENTION!!!    
    ЕСЛИ УСТАНОВКА РЯДОМ С WINDOWS и ЧТОБ РАБОТАЛИ ОБЕ СИСТЕМЫ ТО - 1
    ЕСЛИ ОДИН ЛИНУКС ИЛИ РАЗДЕЛ BOOT ОТДЕЛЬНО ОТ ВИНДОВС ТО - 2 "
    mntEFI1() {
    # не форматируктся раздел boot
    mkdir -p /mnt/boot/efi
    mount /dev/$boot_part /mnt/boot/efi  # EFI-раздел
            }
    mntEFI2(){
        # форматируется раздел boot
        mkfs.vfat -F32 /dev/$boot_part
        mkdir -p /mnt/boot/efi
        mount /dev/$boot_part /mnt/boot/efi  # EFI-раздел

                 }        
    PS3="1 Если выбрана партиция boot WINDOWS то не форматировать!!! 2 Если один линукс  :"
    select choice in "НЕ ФОРМАТИРОВАТЬ EFI- Windows!" "format mkfs.vfat BOOT" "Выйти из установки EXIT"; do
    case $REPLY in
        1) mntEFI1;break;;
        2) mntEFI2;break;;
        3) echo "Выхо из программы";exit;;
        *) echo "Неправильный выбор !";;
    esac
    done
}
#----------------------конец mkboot-------------------------------------------------------------------


#----------------------------------------------------------
# Функнция разметки партиции в формате btrfs и создание волеумов
# На входе  $root_part = партиция для системы
# На выходе партиция готовая к установки системы
#----------------------------------------------------------
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
#-------------end  btrfs-------------------------------------------
#====================================================================

#__________Обновление ключей и репозитариев для уверенной установки_____
reflector_() {
pacman -Syy archlinux-keyring --noconfirm
pacman -Syy reflector --noconfirm
#reflector --sort rate -l 20 --save /etc/pacman.d/mirrorlist
#reflector --verbose -c 'Russia' -l 10 -p https --sort rate --save /etc/pacman.d/mirrorlist
reflector --verbose -c $mirror_ -l 20 -p https --sort rate --save /etc/pacman.d/mirrorlist
#pacman -Syy archlinux-keyring --noconfirm
#------------------------Настройка Pacman--------------------------------|
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
sed -i s/'#ParallelDownloads = 5'/'ParallelDownloads = 10'/g /etc/pacman.conf
sed -i s/'#VerbosePkgLists'/'VerbosePkgLists'/g /etc/pacman.conf
sed -i s/'#Color'/'ILoveCandy'/g /etc/pacman.conf
}
#------------------------------------------------------------------------

kernel() { 
#--------------------выбор ядра linux---------------------------------------
kernel1='pacstrap -i /mnt base base-devel linux-zen linux-zen-headers linux-firmware ntfs-3g btrfs-progs amd-ucode intel-ucode iucode-tool archlinux-keyring nano mc vim dhcpcd dhclient networkmanager wpa_supplicant iw --noconfirm'
kernel2='pacstrap -i /mnt base base-devel linux linux-headers linux-firmware ntfs-3g btrfs-progs amd-ucode intel-ucode iucode-tool archlinux-keyring nano mc vim dhcpcd dhclient networkmanager wpa_supplicant iw --noconfirm'
PS3="Выбирете действие :"
select choice in "Linux-zen"  "Linux" "EXIT"; do
case $REPLY in
    1) kernel=${kernel1};break;;
    2) kernel=${kernel2};break;;
    3) exit;;
    *) echo "Wrong choice!";;
esac
done
}
#--------------------end-выбор ядра-----------------------------------------------------
#
#-----------------------------------------------------------------------------
# Функция записывает в переменную $password пароль root
# записывает имя пользователя в переменную $username 
# пароль пользователя $userpassword
# затем эти переменные далее будут записаны в систему
#-----------------------------------------------------------------------------
users_() {
#----------------Настройка пользователей-----------------------------------
clear
echo '


                Введите пароль для пользователя  root


'
while true; do
  read -s -p "Password root: " password
  echo
  read -s -p "Password root(again): " password2
  echo
  [ "$password" = "$password2" ] && break
  echo "Please try again"
done

clear
echo '


                Назначьте имя и пароль для обычного пользователя


'
read -p "Username: " username
while true; do
  echo
  read -s -p "Password: " userpassword
  echo
  read -s -p "Password (again): " userpassword2
  echo
  [ "$userpassword" = "$userpassword2" ] && break
  echo "Please try again"
done
}
#Зти строки в программе вписывают пользователей в систему
#--------------------------------------------------------------------------------------------------------------
#arch-chroot /mnt /bin/bash -c "sed -i s/'# %wheel ALL=(ALL:ALL) ALL'/'%wheel ALL=(ALL:ALL) ALL'/g /etc/sudoers"
#echo "root:$password" | arch-chroot /mnt chpasswd
#arch-chroot /mnt /bin/bash -c "useradd -m -G wheel -s /bin/bash $username"
#echo "$username:$userpassword" | arch-chroot /mnt chpasswd
#--------------------------------------------------------------------------------------------------------------

#=============================================================================================================
ins_param() {
#__________________________Lokalizacia__________________________________________________
arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/$region /etc/localtime"
arch-chroot /mnt /bin/bash -c "hwclock --systohc"
arch-chroot /mnt /bin/bash -c "sed -i s/'#en_US.UTF-8'/'en_US.UTF-8'/g /etc/locale.gen"
arch-chroot /mnt /bin/bash -c "sed -i s/'#ru_RU.UTF-8'/'ru_RU.UTF-8'/g /etc/locale.gen"
arch-chroot /mnt /bin/bash -c "locale-gen"
arch-chroot /mnt /bin/bash -c "echo 'LANG=ru_RU.UTF-8' > /etc/locale.conf"
arch-chroot /mnt /bin/bash -c "echo 'KEYMAP=ru' > /etc/vconsole.conf"
arch-chroot /mnt /bin/bash -c "echo 'FONT=cyr-sun16' >> /etc/vconsole.conf"
arch-chroot /mnt /bin/bash -c "echo $name > /etc/hostname"
arch-chroot /mnt /bin/bash -c "echo '127.0.0.1 localhost' > /etc/hosts"
arch-chroot /mnt /bin/bash -c "echo '::1       localhost' >> /etc/hosts"
arch-chroot /mnt /bin/bash -c "echo '127.0.0.1 $name.localdomain $name' >> /etc/hosts"
#_________________________Pacman konfig_____________________________________
arch-chroot /mnt /bin/bash -c "sed -i s/'#ParallelDownloads = 5'/'ParallelDownloads = 10'/g /etc/pacman.conf"
arch-chroot /mnt /bin/bash -c "sed -i s/'#VerbosePkgLists'/'VerbosePkgLists'/g /etc/pacman.conf"
arch-chroot /mnt /bin/bash -c "sed -i s/'#Color'/'ILoveCandy'/g /etc/pacman.conf"
sed -i "/\[multilib\]/,/Include/"'s/^#//' /mnt/etc/pacman.conf
#  Включение пользователей в систему
arch-chroot /mnt /bin/bash -c "sed -i s/'# %wheel ALL=(ALL:ALL) ALL'/'%wheel ALL=(ALL:ALL) ALL'/g /etc/sudoers"
echo "root:$password" | arch-chroot /mnt chpasswd
#_____________настройка ядра линукс______________________ 
arch-chroot /mnt /bin/bash -c "mkinitcpio -P"
# подключение простого пользователя
arch-chroot /mnt /bin/bash -c "useradd -m -G wheel -s /bin/bash $username"
echo "$username:$userpassword" | arch-chroot /mnt chpasswd
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager"
}
#========================================================================
#!/bin/bash
#____________________________Функция ZRAM_ --------------------
zram_() {
pacstrap -i /mnt zram-generator --noconfirm
arch-chroot /mnt /bin/bash -c "echo '[zram0]' > /etc/systemd/zram-generator.conf"
arch-chroot /mnt /bin/bash -c "echo 'ram-size = ram / 3' >> etc/systemd/zram-generator.conf"
arch-chroot /mnt /bin/bash -c "echo 'ompression-algorithm = zstd' >> /etc/systemd/zram-generator.conf"
arch-chroot /mnt /bin/bash -c "echo 'wap-priority = 100' >> /etc/systemd/zram-generator.conf"
arch-chroot /mnt /bin/bash -c "echo 's-type = swap' >> /etc/systemd/zram-generator.conf"
}
#===========================================================================
grub_() {
    #_____________загрузка файлов загрузчика___ настройка __GRUB____________________
arch-chroot /mnt /bin/bash -c "pacman -Syy grub grub-btrfs efibootmgr --noconfirm"
Uefi="grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --no-nvram --removable /dev/$DISK"
arch-chroot /mnt /bin/bash -c "${Uefi}"
arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
}
#
##############################################################################################
##############################################################################################
#             ОСНОВНОЙ  МОДУЛЬ
##############################################################################################

# Подключаемся к интернету
internet_connect
# Включаем русский шрифт
fontset
# Выбираем Диск
select_disk
# Размечаем партиции
sel_met_part
# распределение партиций
part_nazn
# создание партиции загрузчика boot
mkboot
#  создание btrfs
 setup_btrfs
# настройка зеркал и загрузчика получение ключей
reflector_
#  установка ядра и системы
kernel
#  Создание fstab
genfstab -U /mnt >> /mnt/etc/fstab
#   users
users_
#  настройка параметров систкмы
ins_param


# Установка загрузчика
grub_

#
#________________________ZRAM_________________________________________________
clear
echo '

    Сейчас можно создать виртуальный диск в оперативной памяти и организовать на нем SWOP
    По умолчанию он займет 1/3 оперативной памяти
    В дальнейшем размер можно изменить в файле /etc/systemd/zram-generator.conf
    изменив параметр zram-size



'
PS3="Выберите действие :"
select choice in "SWAP  ZRAM" " NO ZRAM go step"; do
case $REPLY in
    1) zram_;break;;
    2) break;;
    *) echo "Wrong choice!";;
esac
done
#clear

#-----------------searh windows-----------------------
#Помогает загрузчику найти Windows для двойной загрузки
#Если GRUB не видит Windows, выполните в Arch:
searhwin() {
arch-chroot /mnt /bin/bash -c "pacman -S os-prober"
arch-chroot /mnt /bin/bash -c "sed -i s/'GRUB_TIMEOUT=5'/'GRUB_TIMEOUT=30'/g /etc/default/grub"
arch-chroot /mnt /bin/bash -c "sed -i s/'#GRUB_DISABLE_OS_PROBER=false'/'GRUB_DISABLE_OS_PROBER=false'/g /etc/default/grub"
arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
}
PS3="searh WINDOWS :"
select choice in "GAME OVER REBOOT"  "searh WINDOWS" "EXIT"; do
case $REPLY in
    1) arch-chroot /mnt /bin/bash -c "exit";umount -R /mnt;reboot;break;;
    2) searhwin;break;;
    3) exit;;
    *) echo "Wrong choice!";;
esac
done
#----------------end searh windows--------------------



