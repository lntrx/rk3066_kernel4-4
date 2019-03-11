Tools for packing a Linux firmware (update.img) for rockchip platform.

### How to use it ###
    copy the boot kernel and rootfs in linux file.
    ./mkupdate.sh    # Pack the image

### Warning ###
    use Linux_Upgrade_Tool_v1.16 & RKBatchTool_V1.6 download, both have a bug, can not loader Over 2G firmware. If you update.img over 2G, you can not download it in this version.
