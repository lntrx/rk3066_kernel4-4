#!/bin/sh

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-

DTS_FILE="rk3066a-rayeager"

PACK_TOOLS_FOLDER="./rockchip-pack-tools"
KERNEL_FOLDER="./rockchip-kernel"
BOOTIMG_FOLDER="./rk3066a-box-4.4"
CONFIG_FILE="rk3066_marsboard_defconfig"
LINARO_LINK="https://releases.linaro.org/components/toolchain/binaries/5.4-2017.05/arm-linux-gnueabihf/gcc-linaro-5.4.1-2017.05-x86_64_arm-linux-gnueabihf.tar.xz"
LINARO_TOOLCHAIN_COMPRESSED="gcc-linaro-5.4.1-2017.05-x86_64_arm-linux-gnueabihf"
ROOTFS_LINK="https://releases.linaro.org/archive/14.10/ubuntu/trusty-images/alip/linaro-trusty-alip-20141024-684.tar.gz"
ROOTS_COMPRESSED="linaro-trusty-alip-20141024-684.tar.gz"
LINARO_FOLDER="linaro"
ROOTFS_FOLDER="rootfs"
CURRENT_DIR=`pwd`

if [ ! -d "$LINARO_FOLDER" ]; then
	mkdir $LINARO_FOLDER
fi

cd $LINARO_FOLDER


if [ ! -f $LINARO_TOOLCHAIN_COMPRESSED.tar.xz ]; then
    echo "No linaro toolchain found!\nDownloading Linaro toolchain..."
    wget $LINARO_LINK
fi


tar xf $LINARO_TOOLCHAIN_COMPRESSED.tar.xz

export PATH=`pwd`/$LINARO_TOOLCHAIN_COMPRESSED/bin:$PATH

cd ..

echo "Copying config file..."

cp $CONFIG_FILE $KERNEL_FOLDER/arch/arm/configs/

cd $KERNEL_FOLDER
echo "Make Config file..."
make $CONFIG_FILE

make -j4 zImage

make -j4 $DTS_FILE.dtb

cp arch/arm/boot/zImage arch/arm/boot/zImage.orig

cat arch/arm/boot/dts/$DTS_FILE.dtb >> arch/arm/boot/zImage

cp arch/arm/boot/zImage ../$BOOTIMG_FOLDER/kernel/

cd ../$BOOTIMG_FOLDER

rm -f boot.img
echo "Building boot.img..."
./rktools/mkbootimg --kernel kernel/zImage --base 60800000 -o boot.img
cd ..

echo "Done.."

if [ ! -d "$ROOTFS_FOLDER" ]; then
	mkdir $ROOTFS_FOLDER
fi

cd $ROOTFS_FOLDER

if [ ! -f $ROOTS_COMPRESSED ]; then
    echo "Rootfs file not exist! Downloading..."
    wget $ROOTFS_LINK
fi

echo "Making rootfs.img"

dd if=/dev/zero of=rootfs.img bs=1M count=1024
mkfs.ext4 -F -L linuxroot rootfs.img

sudo mkdir /mnt/rockchip
sudo mount -o loop rootfs.img /mnt/rockchip

sudo tar zxvf linaro-*.tar.gz -C /mnt/rockchip

cd /mnt/rockchip
sudo mv binary/* .
sudo rmdir binary

cp $CURRENT_DIR/changes/rc.local /mnt/rockchip/etc
cp $CURRENT_DIR/changes/group /mnt/rockchip/etc

cd $CURRENT_DIR

sudo umount /mnt/rockchip

echo "Done"

sudo cp $ROOTFS_FOLDER/rootfs.img $PACK_TOOLS_FOLDER/linux/linux-rootfs.img
sudo cp $BOOTIMG_FOLDER/boot.img $PACK_TOOLS_FOLDER/linux/linux-boot.img

cd $PACK_TOOLS_FOLDER

./mkupdate.sh

cd $CURRENT_DIR
