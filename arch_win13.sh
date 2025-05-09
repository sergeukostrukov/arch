#!/bin/bash
clear
setfont cyr-sun16
echo '

                                     █████╗ ██████╗  ██████╗██╗  ██╗██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗
                                    ██╔══██╗██╔══██╗██╔════╝██║  ██║██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║
                                    ███████║██████╔╝██║     ███████║██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║
                                    ██╔══██║██╔══██╗██║     ██╔══██║██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║
                                    ██║  ██║██║  ██║╚██████╗██║  ██║██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
                                    ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝



'
sleep 2
clear
stop_() {
#---заглушка остановка для просмотра вывода комманд
read -p "Press key to continue.. " -n1 -s
}
#---------------------------------------------------------------------


setfont ter-v32b
#setfont cyr-sun16
#-----------Подключение к Enternet---------
#--------fynction  "mywifi"----- WIFI conect-------------
mywifi() {
#clear
iwctl device list
read -p '                                    -> Введите определившееся значение, например "wlan0" : ' namelan
iwctl station $namelan scan
iwctl station $namelan get-networks
read -p '                                    -> Введите название вашей сети из списка  : ' namewifi
iwctl station $namelan connect $namewifi
iwctl station $namelan show
#stop_
 }
#-------------------------------------------------------
#clear
echo '



		        	ПОДКЛЮЧЕНИЕ  INTERNET CONNECT

            
                 
'
PS3="└─ Выберите режим работы: :"
select choice in "WiFi" "Lan" "ПРОПУСТИТЬ" "Прервать установку exit"; do
case $REPLY in
    1) mywifi;break;;
    2) systemctl restart dhcpcd ;dhcpcd;break;;
    3) break;;
    4) echo "see you next time";exit;;
    *) echo "Неправильный выбор !";;
esac
done
echo "     Проверка подключения к Enternet"
ping -c 3 8.8.8.8  || exit
clear
echo '


                Есть подключение !!!!!!!!'
sleep 1
#################################################################
#################################################################
#-----назначение переменных----------
region="Europe/Moscow"
namepc="ArchLinux"
mirror_="RU,NL"

#################################################################
#################################################################
#####---------------диалог назначения namedisk-----------------------------
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
            namedisk="${device_list[$((choice-1))]##*/}" # <-- Изменено здесь: удаляет - /dev/
            export namedisk  # <-- Добавьте эту строку для передачи в другие скрипты
            return 0
        else
            echo "Ошибка: введите число от 1 до ${#device_list[@]}"
        fi
    done
}

# Запуск функции выбора диска для установки
select_disk

clear
echo "      
        Вы выбрали  =>  "$namedisk
echo "  
    Чтобы продолжить нажмите любую клавишу
    чтобы выйти с программы Ctrl + C"

stop_


############################################################################
#----------------Настройка пользователей-----------------------------------
# В ДАЛЬНЕЙШЕМ ЗНАЧЕНИЕ ПЕРЕМЕННЫХ БУДЕТ ЗАГРУЖЕНО В СИСТЕМУ
#
passwd_() {
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
#----------------------------------------------------
####################################################################
#-------------- Функция вывода переменных на экран tablo2-----
tablo2() {
clear
echo "
 
    Назначены следующие параметры:
"
echo "--------------------------------------------------------------
"
echo "Диск для установки = " $namedisk
echo "            Регион = " $region
echo " Регион где mirror = " $mirror_
echo "    Имя компьютера = " $namepc
echo "  Имя пользователя = " $username
echo""
echo "--------------------------------------------------------------"
echo "1-Продолжить с этими параметрами" "2-Изменить диск, регион, регион репозитория, имя компьютера " "3-Выйти из программы установки"
echo "--------------------------------------------------------------

"
}
##--------------функция переназначения переменных peremen2------------
peremen2() {

read -p "
             Регион например "Europe/Moscow"   -> Введите  : " region
read -p "
 Регион расположения репозитария "RU,NL" "US"  -> Введите  : " mirror_
read -p "
                        Имя компьютера NAME PC -> Введите  : " namepc

}

####-------------показываем tablo2------------------
tablo2

PS3="└─ Выберите  действие :"
echo
select choice in "ПРОДОЛЖИТЬ" "Изменить- регион, miror репозитория, name имя компьютера " "Выйти из установки EXIT"; do
case $REPLY in
    1) break;;
    2) peremen2;tablo2;;
    3) exit;;
    *) echo "Wrong choice!";;
