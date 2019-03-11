#!/bin/sh

CURRENT_DIR=`pwd`
ROOTFS_FOLDER="rootfs"
ROOTFS_LINK="https://releases.linaro.org/archive/14.10/ubuntu/trusty-images/alip/linaro-trusty-alip-20141024-684.tar.gz"
ROOTS_COMPRESSED="linaro-trusty-alip-20141024-684.tar.gz"
OUT="output"

echo "[+]Making rootfs.img"

if [ ! -d "$ROOTFS_FOLDER" ]; then
	mkdir $ROOTFS_FOLDER
fi

cd $ROOTFS_FOLDER

if [ ! -f $ROOTS_COMPRESSED ]; then
    echo "[!]Rootfs file not exist! Downloading..."
    wget $ROOTFS_LINK
fi


dd if=/dev/zero of=rootfs.img bs=1M count=1024
mkfs.ext4 -F -L linuxroot rootfs.img

sudo mkdir /mnt/rockchip
sudo mount -o loop rootfs.img /mnt/rockchip

sudo tar zxvf linaro-*.tar.gz -C /mnt/rockchip

cd /mnt/rockchip
sudo mv binary/* .
sudo rmdir binary

sudo cp $CURRENT_DIR/changes/rc.local /mnt/rockchip/etc
sudo cp $CURRENT_DIR/changes/group /mnt/rockchip/etc

cd $CURRENT_DIR

sudo umount /mnt/rockchip

echo "[+]Done"

if [ ! -d "$OUT" ]; then
	mkdir $OUT
fi

cp $ROOTFS_FOLDER/rootfs.img $OUT/

echo "[+]rootfs.img is at " $OUT/rootfs.img
