# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="VHDL 2008/93/87 simulator"
HOMEPAGE="http://ghdl.free.fr/"
SRC_URI="https://github.com/ghdl/ghdl/archive/v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/gnat-gpl:6.3.0"
RDEPEND="${DEPEND}"

src_configure() {
	#GNATMAKE=/usr/bin/gnatmake-6.3.0
	export PATH="/usr/x86_64-pc-linux-gnu/gcc-bin/6.3.0/:$PATH"
	#ln -s /usr/bin/gnatmake-6.3.0 ${WORKDIR}/gnatmake
	elog "${PATH}"
	./configure
}

src_compile() {
	GCC_PV=6.3.0
	emake GCC=${CHOST}-gcc-${GCC_PV}
}