esac
done
clear
####################################################################
#__Функция подготовки BOOT партиции
mkboot() {
    clear
PS3="└─ Выберите   :"
select choice in "Если загрузчик ставится в EFI- Windows!" "LINUX свой раздел  BOOT" "Выйти из установки EXIT"; do
case $REPLY in
    1) break;;
    2) mkfs.vfat -F32 /dev/$boot;break;;
    3) echo "see you next time";exit;;
    *) echo "Неправильный выбор !";;
esac
done
}
####################################################################
#__________Функция btrfs1_____________________________
btrfs1() {
#mkfs.vfat -F32 /dev/$boot
mkfs.btrfs -f /dev/$root
mount /dev/$root /mnt
btrfs su cr /mnt/@
btrfs su cr /mnt/@home
btrfs su cr /mnt/@log
btrfs su cr /mnt/@pkg
btrfs su cr /mnt/@.snapshots
btrfs su cr /mnt/@tmp
btrfs su cr /mnt/@swap
umount -R /mnt
sub='rw,noatime,compress=zstd:2,ssd,space_cache=v2,discard=async,subvol'
sub1='nodatacow,subvol'
mount -o ${sub}=@ /dev/$root /mnt
mkdir -p /mnt/{boot,home,var/log,var/cache/pacman/pkg,.snapshots,tmp,swap}
mount -o ${sub}=@home /dev/$root /mnt/home
mount -o ${sub}=@.snapshots /dev/$root /mnt/.snapshots
mount -o ${sub1}=@tmp /dev/$root /mnt/tmp
mount -o ${sub1}=@swap /dev/$root /mnt/swap
mount -o ${sub1}=@log /dev/$root /mnt/var/log
mount -o ${sub1}=@pkg /dev/$root /mnt/var/cache/pacman/pkg
#-----назначить запрет копирования при записи----------
chattr +C /mnt/swap
chattr +C /mnt/tmp
chattr +C /mnt/var/log
chattr +C /mnt/var/cache/pacman/pkg
#------------------------------------------------------
#mkdir /mnt/boot
#mount /dev/$boot /mnt/boot
mkdir -p /mnt/boot/efi
mount /dev/$boot /mnt/boot/efi  # EFI-раздел

#____________________Создание своп файла________________________________________
btrfs filesystem mkswapfile --size 8g --uuid clear /mnt/swap/swapfile
swapon /mnt/swap/swapfile
swap_fstab='echo "/swap/swapfile none swap defaults 0 0" >> /mnt/etc/fstab'
}
#################################################################################
#__________Функция btrfs2_____________________________
btrfs2() {
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
#------------------------------------------------------
#mkdir /mnt/boot
#mount /dev/$boot /mnt/boot
mkdir -p /mnt/boot/efi
mount /dev/$boot /mnt/boot/efi  # EFI-раздел

##____________________Создание своп файла________________________________________
#btrfs filesystem mkswapfile --size 8g --uuid clear /mnt/swap/swapfile
#swapon /mnt/swap/swapfile
swap_fstab=''
}
#################################################################################
#____________________________Функция ZRAM_ --------------------
zram_() {
pacstrap -i /mnt zram-generator --noconfirm
arch-chroot /mnt /bin/bash -c "echo '[zram0]' > /etc/systemd/zram-generator.conf"
arch-chroot /mnt /bin/bash -c "echo 'ram-size = ram / 3' >> etc/systemd/zram-generator.conf"
arch-chroot /mnt /bin/bash -c "echo 'ompression-algorithm = zstd' >> /etc/systemd/zram-generator.conf"
arch-chroot /mnt /bin/bash -c "echo 'wap-priority = 100' >> /etc/systemd/zram-generator.conf"
arch-chroot /mnt /bin/bash -c "echo 's-type = swap' >> /etc/systemd/zram-generator.conf"
}
#################################################################################

#----------Диалог разметки диска-------------------
clear
echo '





На диске должен быть тип GPT и создано минимум два раздела
 ->  boot  (512М если одно ядро) тип EFI System
 ->  root (остальное  пространство) тип  Linux filesystem
root пространство будет размечено в BTRFS и созданы subvolume необходимые для системы
можно по своему усмотрению создать ещё разделы

'
stop_
###########################################################################################
##---------------------Разметка диска--------------------------------------

