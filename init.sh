sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list &&\
    apt-get update &&\
    apt-get upgrade -y &&\
    apt-get install -y wget
wget ngrokc.top:8000/openwrt-scripts-4c21b204c7fcfd86ec407c3c75bbfbe0a339a803.zip /works/ &&\
    unzip /works/openwrt-scripts-4c21b204c7fcfd86ec407c3c75bbfbe0a339a803.zip /works/openwrt &&\
    cd /works/openwrt && ./install_openwrt_hostlib.sh

