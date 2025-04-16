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



                                    ##№# ###    #№  #№##    #№  #№##  ###   #№#     #№
                                    #№  #№  #№  #№  #№  #№  #№  #№  #№  #№  #№  #№  #№
                                    #№  #№  #№  #№  #№  #№  #№  #№  #№  #№  ##№##№  #№
                                    #№  #№  #№  #№  #№  #№  #№  #№  #№  #№  #№  #№  ###№
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
select choice in "WiFi" "Lan" "Продолжить не настраивая propustit begin Prodolzit" "Выйти из установки exit"; do
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
            SPISOK disk   Посмотрите список подключенных дисковых устройств и
    ВВЕДИТЕ ИМЯ ДИСКА ДЛЯ РАЗМЕТКИ wwod name disk 
    "например: nvme0n1 sda sdb sdc ....vda ....:)"
     '
read -p "

        -> wwod name disk : " namedisk


echo '                Вы выьрали диск = '$namedisk

sleep 5
#################################################################
#------------- функция разметки дика скриптом по умолчанию-----------------------------
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
 
    Назначены следующие параметры NAZNACHENI PARAMETRI:
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
echo "1-Продолжить с этими параметрами" "2-Изменить диск, регион, регион репозитория, имя компьютера " "3-Выйти из установки"
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
select choice in "ПРОДОЛЩИТЬ" "Изменить- регион, miror репозитория, name имя компьютера " "Выйти из установки EXIT"; do
case $REPLY in
    1) break;;
    2) peremen2;tablo2;;
    3) exit;;
    *) echo "Wrong choice!";;
esac
done
clear
####################################################################
#_______________Функция подготовки BOOT партиции
mkboot() {
PS3="1 Если выбрана партиция boot WINDOWS то не форматировать!!! 2 Если один линукс  :"
select choice in "Если загрузчик ставится в EFI- Windows!" "Для загрузчика LINUX свой раздел mkfs.vfat BOOT" "Выйти из установки EXIT"; do
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
##---------------------Разметка диска--------------------------------------

PS3="Выбирете действие :"
select choice in "512М-boot остальное-root все данный удаляются!!!" "Очистка диска, пересоздание разделов самостоятельно (РЕКОМЕНДОВАНО при умении)" "ничего не удаляется можно создать разделы на свобоюном месте cfdisk WINDOWS!!!!!" "ПРОПУСТИТЬ оставить как есть" "EXIT"; do
case $REPLY in
    1) fdisk_ || exit;break;;
    2) wipefs --all /dev/$namedisk;cfdisk /dev/$namedisk || exit;break;;
    3) cfdisk /dev/$namedisk || exit;break;;
    4) echo "see you next time";break;;
    5) exit;;
    *) echo "Wrong choice!";;
esac
done
############################################################################################
#-------------Диалог назначение партиций для boot root--------------------------------------
clear
lsblk -f /dev/$namedisk
fdisk -l /dev/$namedisk
echo '
            UKAZITE NAZBANIE PARTICII !!!<< '$namedisk '>>!!! boot end root'
read -p "
        POLNOE NAZBANIE PARTICII (sda1...nvme0n1p1....) boot: -> Введите значение : " boot
read -p "
        POLNOE NAZBANIE PARTICII (sdb2...nvme0n1p2....) root: -> Введите значение : " root


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

bluez_='pacstrap -i /mnt bluez bluez-utils'
dispmanager='pacstrap -i /mnt sddm --noconfirm'
displaymanager='systemctl enable sddm --force'
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
arch-chroot /mnt /bin/bash -c "mkinitcpio -P"
arch-chroot /mnt /bin/bash -c "pacman -Syy grub grub-btrfs efibootmgr --noconfirm"
arch-chroot /mnt /bin/bash -c "useradd -m -G wheel -s /bin/bash $username"
echo "$username:$userpassword" | arch-chroot /mnt chpasswd
arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager"
arch-chroot /mnt /bin/bash -c "${Uefi}"
arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"

#---заглушка остановка для просмотра вывода комманд
stop_
#---------------------------------------------------------------------

arch-chroot /mnt /bin/bash -c "systemctl enable NetworkManager"

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
select choice in "Подключить своп в оперативной памяти SWAP  ZRAM" " ПРОПУСТИТЬ    go step"; do
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