disk_part(){
    while true; do  # Добавляем цикл while для обработки повторных входов без рекурсии
        clear    
        lsblk -f /dev/$namedisk
        fdisk -l /dev/$namedisk
        echo '---------------------------------'    
        
        fdisk_() {
            wipefs --all /dev/$namedisk
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
            ) | fdisk /dev/$namedisk
        }

        PS3="└─ Выберите действие: "
        select choice in "512М-boot остальное-root все данные удаляются" "Очистить диск" "Ручная разметка. Можно оставить разделы WINDOWS!!!!!" "ДАЛЬШЕ (Оставить с этими разделами)" "Завершить установку EXIT"; do
            case $REPLY in
                1) 
                    fdisk_ || exit
                    break  # Выходим из select и повторяем цикл while
                    ;;
                2) 
                    wipefs --all /dev/$namedisk || exit
                    break  # Выходим из select и повторяем цикл while
                    ;;
                3) 
                    cfdisk /dev/$namedisk || exit
                    break  # Выходим из select и повторяем цикл while
                    ;;
                4) 
                    echo "see you next time"
                    return 0  # Выходим из функции полностью
                    ;;
                5) 
                    exit
                    ;;
                *) 
                    echo "Неверный выбор!"
                    ;;
            esac
        done
    done
}

# Запуск функции разметки диска
disk_part $namedisk




############################################################################################
#-------------Диалог назначение партиций для boot root--------------------------------------

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


    root="${root_part[$((choose_partition))]##*/}" # <-- Изменено здесь: удаляет - /dev/
    export root
    boot="${boot_part[$((choose_partition))]##*/}" # <-- Изменено здесь: удаляет - /dev/
    export boot




    if [[ "$root_part" == "skip" ]]; then
        echo "Ошибка: Выберите раздел для корневой системы (/root)!"
        exit 1
    fi
}

# Вызов функции выбора партиций
clear
select_partitions "$namedisk"


# Показываем что выбрали
clear
echo "      Ваш выбор:"
echo "          boot=>$boot"
echo "          root=>$root"
echo "
        чтобы продолжить нажмите любую клавишу
        Выйти из программы => Ctrl + C  
        "
stop_


############################################################################################

clear
echo '

  ДИСК БУДЕТ РАЗМЕЧЕН В BTRFS
  Выберите вариант разметки субволумов :

  Вариант с swapfile                    Вариант без SWAPfile
      /@                                      /@
      /@home                                  /@home
      /@log                                   /@log       var/log
      /@pkg                                   /@pkg       var/cache/pacman/pkg
      /@.snapshots                            /@tmp
      /@tmp                              Будет предложено 
      /@swap   swapfile 8g               создать SWAP на ZRAM

'
PS3="└─ Выберите  действие :"
select choice in "Вариант с физическим swapfile"  "Вариант с возможностью создать виртуальный VIRTUAL ZRAM-SWAP" "EXIT"; do
case $REPLY in
    1) mkboot;btrfs1;break;;
    2) mkboot;btrfs2;break;;
    3) exit;;
    *) echo "Wrong choice!";;
esac
done


#--------------------выбор ядра linux---------------------------------------
clear

kernel1='pacstrap -i /mnt base base-devel linux-zen linux-zen-headers linux-firmware ntfs-3g btrfs-progs amd-ucode intel-ucode iucode-tool archlinux-keyring nano mc vim dhcpcd dhclient networkmanager wpa_supplicant iw terminus-font --noconfirm'
kernel2='pacstrap -i /mnt base base-devel linux linux-headers linux-firmware ntfs-3g btrfs-progs amd-ucode intel-ucode iucode-tool archlinux-keyring nano mc vim dhcpcd dhclient networkmanager wpa_supplicant iw terminus-font --noconfirm'
PS3="└─ Выберите  действие :"
select choice in "Linux-zen"  "Linux" "EXIT"; do
case $REPLY in
    1) kernel=${kernel1};break;;
    2) kernel=${kernel2};break;;
    3) exit;;
    *) echo "Wrong choice!";;
esac
done

#--------------------end-выбор ядра-----------------------------------------------------
#Uefi="grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=$name --no-nvram --removable /dev/$namedisk"
Uefi="grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --no-nvram --removable /dev/$namedisk"
#Uefi="grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB"

