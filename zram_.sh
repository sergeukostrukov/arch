#!/bin/bash
#____________________________Функция ZRAM_ --------------------
zram_() {
pacstrap -i /mnt zram-generator --noconfirm
arch-chroot /mnt /bin/bash -c "echo '[zram0]' > /etc/systemd/zram-generator.conf"
arch-chroot /mnt /bin/bash -c "echo 'ram-size = ram / 3' >> etc/systemd/zram-generator.conf"
arch-chroot /mnt /bin/bash -c "echo 'ompression-algorithm = zstd' >> /etc/systemd/zram-generator.conf"
arch-chroot /mnt /bin/bash -c "echo 'wap-priority = 100' >> /etc/systemd/zram-generator.conf"
arch-chroot /mnt /bin/bash -c "echo 's-type = swap' >> /etc/systemd/zram-generator.conf"
}