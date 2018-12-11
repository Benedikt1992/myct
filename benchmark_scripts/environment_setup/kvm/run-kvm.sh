#!/usr/bin/env bash

image_name="../debian_stretch_i386.img"

if ! [[ -e ${image_name} ]]; then
    source ../download_image.sh
fi

kvm ${image_name} \
-cpu host -smp 2 \
-m 2048 \
-device virtio-net,netdev=net0 -netdev user,id=net0,hostfwd=tcp::22222-:22,hostfwd=tcp::8080-:80 \
-monitor unix:qemu-monitor-socket,server,nowait \
-nographic
