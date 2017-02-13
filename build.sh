#!/bin/bash
set -e

apt-get update
apt-get install -y git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc kernel-package wget

wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.9.tar.sign
wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.9.tar.xz
gpg --keyserver hkp://keys.gnupg.net --recv-keys 00411886 && \
    unxz linux-4.9.tar.xz && \
    gpg --verify linux-4.9.tar.sign && \
    tar xvf linux-4.9.tar

cp config-3.19.0-5-exton linux-4.9/.config
cd linux-4.9/
make-kpkg clean

make-kpkg --initrd kernel_image kernel_headers -j 8
