#!/bin/bash
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
