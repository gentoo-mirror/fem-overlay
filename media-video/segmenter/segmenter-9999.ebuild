# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"

inherit libtool flag-o-matic eutils multilib autotools subversion

DESCRIPTION="MPEGTS to HTTP segmenter"
HOMEPAGE="http://svn.assembla.com/svn/legend/segmenter/"
# ESVN_REPO_URI="http://svn.assembla.com/svn/legend/segmenter/"
ESVN_REPO_URI="http://subversion.fem.tu-ilmenau.de/repository/cccongress/trunk/tools/MPEGTS-Segmenter/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

RDEPEND=""

DEPEND="
	media-video/ffmpeg
	${RDEPEND}"

src_compile() {
	emake || die "econf failed"
}

src_install() {
	dobin segmenter
}
