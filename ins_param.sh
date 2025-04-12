#!/bin/bash

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
#========================================================================================================