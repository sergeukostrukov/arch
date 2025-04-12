#!/bin/bash
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
#fontset #  
