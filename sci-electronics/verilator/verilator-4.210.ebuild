# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit multilib

DESCRIPTION="Verilog compiler and simulator"
HOMEPAGE="https://www.veripool.org/wiki/verilator"
SRC_URI="https://www.veripool.org/ftp/${P}.tgz"

LICENSE="|| ( Artistic-2 LGPL-3 )"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=""
RDEPEND="${DEPEND}"
