#!/bin/bash
source ./common/common.sh

echo "source $source"
echo "===INIT==UBUNTU=OPENWRT==="
sudo echo "SUDO ROOT"

args_mode=$1

if [ ! -f /usr/lib/libiconv.so ]; then
  ./install_openwrt_hostlib.sh
fi
show t "获取openwrt源"
rootdir=/works/openwrt
if [ ! -d $rootdir ]; then
  sudo -iu openwrt chk_mkdir $rootdir
fi
 sudo -iu openwrt chk_mkdir $rootdir/works
 sudo -iu openwrt chk_mkdir $rootdir/backup
 sudo -iu openwrt chk_mkdir $rootdir/staging_dir
 sudo -iu openwrt chk_mkdir $rootdir/build_dir
cd $rootdir
if [ ! -d $rootdir/openwrt.git -a ! -d $rootdir/openwrt.git/.git -a ! -f $rootdir/README ]; then
  show -i "克隆新版openwrt"
  sudo -iu openwrt git clone https://git.oschina.net/wenchangshou/openwrt.git openwrt.git
  #git clone http://git.openwrt.org/14.07/openwrt.git openwrt.git
else
  show -i "更新最新版openwrt"
  cd openwrt.git
  sudo -iu openwrt git pull
fi

cd $rootdir/openwrt.git
git_prefix=`git log -1 --format="works/%ad_%h" --date=short`
git_targz=`git log -1 --format="openwrt_%ad_%h.tar.gz" --date=short`

if [ ! -f ../$git_targz -a ! -f ../backup/$git_targz -o ! -L $rootdir/openwrt ]; then
  show -i "导出最新版openwrt"
  sudo -iu openwrt git archive --format=tar --prefix=$git_prefix/ HEAD | gzip > ../$git_targz
  echo "$git_prefix" > ../lastgit
fi
cd $rootdir
if [ ! -d $git_prefix -a -f $git_targz ]; then
  show -i "解压最新版openwrt"
  #cd works
  sudo -iu openwrt tar zxvf $git_targz
  if [ ! -d $git_prefix.orig ]; then
    sudo -iu openwrt mv $git_prefix $git_prefix.orig
    sudo -iu openwrt tar zxvf $git_targz
  fi
  sudo -iu openwrt mv $git_targz backup/$git_targz
  #cd ..
fi

if [ -L openwrt ]; then
  sudo -iu openwrt rm -rf openwrt
fi

if [ ! -f openwrt -a -d $git_prefix ]; then
  sudo -iu openwrt ln -s $git_prefix openwrt
fi

if [ -d $git_prefix ]; then
  if [ -d dl -a ! -L $git_prefix/dl ]; then
    show -i "链接dl目录"
    sudo -iu openwrt ln -s ../../dl $git_prefix/dl
  fi
  if [ -d staging_dir -a ! -L $git_prefix/staging_dir ]; then
    show -i "链接staging_dir目录"
    sudo -iu openwrt ln -s ../../staging_dir $git_prefix/staging_dir
  fi
  if [ -d build_dir -a ! -L $git_prefix/build_dir ]; then
    show -i "链接build_dir目录"
    sudo -iu openwrt ln -s ../../build_dir $git_prefix/build_dir
  fi
  cd $git_prefix
  if [ ! -f feeds.conf ]; then
    show -i "复制feeds.conf文件"
    sudo -iu openwrt cp feeds.conf.default feeds.conf
  fi
  #awk '{if ($0 == "HOST_CONFIGURE_ARGS += --with-internal-glib") printf \
  #"HOST_CONFIGURE_ARGS += --with-internal-glib --enable-iconv=no --with-libiconv=gnu\n"; else printf $0"\n"}' \
  #tools/pkg-config/Makefile 1<>tools/pkg-config/Makefile
  #find_replace_line "tools/pkg-config/Makefile" "HOST_CONFIGURE_ARGS += --with-internal-glib" "HOST_CONFIGURE_ARGS += --with-internal-glib --enable-iconv=no --with-libiconv=gnu"
  
  if [ -z "$args_mode" ]; then
    show -i "更新并安装feeds"
    sudo -iu openwrt ./scripts/feeds update -a
    sudo -iu openwrt ./scripts/feeds install -a
    sudo -iu openwrt make defconfig
  fi
  
  #make defconfig
  find_replace_line .config "CONFIG_DOWNLOAD_FOLDER=\\\"\\\"" "CONFIG_DOWNLOAD_FOLDER=\\\"$rootdir/dl/\\\""
  echo "$git_prefix" > ../../usegit
  echo "==========================="
  echo "  现在可以编译openwrt 最新版了"
  echo "  cd $rootdir/$git_prefix"
  echo "  [option] ./scripts/feeds update -a"
  echo "  [option] ./scripts/feeds install -a"
  echo "  make defconfig"
  echo "  make menuconfig"
  echo "  [option] make download"
  echo "  [screen] make V=99"
  echo "  [screen] make -j 4 V=99"
  echo "==========================="
fi

