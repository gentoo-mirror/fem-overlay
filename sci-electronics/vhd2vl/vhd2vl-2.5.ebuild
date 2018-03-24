# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="VHDL to Verilog Konverter"
HOMEPAGE="http://doolittle.icarus.com/~larry/vhd2vl/"
SRC_URI="http://doolittle.icarus.com/~larry/vhd2vl/vhd2vl-${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="sys-devel/flex
	sys-devel/bison"
RDEPEND=""

S="${WORKDIR}/${P}/src"

src_install() {
	dobin vhd2vl vhd2vl
}
