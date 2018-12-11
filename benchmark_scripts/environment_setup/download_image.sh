#!/usr/bin/env bash

# download and extract hdd image
curl -o debian_stretch_i386.tar.xz https://www.sec.in.tum.de/~bierbaumer/qemu/debian_stretch_i386_standard.tar.xz
tar xf debian_stretch_i386.tar.xz debian_stretch_i386_standard/hda.img
mv debian_stretch_i386_standard/hda.img debian_stretch_i386.img
rm -r debian_stretch_i386_standard
rm debian_stretch_i386.tar.xz
