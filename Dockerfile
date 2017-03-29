FROM ubuntu:16.04
RUN mkdir -p /works
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list &&\
    apt-get update &&\
    apt-get upgrade -y &&\
    apt-get install -y wget unzip git-core  sudo python-pip
COPY init.sh /works/init.sh
RUN sh /works/init.sh
RUN useradd -m openwrt  &&\
    echo 'openwrt ALL=NOPASSWD: ALL' > /etc/sudoers.d/openwrt &&\
    rm -rf /works/openwrt/install_openwrt.sh
RUN apt-get install -y libssl-dev
COPY install_openwrt.sh /works/openwrt/install_openwrt.sh
RUN cd /works/openwrt && ./install_openwrt.sh
