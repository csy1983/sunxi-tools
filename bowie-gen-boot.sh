#!/bin/bash

SDBOOTPART=$1

[ -z "$SDBOOTPART" ] && echo Please specify SDCARD boot partition device node && exit 1

[ ! -e ./fex2bin ] && make

# Please do `make' first

mount $SDBOOTPART /opt

./fex2bin ../sunxi-boards/sys_config/a20/cubieboard2.fex /opt/script.bin

echo << EOF > /opt/boot.cmd
setenv bootargs console=ttyS0,115200 root/dev/mmcblk0p2 init=/sbin/init rootwait panic=10 ${extra}
fatload mmc 0 0x43000000 script.bin
fatload mmc 0 0x48000000 uImage
bootm 0x48000000
EOF

sync

mkimage -C none -A arm -T script -d /opt/boot.cmd /opt/boot.scr

sync

umount /opt

