#!/bin/bash
#==============================================================================================
zagruzchik(){
while true; do  # Добавляем цикл while для обработки повторных входов без рекурсии
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
    #-----------------searh windows-----------------------
    #Помогает загрузчику найти Windows для двойной загрузки
    #Если GRUB не видит Windows, выполните в Arch:
    searhwin() {
    arch-chroot /mnt /bin/bash -c "pacman -S os-prober"
    arch-chroot /mnt /bin/bash -c "sed -i s/'GRUB_TIMEOUT=5'/'GRUB_TIMEOUT=30'/g /etc/default/grub"
    arch-chroot /mnt /bin/bash -c "sed -i s/'#GRUB_DISABLE_OS_PROBER=false'/'GRUB_DISABLE_OS_PROBER=false'/g /etc/default/grub"
    arch-chroot /mnt /bin/bash -c "grub-mkconfig -o /boot/grub/grub.cfg"
    #---заглушка остановка для просмотра вывода комманд
    stop_   
    }
    PS3="searh WINDOWS :"
    select choice in "Установка GRUB"  "ПОИСК WINDOWS" "Коммандная строка- arch-chroot" "GAME OVER REBOOT" "EXIT из меню"; do
        case $REPLY in
        1) grub_;break;;
        2) searhwin;break;;
        3) arch-chroot /mnt;break;; 
        4) arch-chroot /mnt /bin/bash -c "exit";umount -R /mnt;reboot;break;;
        5) return 0 ;;
        *) echo "Wrong choice!";;
        esac
    done
done
}
#----------------end searh windows--------------------