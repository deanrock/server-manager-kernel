#!/bin/bash
set -euxo pipefail

apt-get update
apt-get install -y git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc kernel-package wget

export linux_src=~/linux-4.9/
export aufs_src=~/aufs4-standalone/

cd ~/

# clean
rm -rf $aufs_src
rm -rf $linux_src
rm -rf ~/linux-4.9.tar*

# get linux source & extract it
wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.9.tar.sign
wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.9.tar.xz
gpg --keyserver hkp://keys.gnupg.net --recv-keys 00411886 && \
    unxz linux-4.9.tar.xz && \
    gpg --verify linux-4.9.tar.sign && \
    tar xvf linux-4.9.tar

# copy config file
cp ~/config-3.19.0-5-exton linux-4.9/.config

# get aufs
git clone https://github.com/sfjro/aufs4-standalone.git


# checkout aufs for 4.9 kernel
cd $aufs_src
git checkout origin/aufs4.9

# patch kernel with aufs
cd $linux_src
patch -p1 < $aufs_src/aufs4-kbuild.patch
patch -p1 < $aufs_src/aufs4-base.patch
patch -p1 < $aufs_src/aufs4-mmap.patch
patch -p1 < $aufs_src/aufs4-standalone.patch

cp -av $aufs_src/Documentation/* Documentation/
cp -av $aufs_src/fs/* fs/
cp -v $aufs_src/include/uapi/linux/aufs_type.h $linux_src/include/linux/

# cd to linux dir build it
cd $linux_src
make-kpkg clean

make-kpkg --initrd kernel_image kernel_headers -j 8
