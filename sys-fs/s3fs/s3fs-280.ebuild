# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/s3fs/s3fs-191.ebuild,v 1.1 2010/09/18 01:47:45 jer Exp $

EAPI="2"

inherit eutils toolchain-funcs

MY_PV="1.25"

DESCRIPTION="Amazon mounting S3 via fuse"
HOMEPAGE="http://s3fs.googlecode.com/"
SRC_URI="http://s3fs.googlecode.com/files/${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}-${MY_PV}

DEPEND=">=net-misc/curl-7.17.1
	>=sys-fs/fuse-2.8.4
	dev-libs/libxml2
	dev-libs/openssl"

RDEPEND="${DEPEND}
	app-misc/mime-types"

src_configure() {
	econf || die
}

src_compile() {
	emake CXX="$(tc-getCXX)" || die

}

src_install() {
	cd "${S}/src"
	dobin s3fs || die
}
