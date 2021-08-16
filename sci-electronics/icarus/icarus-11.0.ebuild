# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

inherit autotools

DESCRIPTION="A free implementation of Verilog (IEEE-1364)"
HOMEPAGE="http://iverilog.icarus.com/"
SRC_URI="https://github.com/steveicarus/iverilog/archive/v${PV//./_}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

BDEPEND="
	sys-devel/bison
	sys-devel/flex
	dev-util/gperf
	sys-libs/readline:0"
RDEPEND="
	sys-libs/readline:0"

S="${WORKDIR}/iverilog-${PV//./_}"

src_prepare() {
	default
	sh autoconf.sh
}

src_install() {
	emake DESTDIR="${D}" install
}
