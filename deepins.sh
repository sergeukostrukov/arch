#!/bin/bash
# Скрипт установки Arch Linux в двойную загрузку с Windows 11
# Требует запуска из загрузочного носителя Arch Linux в режиме UEFI
# Перед выполнением рекомендуется сделать бэкап данных

# Определяем переменные
DISK="nvme0n1"          # Имя целевого диска
WIN_EFI_PART="1"         # Номер раздела EFI Windows (nvme0n1p1)
ARCH_EFI_PART="1"        # Используем тот же EFI раздел для обеих ОС
ROOT_PART="5"            # Номер создаваемого раздела для Arch Linux
ROOT_SIZE="100%"         # Используем все нераспределенное пространство
TARGET_MOUNT="/mnt"      # Точка монтирования для установки
TIMEZONE="Europe/Moscow" # Часовой пояс
LANG="en_US.UTF-8"       # Локаль
HOSTNAME="archlinux"     # Имя компьютера

# Проверка, что скрипт запущен от root
if [[ $EUID -ne 0 ]]; then
    echo "Этот скрипт должен быть запущен с правами root!" 
    exit 1
fi

#------------Localizaciya-------------------------------

setfont ter-v32b

#################################################################
#-----------Подключение к Enternet---------
#--------fynction  "mywifi"----- WIFI conect-------------
mywifi() {
#clear
iwctl device list
read -p '                                                              -> Введите определившееся значение, например "wlan0" : ' namelan
iwctl station $namelan scan
iwctl station $namelan get-networks
read -p '                                                              -> Введите название вашей сети из списка  : ' namewifi
iwctl station $namelan connect $namewifi
iwctl station $namelan show
sleep 5
 }
#-------------------------------------------------------
#clear
echo '



		        	ПОДКЛЮЧЕНИЕ  ENTERNET

            
                 
'
PS3="Выберите тип соединения 1 или 2  если 3 - не настраивать  4 - Прервать установку :"
select choice in "WiFi" "Lan" "Продолжить не настраивая" "Выйти из установки"; do
case $REPLY in
    1) mywifi;break;;
    2) systemctl restart dhcpcd ;dhcpcd;break;;
    3) break;;
    4) echo "see you next time";exit;;
    *) echo "Неправильный выбор !";;
esac
done
echo "     Проверка подключения к Enternet"
ping -c 10 8.8.8.8  || exit
clear
echo '


                Есть подключение !!!!!!!!'
#------------------------------------------------------------------


# Часть 1 - Создание разделов
echo "### Создание раздела для Arch Linux ###"
### Создаем новый раздел в нераспределенном пространстве
##parted -s /dev/${DISK} mkpart primary ext4 ${ROOT_SIZE}

#скрипт не срабатывает будем использовать зврвнее внешне размеченный диск

# Форматирование разделов
echo "### Форматирование разделов ###"
mkfs.ext4 /dev/${DISK}p${ROOT_PART}  # Корневой раздел

# Часть 2 - Монтирование разделов
echo "### Монтирование разделов ###"
mount /dev/${DISK}p${ROOT_PART} ${TARGET_MOUNT}
mkdir -p ${TARGET_MOUNT}/boot/efi
mount /dev/${DISK}p${ARCH_EFI_PART} ${TARGET_MOUNT}/boot/efi

# Часть 3 - Установка базовой системы
echo "### Установка базовых пакетов ###"
pacstrap ${TARGET_MOUNT} base linux linux-firmware sudo grub efibootmgr networkmanager nano mc ntfs-3g dosfstools

# Генерация fstab
echo "### Создание файла fstab ###"
genfstab -U ${TARGET_MOUNT} >> ${TARGET_MOUNT}/etc/fstab

# Часть 4 - Настройка системы
echo "### Настройка системы ###"
# Вход в chroot-окружение
arch-chroot ${TARGET_MOUNT} /bin/bash <<EOF
    # Установка часового пояса
    ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
    hwclock --systohc
    
    # Настройка локали
    sed -i 's/#${LANG}/${LANG}/' /etc/locale.gen
    locale-gen
    echo "LANG=${LANG}" > /etc/locale.conf
    
    # Настройка имени компьютера
    echo "${HOSTNAME}" > /etc/hostname
    
    # Настройка загрузчика (GRUB)
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
    os-prober
    sed -i 's/GRUB_DISABLE_OS_PROBER=.*/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub
    grub-mkconfig -o /boot/grub/grub.cfg
    
    # Включение NetworkManager
    systemctl enable NetworkManager
    
    # Установка пароля root
    echo "Установите пароль для root:"
    passwd
EOF

# Часть 5 - Создание пользователя
echo "### Создание пользователя ###"
arch-chroot ${TARGET_MOUNT} /bin/bash <<EOF
    useradd -m -G wheel -s /bin/bash archuser
    echo "Установите пароль для пользователя archuser:"
    passwd archuser
    sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
EOF

# Завершение
echo "### Установка завершена! ###"
umount -R ${TARGET_MOUNT}
echo "Вы можете перезагрузить систему командой: reboot"