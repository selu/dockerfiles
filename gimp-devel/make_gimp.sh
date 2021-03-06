#!/bin/bash

# dev setup

export DEBIAN_FRONTEND=noninteractive

apt-get -y update || exit
apt-get install -y apt-utils || exit
apt-get -y upgrade || exit
apt-get -y autoremove || exit

apt-get install -y \
	autoconf \
	automake \
	build-essential \
	dbus-x11 \
	gettext \
	git-core \
	gtk-doc-tools \
	intltool \
	libaa1 \
	libaa1-dev \
	libasound2 \
	libasound2-dev \
	libbz2-1.0 \
	libbz2-dev \
	libexif12 \
	libexif-dev \
	libgexiv2-2 \
	libgexiv2-dev \
	libglib2.0-0 \
	libglib2.0-dev \
	libgs9 \
	libgs-dev \
	libgtk2.0-0 \
	libgtk2.0-bin \
	libgtk2.0-dev \
	libjson-glib-1.0-0 \
	libjson-glib-dev \
	liblcms2-2 \
	liblcms2-dev \
	libmng2 \
	libmng-dev \
	libopenexr22 \
	libopenexr-dev \
	libpoppler-glib8 \
	libpoppler-glib-dev \
	librsvg2-2 \
	librsvg2-dev \
	libtiff5 \
	libtiff5-dev \
	libtool \
	libwebkitgtk-1.0-0 \
	libwebkitgtk-dev \
	libwmf0.2-7 \
	libwmf-dev \
	libxpm4 \
	libxpm-dev \
	openexr \
	python \
	python-dev \
	python-gtk2 \
	python-gtk2-dev \
	ruby \
	valac \
	wget \
	xsltproc \
	--no-install-recommends || exit

apt-get install -y \
	libjson-c-dev \
	libjson-c3 \
	scons \
	--no-install-recommends || exit

unset DEBIAN_FRONTEND

# compile dir

export PREFIX=/usr/local
export PATH=$PREFIX/bin:$PATH
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig:$PREFIX/share/pkgconfig

# get sources

export SRCDIR=/usr/src/gimp-devel
mkdir -p $SRCDIR

cd $SRCDIR

wget -q http://download.gimp.org/mirror/pub/gimp/v2.9/gimp-2.9.2.tar.bz2 || exit
mkdir gimp || exit
tar xjf gimp-2.9.2.tar.bz2 -C gimp --strip-components=1 || exit

wget -q http://download.gimp.org/pub/gegl/0.3/gegl-0.3.4.tar.bz2 || exit
mkdir gegl || exit
tar xjf gegl-0.3.4.tar.bz2 -C gegl --strip-components=1 || exit

wget -q http://download.gimp.org/pub/babl/0.1/babl-0.1.14.tar.bz2 || exit
mkdir babl || exit
tar xjf babl-0.1.14.tar.bz2 -C babl --strip-components=1 || exit

#git clone https://github.com/mypaint/libmypaint.git || exit

# compile and install

cd $SRCDIR/babl
./autogen.sh --prefix=$PREFIX || exit
make -j4 || exit
make install || exit

ldconfig || exit

cd $SRCDIR/gegl
./autogen.sh --prefix=$PREFIX || exit
make -j4 || exit
make install || exit

ldconfig || exit

#cd $SRCDIR/libmypaint
#scons install enable_gegl=true

#ldconfig || exit

cd $SRCDIR/gimp
./configure --prefix=$PREFIX --disable-gtk-doc || exit
make -j4 || exit
make install || exit

ldconfig || exit

# final binary

ln -s `ls /usr/local/bin/gimp-?.* | head -n2` /usr/local/bin/gimp || exit

# dev cleanup

rm -rf $SRCDIR/*

dpkg -l | grep -- -dev | cut -d " " -f 3 | cut -d ":" -f 1 | sort -n | uniq | xargs apt-get -y purge

apt-get purge \
	autoconf \
	automake \
	build-essential \
	wget \
	git-core

apt-get -y autoremove
apt-get clean
rm -rf /var/lib/apt/lists/*
