# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="XMPP Command Line Interface"
HOMEPAGE="https://codeberg.org/Anoxinon_e.V./xmppc"
SRC_URI="https://codeberg.org/Anoxinon_e.V./xmppc/archive/${PV}-1.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	app-crypt/gpgme
	>=dev-libs/libstrophe-0.9.2
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}"

src_configure() {
	./bootstrap.sh || die "Boostrapping failed"
	econf
}
