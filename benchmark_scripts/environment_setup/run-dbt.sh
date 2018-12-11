#!/usr/bin/env bash

image_name="debian_stretch_i386.img"

if ! [[ -e ${image_name} ]]; then
    source ./download_image.sh
fi

qemu-system-i386 ${image_name} \
-cpu max -smp 2 \
-m 2048 \
-device virtio-net,netdev=net0 -netdev user,id=net0,hostfwd=tcp::22222-:22 \
-monitor unix:qemu-monitor-socket,server,nowait \
-nographic
