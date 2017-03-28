FROM ubuntu:16.04
RUN mkdir -p /works/openwrt
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list &&\
    apt-get update &&\
    apt-get upgrade -y &&\
    apt-get install -y wget unzip git-core  sudo python-pip
COPY init.sh /works/init.sh
RUN sh /works/init.sh
