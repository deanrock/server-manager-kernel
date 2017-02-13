FROM debian:wheezy

RUN apt-get update && apt-get install -y git fakeroot build-essential ncurses-dev xz-utils libssl-dev bc kernel-package
RUN apt-get install -y wget

RUN mkdir /code

WORKDIR /code

RUN wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.9.tar.sign
RUN wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.9.tar.xz
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 00411886 && \
    unxz linux-4.9.tar.xz && \
    gpg --verify linux-4.9.tar.sign && \
    tar xvf linux-4.9.tar
ADD config-3.19.0-5-exton /code/linux-4.9/.config
WORKDIR /code/linux-4.9
RUN make-kpkg clean
CMD bash
