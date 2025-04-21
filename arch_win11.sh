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
sleep 5
 }
#-------------------------------------------------------
#clear
echo '



		        	ПОДКЛЮЧЕНИЕ  ENTERNET CONNECT 

            
                 
'
PS3="Выберите тип соединения 1 или 2  если 3 - не настраивать  4 - Прервать установку :"
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
sleep 2
#################################################################
#################################################################
#-----назначение переменных----------
region="Europe/Moscow"
name="ArchLinux"
mirror_="RU,NL"

#################################################################
#################################################################
#####---------------диалог назначения namedisk-----------------------------
clear
lsblk
#fdisk -l
echo '
    Дисковые устройства обнаруженныу в системе
    ВВЕДИТЕ ИМЯ ДИСКА ДЛЯ Установки ArchLinux 
    "например: nvme0n1 sda sdb sdc ....vda ....:)"
     '
read -p "
         wwod name disk -->: " namedisk


echo '         Вы выьрали диск = '$namedisk

sleep 5

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
echo "    Имя компьютера = " $name
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
             Регион например "Europe/Moscow"   -> Введите wwod : " region
read -p "
 Регион расположения репозитария "RU,NL" "US"  -> Введите wwod : " mirror_                                                                                                    
read -p "
                        Имя компьютера NAME PC -> Введите wwod : " name                                       

}

####-------------показываем tablo2------------------
tablo2

PS3="Выберите действие :"
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
PS3="1 Не удалять загрузчик WINDOWS !!! 2 Если один линукс  :"
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

        PS3="Выберите действие: "
        select choice in "512М-boot остальное-root все данные удаляются" "Полное удаление всего на диске вместе с таблицей разделов" "Ручная разметка. Можно оставить разделы WINDOWS!!!!!" "ДАЛЬШЕ (Оставить с этими разделами)" "Завершить установку EXIT"; do
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
clear
lsblk -f /dev/$namedisk
fdisk -l /dev/$namedisk
echo '


ВЫБЕРИТЕ ПАРТИЦИЮ  !!!<< '$namedisk '>>!!! boot И root'
read -p "

POLNOE NAZBANIE PARTICII (sda1...nvme0n1p1....) boot: ->:" boot
read -p "

POLNOE NAZBANIE PARTICII (sdb2...nvme0n1p2....) root: ->:" root


echo '                Вы выьрали Disk = '$namedisk
echo '                           boot = '$boot
echo '                           root = '$root
sleep 3

############################################################################################

clear
echo '

  ДИСК БУДЕТ РАЗМЕЧЕН В BTRFS
  Выбирете вариант разметки субволумов :

  Вариант с swapfile                    Вариант без NOT SWAPfile
      /@                                      /@
      /@home                                  /@home
      /@log                                   /@log       var/log
      /@pkg                                   /@pkg       var/cache/pacman/pkg
      /@.snapshots                            /@tmp
      /@tmp                              Будет предложено 
      /@swap   swapfile 8g               создать SWAP на ZRAM

'
PS3="Выбирете действие :"
select choice in "Вариант с физическим swapfile"  "Вариант с возможностью создать виртуальный VIRTUAL ZRAM-SWAP" "EXIT"; do
case $REPLY in
    1) mkboot;btrfs1;break;;
    2) mkboot;btrfs2;break;;
    3) exit;;
    *) echo "Wrong choice!";;
esac
done

#---------Переменные------------------------------------------------------------

#--------------------выбор ядра linux---------------------------------------

kernel1='pacstrap -i /mnt base base-devel linux-zen linux-zen-headers linux-firmware ntfs-3g btrfs-progs amd-ucode intel-ucode iucode-tool archlinux-keyring nano mc vim dhcpcd dhclient networkmanager wpa_supplicant iw terminus-font --noconfirm'
kernel2='pacstrap -i /mnt base base-devel linux linux-headers linux-firmware ntfs-3g btrfs-progs amd-ucode intel-ucode iucode-tool archlinux-keyring nano mc vim dhcpcd dhclient networkmanager wpa_supplicant iw terminus-font --noconfirm'
PS3="Выбирете действие :"
select choice in "Linux-zen"  "Linux" "EXIT"; do
case $REPLY in
    1) kernel=${kernel1};break;;
    2) kernel=${kernel2};break;;
    3) exit;;
    *) echo "Wrong choice!";;
esac
done

#--------------------end-выбор ядоа-----------------------------------------------------
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
arch-chroot /mnt /bin/bash -c "echo $name > /etc/hostname"
arch-chroot /mnt /bin/bash -c "echo '127.0.0.1 localhost' > /etc/hosts"
arch-chroot /mnt /bin/bash -c "echo '::1       localhost' >> /etc/hosts"
arch-chroot /mnt /bin/bash -c "echo '127.0.0.1 $name.localdomain $name' >> /etc/hosts"
arch-chroot /mnt /bin/bash -c "sed -i s/'#ParallelDownloads = 5'/'ParallelDownloads = 10'/g /etc/pacman.conf"
arch-chroot /mnt /bin/bash -c "sed -i s/'#VerbosePkgLists'/'VerbosePkgLists'/g /etc/pacman.conf"
arch-chroot /mnt /bin/bash -c "sed -i s/'#Color'/'ILoveCandy'/g /etc/pacman.conf"
sed -i "/\[multilib\]/,/Include/"'s/^#//' /mnt/etc/pacman.conf
arch-chroot /mnt /bin/bash -c "sed -i s/'# %wheel ALL=(ALL:ALL) ALL'/'%wheel ALL=(ALL:ALL) ALL'/g /etc/sudoers"
echo "root:$password" | arch-chroot /mnt chpasswd

