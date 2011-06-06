# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils qt4

DESCRIPTION="A Qt4 based map editor for the openstreetmap.org project"
HOMEPAGE="http://merkaartor.be/"
SRC_URI="http://www.merkaartor.be/attachments/download/253/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls webkit exif proj gdal gps proxy"
DEPEND="x11-libs/qt-gui:4
	x11-libs/qt-svg:4
	>=dev-libs/boost-1.38
	webkit? ( >=x11-libs/qt-webkit-4.3.3 )
	exif? ( media-gfx/exiv2 )
	proxy? ( net-libs/libproxy )
	gps?  ( >=sci-geosciences/gpsd-2.92 )
	proj? ( >=sci-libs/proj-4.7 )
	gdal? ( >=sci-libs/gdal-1.6.0 )"
RDEPEND="${DEPEND}"

src_compile() {
	sed -i -e "/QTcpServer/a #include <QTcpSocket>" src/MainWindow.cpp

	local myconf

	myconf="${myconf} NODEBUG=1"
	myconf="${myconf} RELEASE=1"

	use webkit || myconf="${myconf} NOUSEWEBKIT=1"
	use exif && myconf="${myconf} GEOIMAGE=1" || myconf="${myconf} GEOIMAGE=0"
	use proxy && myconf="${myconf} LIBPROXY=1" || myconf="${myconf} LIBPROXY=0"
	use gps && myconf="${myconf} GPSDLIB=1" || myconf="${myconf} GPSDLIB=0"
	use proj && myconf="${myconf} PROJ=1" || myconf="${myconf} PROJ=0"
	use gdal && myconf="${myconf} GDAL=1" || myconf="${myconf} GDAL=0"

	if use nls; then
		lrelease src/src.pro || die "lrelease failed"
	fi

	eqmake4 Merkaartor.pro LIBDIR=/usr/$(get_libdir) PREFIX=/usr ${myconf} || die "eqmake4 failed"
	emake || die "make failed"
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "install failed"
	dodoc AUTHORS CHANGELOG HACKING || die "dodoc failed"

	newicon Icons/Merkaartor_100x100.png "${PN}".png || die "newicon failed"
}

