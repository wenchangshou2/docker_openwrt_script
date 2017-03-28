FROM ubuntu:16.04
RUN mkdir -p /works/openwrt
COPY init.sh /works/init.sh
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list &&\
    apt-get update &&\
    apt-get upgrade -y &&\
    apt-get install -y wget unzip
RUN sh /works/init.sh
