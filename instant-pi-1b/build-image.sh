#!/bin/sh

# Use -N to skip downloads, use -L to skip downloads and clean recompile kernel
if [ "$#" -eq 0 ] || [ "$1" != "-N" ] && [ "$1" != "-L" ]; then
    if [ ! -d buildroot ]; then
        git clone https://github.com/buildroot/buildroot --depth 1
    fi
    wget -N --no-if-modified-since https://github.com/raspberrypi/firmware/raw/master/boot/bcm2708-rpi-b.dtb -P buildroot/output/images/
    wget -N --no-if-modified-since https://github.com/raspberrypi/firmware/raw/master/boot/bootcode.bin -P buildroot/output/images/
    wget -N --no-if-modified-since https://github.com/raspberrypi/firmware/raw/master/boot/start_cd.elf -P buildroot/output/images/
    wget -N --no-if-modified-since https://github.com/raspberrypi/firmware/raw/master/boot/fixup_cd.dat -P buildroot/output/images/
fi

make -j $(nproc) -C buildroot defconfig BR2_DEFCONFIG=../br_instantpi1b_defconfig && \
if [ "$#" -eq 0 ] || [ "$1" != "-L" ]; then
    make -j $(nproc) -C buildroot linux-dirclean
fi
make -j $(nproc) -C buildroot && \
yes | mv -f buildroot/output/images/sdcard.img . && \
echo "Image built at $(pwd)/sdcard.img"

