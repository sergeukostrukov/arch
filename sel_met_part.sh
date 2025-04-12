#!/bin/bash

##---------Разметка диска выбор способа--------------------------------------
sel_met_part(){
PS3="Выбирете действие :"
select choice in  "УНИВЕРСАЛЬНЫЙ" "AUTOMAT" "ERASE all and cfdisk SAMOST. " "NOT ERASE cfdisk WINDOWS!!!!! " "NOT ERASE NOT cfdisk" "EXIT"; do
case $REPLY in
    1) disk_partition;break;;
    2) fdisk_ || exit;break;;
    3) wipefs --all /dev/$DISK;cfdisk /dev/$DISK || exit;break;;
    4) cfdisk /dev/$DISK || exit;break;;
    5) echo "see you next time";break;;
    5) exit;;
    *) echo "Wrong choice!";;
esac
done
}