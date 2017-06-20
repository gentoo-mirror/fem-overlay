# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Secure, Reliable, Transport - Proprietary transport for audio/video data"
HOMEPAGE="https://github.com/Haivision/srt"
EGIT_REPO_URI="https://github.com/Haivision/srt.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-libs/openssl:0
	dev-lang/tcl:0
	dev-util/cmake
	virtual/pkgconfig
"
RDEPEND=""
