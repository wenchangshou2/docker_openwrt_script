FROM ubuntu:16.04
RUN mkdir -p /works/openwrt
COPY init.sh /works/init.sh
RUN sh /works/init.sh
