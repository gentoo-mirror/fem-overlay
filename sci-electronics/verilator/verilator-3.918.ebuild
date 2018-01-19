# Distributed under the terms of the GNU General Public License v2+

EAPI=4
inherit multilib

DESCRIPTION="Verilog compiler and simulator"
HOMEPAGE="http://www.veripool.org/wiki/verilator"
SRC_URI="http://www.veripool.org/ftp/${P}.tgz"

LICENSE="|| ( Artistic-2 LGPL-3 )"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND=""
RDEPEND="${DEPEND}"
