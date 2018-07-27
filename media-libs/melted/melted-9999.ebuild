# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="MLT Video Server"
HOMEPAGE="https://www.mltframework.org/melted/"
SRC_URI="https://github.com/mltframework/melted/archive/master.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/mlt"
RDEPEND="${DEPEND}"

S=${WORKDIR}/melted-master

src_configure() {
	econf --enable-gpl
}