#------------------------Настройка Pacman--------------------------------|
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
sed -i s/'#ParallelDownloads = 5'/'ParallelDownloads = 10'/g /etc/pacman.conf
sed -i s/'#VerbosePkgLists'/'VerbosePkgLists'/g /etc/pacman.conf
sed -i s/'#Color'/'ILoveCandy'/g /etc/pacman.conf
clear
setfont cyr-sun16
echo '
───────────────────────────────────────────────────────────────|
──────────────────────
────────────────────── ██████╗  █████╗  ██████╗███╗   ███╗ █████╗ ███╗   ██╗
────────────────────── ██╔══██╗██╔══██╗██╔════╝████╗ ████║██╔══██╗████╗  ██║
──▒▒▒▒▒────▄████▄───── ██████╔╝███████║██║     ██╔████╔██║███████║██╔██╗ ██║
─▒─▄▒─▄▒──███▄█▀────── ██╔═══╝ ██╔══██║██║     ██║╚██╔╝██║██╔══██║██║╚██╗██║
─▒▒▒▒▒▒▒─▐████──█──█── ██║     ██║  ██║╚██████╗██║ ╚═╝ ██║██║  ██║██║ ╚████║
─▒▒▒▒▒▒▒──█████▄────── ╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝
─▒─▒─▒─▒───▀████▀─────────────────────────────────────────────────────────────────|

                       идет настройка зеркал скачивания пакетов
'
pacman -Syy archlinux-keyring --noconfirm
pacman -Syy reflector --noconfirm
#reflector --sort rate -l 20 --save /etc/pacman.d/mirrorlist
reflector --verbose -c 'Russia' -l 10 -p https --sort rate --save /etc/pacman.d/mirrorlist
#reflector --verbose -c $mirror_ -l 20 -p https --sort rate --save /etc/pacman.d/mirrorlist
pacman -Syy archlinux-keyring --noconfirm
#--------------------------------------------------------------
# диалог настройки пользователей 
setfont ter-v32b
passwd_
setfont cyr-sun16

#---------контроль получения значения переменных для пользователей
clear
setfont ter-v32b
echo 'Пароль рута='$password
echo 'пользователь='$username
echo 'пароль пользователя='$userpassword
stop_
setfont cyr-sun16
#-----------------------------------------------------------------

# загрузка ядра линукс
${kernel}
#------------------------------------------------------------------------
genfstab -U /mnt >> /mnt/etc/fstab
$swap_fstab
arch-chroot /mnt /bin/bash -c "ln -sf /usr/share/zoneinfo/$region /etc/localtime"
arch-chroot /mnt /bin/bash -c "hwclock --systohc"
arch-chroot /mnt /bin/bash -c "sed -i s/'#en_US.UTF-8'/'en_US.UTF-8'/g /etc/locale.gen"
arch-chroot /mnt /bin/bash -c "sed -i s/'#ru_RU.UTF-8'/'ru_RU.UTF-8'/g /etc/locale.gen"
arch-chroot /mnt /bin/bash -c "locale-gen"
arch-chroot /mnt /bin/bash -c "echo 'LANG=ru_RU.UTF-8' > /etc/locale.conf"
arch-chroot /mnt /bin/bash -c "echo 'KEYMAP=ru' > /etc/vconsole.conf"
arch-chroot /mnt /bin/bash -c "echo 'FONT=ter-v32b' >> /etc/vconsole.conf"
arch-chroot /mnt /bin/bash -c "echo $namepc > /etc/hostname"
arch-chroot /mnt /bin/bash -c "echo '127.0.0.1 localhost' > /etc/hosts"
arch-chroot /mnt /bin/bash -c "echo '::1       localhost' >> /etc/hosts"
arch-chroot /mnt /bin/bash -c "echo '127.0.0.1 $namepc.localdomain $namepc' >> /etc/hosts"
arch-chroot /mnt /bin/bash -c "sed -i s/'#ParallelDownloads = 5'/'ParallelDownloads = 10'/g /etc/pacman.conf"
arch-chroot /mnt /bin/bash -c "sed -i s/'#VerbosePkgLists'/'VerbosePkgLists'/g /etc/pacman.conf"
arch-chroot /mnt /bin/bash -c "sed -i s/'#Color'/'ILoveCandy'/g /etc/pacman.conf"
sed -i "/\[multilib\]/,/Include/"'s/^#//' /mnt/etc/pacman.conf
arch-chroot /mnt /bin/bash -c "sed -i s/'# %wheel ALL=(ALL:ALL) ALL'/'%wheel ALL=(ALL:ALL) ALL'/g /etc/sudoers"
echo "root:$password" | arch-chroot /mnt chpasswd

