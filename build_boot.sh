#!/bin/sh

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-

CURRENT_DIR=`pwd`
CONFIG_FILE="rk3066_marsboard_defconfig"
KERNEL_FOLDER="./rockchip-kernel"
DTS_FILE="rk3066a-rayeager"
BOOTIMG_FOLDER="./rk3066a-box-4.4"
LINARO_TOOLCHAIN_COMPRESSED="gcc-linaro-5.4.1-2017.05-x86_64_arm-linux-gnueabihf"
LINARO_FOLDER="linaro"
LINARO_LINK="https://releases.linaro.org/components/toolchain/binaries/5.4-2017.05/arm-linux-gnueabihf/gcc-linaro-5.4.1-2017.05-x86_64_arm-linux-gnueabihf.tar.xz"
OUT="output"


echo "[+]Making boot.img"


if [ ! -d "$LINARO_FOLDER" ]; then
	mkdir $LINARO_FOLDER
fi

cd $LINARO_FOLDER


if [ ! -f $LINARO_TOOLCHAIN_COMPRESSED.tar.xz ]; then
    echo "No linaro toolchain found!\nDownloading Linaro toolchain..."
    wget $LINARO_LINK
fi
if [ ! -f $LINARO_TOOLCHAIN_COMPRESSED ]; then
    tar xf $LINARO_TOOLCHAIN_COMPRESSED.tar.xz
fi

cd $CURRENT_DIR

echo "[+]Copying config file..."

export PATH=`pwd`/$LINARO_TOOLCHAIN_COMPRESSED/bin:$PATH

cp $CONFIG_FILE $KERNEL_FOLDER/arch/arm/configs/

cd $KERNEL_FOLDER
echo "[+]Make Config file..."
make $CONFIG_FILE

make -j4 zImage

make -j4 $DTS_FILE.dtb

cp arch/arm/boot/zImage arch/arm/boot/zImage.orig

cat arch/arm/boot/dts/$DTS_FILE.dtb >> arch/arm/boot/zImage

cp arch/arm/boot/zImage ../$BOOTIMG_FOLDER/kernel/

cd $CURRENT_DIR/$BOOTIMG_FOLDER

rm -f boot.img
echo "[+]Building boot.img..."
./rktools/mkbootimg --kernel kernel/zImage --base 60800000 -o boot.img
cd $CURRENT_DIR

echo "[+]Done.."

if [ ! -d "$OUT" ]; then
	mkdir $OUT
fi

cp $BOOTIMG_FOLDER/boot.img $OUT/

echo "[+]boot.img is at " $OUT/boot.img
