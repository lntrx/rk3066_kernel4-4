#!/bin/sh

CURRENT_DIR=`pwd`
PACK_TOOLS_FOLDER="./rockchip-pack-tools"
OUT="output"

echo "[+]Making update.img"

if [ ! -f $OUT/boot.img ]; then
    echo "[!]Please first run ./buid_boot.sh"
    exit 1
fi
if [ ! -f $OUT/rootfs.img ]; then
    echo "[!]Please first run ./buid_rootfs.sh"
    exit 1
fi

sudo cp $OUT/rootfs.img $PACK_TOOLS_FOLDER/linux/linux-rootfs.img
sudo cp $OUT/boot.img $PACK_TOOLS_FOLDER/linux/linux-boot.img

cd $PACK_TOOLS_FOLDER

./mkupdate.sh

echo "[+]Done"

cd $CURRENT_DIR

cp $PACK_TOOLS_FOLDER/update.img $OUT

echo "[+]update.img is at " $OUT/update.img
