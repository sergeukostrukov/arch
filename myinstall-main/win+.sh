#!/bin/bash

#      После перезагрузки не видна ВИНДОВС
#
#        в файле исправляем/etc/default/grub
#       GRUB_TIMEOUT=5      исправляем на 30
#       #GRUB_DISABLE_OS_PROBER=falcse раскомментируем
#


pacman -S os-prober
nano /etc/default/grub  # Раскомментируйте GRUB_DISABLE_OS_PROBER=false
grub-mkconfig -o /boot/grub/grub.cfg