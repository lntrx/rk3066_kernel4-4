#!/bin/sh

CURRENT_DIR=`pwd`
LINARO_FOLDER="linaro"
LINARO_TOOLCHAIN_COMPRESSED="gcc-linaro-5.4.1-2017.05-x86_64_arm-linux-gnueabihf"
LINARO_LINK="https://releases.linaro.org/components/toolchain/binaries/5.4-2017.05/arm-linux-gnueabihf/gcc-linaro-5.4.1-2017.05-x86_64_arm-linux-gnueabihf.tar.xz"
ROOTFS_FOLDER="rootfs"
ROOTS_COMPRESSED="linaro-trusty-alip-20141024-684.tar.gz"

if [ ! -d "$LINARO_FOLDER" ]; then
	mkdir $LINARO_FOLDER
fi

cd $LINARO_FOLDER

if [ ! -f $LINARO_TOOLCHAIN_COMPRESSED.tar.xz ]; then
    echo "[!]No linaro toolchain found!\nDownloading Linaro toolchain..."
    wget $LINARO_LINK
fi

echo "[+]Download finished extacting..."

tar xf $LINARO_TOOLCHAIN_COMPRESSED.tar.xz

echo "[+]Done"

cd $CURRENT_DIR

export PATH=`pwd`/$LINARO_TOOLCHAIN_COMPRESSED/bin:$PATH

if [ ! -d "$ROOTFS_FOLDER" ]; then
	mkdir $ROOTFS_FOLDER
fi

cd $ROOTFS_FOLDER

if [ ! -f $ROOTS_COMPRESSED ]; then
    echo "[!]Rootfs file not exist! Downloading..."
    wget $ROOTFS_LINK
fi

echo "[+]Done"

cd $CURRENT_DIR