arch-chroot /mnt /bin/bash -c "useradd -m -G wheel -s /bin/bash $username"
echo "$username:$userpassword" | arch-chroot /mnt chpasswd
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager"
#arch-chroot /mnt /bin/bash -c "mkinitcpio -P" # компиляция ядра для загрузчика

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
PS3="Выберите действие :"
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
    arch-chroot /mnt /bin/bash -c "mkinitcpio -P" # компиляция ядра для загрузчика
    #Установка пакетов загрузчика
    arch-chroot /mnt /bin/bash -c "pacman -Syy grub grub-btrfs efibootmgr --noconfirm"
    Uefi="grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB --no-nvram --removable /dev/$DISK"
    arch-chroot /mnt /bin/bash -c "${Uefi}"
    arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
    #---заглушка остановка для просмотра вывода комманд
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
    #---заглушка остановка для просмотра вывода комманд
    stop_   
    }
    PS3="Выберите :"
    select choice in "Установка GRUB"  "ПОИСК WINDOWS" "Коммандная строка- arch-chroot" "GAME OVER REBOOT" "EXIT из меню"; do
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
#______________________rEFInd___________________________________________________________
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

#=================================================================================================
#_______________________install_refind_______________________________________
#!/bin/bash

install_refind() {
    # Проверка выполнения от root
    if [[ $EUID -ne 0 ]]; then
        echo "Ошибка: Скрипт должен запускаться с правами root" >&2
        return 1
    fi

    # Пути монтирования
    local efi_mount_point="/mnt/boot/efi"
    local refind_dir="$efi_mount_point/EFI/refind"
    
    # Проверка монтирования EFI раздела
    if ! mountpoint -q "$efi_mount_point"; then
        echo "Ошибка: EFI раздел не смонтирован в $efi_mount_point" >&2
        echo "Выполните: mount /dev/$boot $efi_mount_point" >&2
        return 1
    fi

    # Установка пакетов в целевую систему
    echo "Установка необходимых пакетов..."
    if ! pacstrap /mnt refind efibootmgr dosfstools; then
        echo "Ошибка установки пакетов!" >&2
        return 1
    fi

    # Создание структуры каталогов в целевом разделе
    mkdir -p "$refind_dir/drivers" || {
        echo "Ошибка создания директорий!" >&2
        return 1
    }

    # Копирование драйверов из целевой системы
    echo "Копирование драйверов..."
    drivers=("ext4" "ntfs" "btrfs" "xfs")
    for driver in "${drivers[@]}"; do
        driver_path="/usr/share/refind/drivers_x64/${driver}_x64.efi"
        if ! arch-chroot /mnt [ -f "$driver_path" ]; then
            echo "Ошибка: Драйвер $driver не найден в целевой системе!" >&2
            return 1
        fi
        cp -f "/mnt$driver_path" "$refind_dir/drivers/" || return 1
    done

    # Установка rEFInd с учетом chroot окружения
    echo "Установка rEFInd в EFI раздел..."
    if ! arch-chroot /mnt refind-install \
        --root /mnt \
        --alldrivers \
        --yes \
        --localkeys \
        --keepname; then
        echo "Критическая ошибка при установке rEFInd!" >&2
        return 1
    fi

    # Настройка конфигурации
    local refind_conf="$refind_dir/refind.conf"
    echo "Настройка refind.conf..."
    sed -i 's/^#\(scan_all_linux_kernels\)/\1/' "$refind_conf"
    sed -i 's/^#\(scan_for\)/\1 external,internal/' "$refind_conf"
    
    # Добавление записи Windows
    if ! grep -q "Microsoft" "$refind_conf"; then
        echo -e "\n# Windows Boot Manager" >> "$refind_conf"
        echo 'menuentry "Windows 11" {' >> "$refind_conf"
        echo '    icon /EFI/refind/icons/os_win.png' >> "$refind_conf"
        echo '    loader /EFI/Microsoft/Boot/bootmgfw.efi' >> "$refind_conf"
        echo '    ostype Windows' >> "$refind_conf"
        echo '}' >> "$refind_conf"
    fi

    # Определение параметров диска
    local disk_device="${boot%%[0-9]*}"
    local part_number="${boot#$disk_device}"

    # Обновление UEFI записей
    echo "Обновление UEFI переменных..."
    efibootmgr -c -d "/dev/$disk_device" -p "$part_number" \
        -L "rEFInd Boot Manager" \
        -l '\EFI\refind\refind_x64.efi' >/dev/null 2>&1

    # Синхронизация файловых систем
    sync

    echo -e "\nУстановка rEFInd завершена успешно!"
    echo "Проверьте:"
    echo "1. Содержимое EFI раздела: ls $efi_mount_point/EFI"
    echo "2. Записи UEFI: efibootmgr -v"
    echo "3. Наличие файла: $refind_dir/refind_x64.efi"
}

# Пример вызова:
# boot="nvme0n1p1"  # Укажите ваш раздел
# install_refind

##############################################################################################
#________________Выбор загрузчика_____________________________________
PS3=" Выберите :"
    select choice in "Установка GRUB"  "установки rEFInd и настройки двойной загрузки" "установка rEFInd однарная и двойная с виндовс" "Коммандная строка- arch-chroot" "GAME OVER REBOOT" "EXIT из меню"; do
        case $REPLY in
        1) zagruzchik;break;;                    # Выходим из select 
        2) install_refind_with_windows $boot;break;;   # Выходим из select 
        3) install_refind;break;;
        4) arch-chroot /mnt;break;;         # Выходим из select 
        5) arch-chroot /mnt /bin/bash -c "exit";umount -R /mnt;reboot;break;;
        6) exit;; 
        *) echo "Wrong choice!";;
        esac
    done

# end    