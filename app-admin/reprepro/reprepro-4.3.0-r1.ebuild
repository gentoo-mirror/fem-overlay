# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils autotools db-use

SRC_URI="http://alioth.debian.org/frs/download.php/3427/${PN}_${PV}.orig.tar.gz"
DESCRIPTION="Debian repository creator and maintainer application"
HOMEPAGE="http://packages.debian.org/reprepro"
DEPEND="app-arch/bzip2
	app-arch/gzip
	app-arch/libarchive
	app-crypt/gpgme
	dev-libs/libgpg-error
	>=sys-libs/db-4.3"
RDEPEND=$DEPEND
RESTRICT="mirror"

KEYWORDS="~amd64 ~x86"
IUSE="bzip2"
LICENSE="GPL-2"
SLOT="0"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-4.1.2-gpgme-header-check-1.patch
	eautoreconf
}

src_configure() {
	local myconf="--with-libarchive=yes"
	use bzip2 && myconf="${myconf} --with-libbz2=yes" || myconf="${myconf} --with-libbz2=no"
	econf ${myconf} || die "econf failed"
}

src_install() {
	emake DESTDIR="${D}" install
}
