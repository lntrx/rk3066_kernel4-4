#!/bin/bash

set -e

cd `dirname $0`

rm -f update_tmp.img
rm -f update.img

./afptool  -pack . update_tmp.img
./img_maker -rk30 RK30xxLoader\(L\)_V2.13.bin 1 0 0 update_tmp.img update.img
echo "update.img is at `pwd`/update.img"
