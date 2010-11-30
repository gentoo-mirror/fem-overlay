# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header:

inherit subversion eutils

ESVN_REPO_URI="http://subversion.fem.tu-ilmenau.de/repository/cccongress/trunk/tools/fuse-vdv"
ESVN_PROJECT="fuse-vdv"

DESCRIPTION="FUSE module for working with splitted dv files"
HOMEPAGE="http://subversion.fem.tu-ilmenau.de/repository/cccongress/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE="avi avidemux"

EAPI="2"

DEPEND="sys-fs/fuse
		dev-libs/mini-xml"
RDEPEND="${DEPEND}"

src_prepare() {
	if use avidemux; then
		use avi || die "for avidemux support you need the avi USE flag enabled"
	fi
}

src_configure() {
	econf \
		$(use_with avi) \
		$(use_with avidemux)
}

src_install() {
	dobin fuse-vdv || die
}