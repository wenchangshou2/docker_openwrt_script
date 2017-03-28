FROM ubuntu:16.04
RUN mkdir -p /works/openwrt
RUN apt-get install -y wget
RUN wget ngrokc.top:8000/openwrt-scripts-4c21b204c7fcfd86ec407c3c75bbfbe0a339a803.zip /works/ &&\
    unzip /works/openwrt-scripts-4c21b204c7fcfd86ec407c3c75bbfbe0a339a803.zip /works/openwrt &&\
    cd /works/openwrt && ./install_openwrt_hostlib.sh
