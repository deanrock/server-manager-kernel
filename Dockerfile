FROM debian:wheezy

ADD build.sh /root/build.sh
ADD config-3.19.0-5-exton /root/config-3.19.0-5-exton

RUN /root/build.sh
