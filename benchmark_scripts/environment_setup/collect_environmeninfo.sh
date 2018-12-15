#!/usr/bin/env bash

systemType=${1:-unknown}
echo "###############################################"
echo "# ${systemType}"
echo "###############################################"
echo ""

echo '$ cat /proc/cpuinfo'
cat /proc/cpuinfo
echo ""

echo '$ cat /proc/meminfo'
cat /proc/meminfo
echo ""

echo '$ cat /proc/version'
cat /proc/version
echo ""

echo '$ docker --version'
docker --version
echo ""

echo '$ qemu-system-i386 --version'
qemu-system-i386 --version
echo ""

echo '$ kvm --version'
kvm --version
echo ""

echo '$ gcc --version'
gcc --version
echo ""

echo '$ nginx -v'
nginx -v 2>&1
echo ""

echo '$ curl --version'
curl --version
echo ""

echo '$ git --version'
git --version
echo ""

echo '$ fio --version'
fio --version
echo ""
