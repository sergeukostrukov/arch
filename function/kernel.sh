kernel() { 
#--------------------выбор ядра linux---------------------------------------
kernel1='pacstrap -i /mnt base base-devel linux-zen linux-zen-headers linux-firmware ntfs-3g btrfs-progs amd-ucode intel-ucode iucode-tool archlinux-keyring nano mc vim dhcpcd dhclient networkmanager wpa_supplicant iw --noconfirm'
kernel2='pacstrap -i /mnt base base-devel linux linux-headers linux-firmware ntfs-3g btrfs-progs amd-ucode intel-ucode iucode-tool archlinux-keyring nano mc vim dhcpcd dhclient networkmanager wpa_supplicant iw --noconfirm'
PS3="Выбирете действие :"
select choice in "Linux-zen"  "Linux" "EXIT"; do
case $REPLY in
    1) kernel=${kernel1};break;;
    2) kernel=${kernel2};break;;
    3) exit;;
    *) echo "Wrong choice!";;
esac
done
}
#--------------------end-выбор ядоа-----------------------------------------------------