arch-chroot /mnt /bin/bash -c "useradd -m -G wheel -s /bin/bash $username"
echo "$username:$userpassword" | arch-chroot /mnt chpasswd
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager"
#
arch-chroot /mnt /bin/bash -c "mkinitcpio -P" # компиляция ядра для загрузчика

##############################################################################################
#________________________ZRAM_________________________________________________
clear
setfont ter-v32b
echo '

    Сейчас можно создать виртуальный диск в оперативной памяти и организовать на нем SWOP
    По умолчанию он займет 1/3 оперативной памяти
    В дальнейшем размер можно изменить в файле /etc/systemd/zram-generator.conf
    изменив параметр zram-size



'
PS3="└─ Выберите действие :"
select choice in "Подключить  ZRAM" " ДАЛЬШЕ"; do
case $REPLY in
    1) zram_;break;;
    2) break;;
    *) echo "Wrong choice!";;
esac
done
#clear
###################################################################################################
#===============  Функция zagruzcik ==========================================================================
zagruzchik(){ 
while true; do  # Добавляем цикл while для обработки повторных входов без рекурсии
   clear
   echo '
    ЕСЛИ ОДИН ЛИНУКС ДОСТАТОЧНО ТОЛЬКО 1)
    ЕСЛИ РЯДОМ С ВИНДОВС ТО ЕЩЕ НЕОБХОДИМО 2)
    
    '
    grub_() {
    #arch-chroot /mnt /bin/bash -c "mkinitcpio -P" # компиляция ядра для загрузчика
    #Установка пакетов загрузчика
    arch-chroot /mnt /bin/bash -c "pacman -Syy grub grub-btrfs efibootmgr --noconfirm"
    Uefi="grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --no-nvram --removable /dev/$namedisk"
    arch-chroot /mnt /bin/bash -c "${Uefi}"
    arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
    #---заглушка остановка для просмотра вывода команд
    stop_
    #--------------------------------------------------------------------
    }
    #-----------------searh windows grub-----------------------
    #Помогает загрузчику найти Windows для двойной загрузки
    #Если GRUB не видит Windows, выполните в Arch:
    searhwin() {
    arch-chroot /mnt /bin/bash -c "pacman -S os-prober --noconfirm"
    arch-chroot /mnt /bin/bash -c "sed -i s/'GRUB_TIMEOUT=5'/'GRUB_TIMEOUT=30'/g /etc/default/grub"
    arch-chroot /mnt /bin/bash -c "sed -i s/'#GRUB_DISABLE_OS_PROBER=false'/'GRUB_DISABLE_OS_PROBER=false'/g /etc/default/grub"
    arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
    #---заглушка остановка для просмотра вывода команд
    stop_   
    }
    PS3="└─ Выберите  :"
    select choice in "Установка GRUB"  "ПОИСК WINDOWS" "Командная строка- arch-chroot" "GAME OVER REBOOT" "EXIT из меню"; do
        case $REPLY in
        1) grub_;break;;                    # Выходим из select и повторяем цикл while
        2) searhwin;break;;                 # Выходим из select и повторяем цикл while
        3) arch-chroot /mnt;break;;         # Выходим из select и повторяем цикл while
        4) arch-chroot /mnt /bin/bash -c "exit";umount -R /mnt;reboot;break;;   # Выходим из select и повторяем цикл while
        5) return 0 ;;                      # Выходим из функции полностью
        *) echo "Wrong choice!";;
        esac
    done
done
}
#========================================================================================
#___________________________________2______________________________________________
#=================================================================================================
#___________________________________3_______________________________________________
##############################################################################################
#________________Выбор загрузчика_____________________________________
clear
PS3="└─ Выберите  :"
    select choice in "Установка GRUB" "2" "3" "Командная строка- arch-chroot" "GAME OVER REBOOT" "EXIT"; do
        case $REPLY in
        1) zagruzchik;break;;                   
        2) echo "(в режиме разработки)";;
        3) echo "(в режиме разработки)";;
        4) arch-chroot /mnt;break;;
        5) arch-chroot /mnt /bin/bash -c "exit";umount -R /mnt;reboot;break;;
        6) exit;; 
        *) echo "Wrong choice!";;
        esac
    done

# end    