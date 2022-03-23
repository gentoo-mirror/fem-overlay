# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="XMPP Command Line Interface"
HOMEPAGE="https://codeberg.org/Anoxinon_e.V./xmppc"
SRC_URI="https://codeberg.org/Anoxinon_e.V./xmppc/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=app-crypt/gpgme-1.12:=
	>=dev-libs/glib-2.58:2
	>=dev-libs/libstrophe-0.9.2
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${PN}"

src_prepare() {
	eautoreconf
	default
}

src_configure() {
	econf
}
