FROM ubuntu:16.04
RUN mkdir -p /works
RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list &&\
    apt-get update &&\
    apt-get upgrade -y &&\
    apt-get install -y wget unzip git-core  sudo python-pip subversion
COPY init.sh /works/init.sh
RUN sh /works/init.sh
RUN useradd -m openwrt  &&\
    echo 'openwrt ALL=NOPASSWD: ALL' > /etc/sudoers.d/openwrt &&\
    rm -rf /works/openwrt/install_openwrt.sh
RUN apt-get install -y libssl-dev
COPY install_openwrt.sh /works/openwrt/install_openwrt.sh
COPY install_openwrt_hostlib.sh /works/openwrt/
RUN sudo chmod -R 777 /works/
RUN cd /works/openwrt && ./install_openwrt_hostlib.sh
USER openwrt
RUN cd /works/openwrt &&  ./install_openwrt.sh
