# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

EAPI="4"

inherit subversion eutils

ESVN_REPO_URI="http://subversion.fem.tu-ilmenau.de/repository/cccongress/trunk/tools/fuse-vdv"
ESVN_PROJECT="fuse-vdv"

DESCRIPTION="FUSE module for working with splitted dv files"
HOMEPAGE="http://subversion.fem.tu-ilmenau.de/repository/cccongress/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE="avi avidemux wavdemux"

DEPEND="sys-fs/fuse
	>=dev-libs/mini-xml-2.6"
RDEPEND="${DEPEND}"

src_prepare() {
	if use avidemux; then
		use avi || die "for avidemux support you need the avi USE flag enabled"
	fi
}

src_configure() {
	econf \
		$(use_with avi) \
		$(use_with avidemux) \
		$(use_with wavdemux)
}

src_install() {
	dobin fuse-vdv || die
}
