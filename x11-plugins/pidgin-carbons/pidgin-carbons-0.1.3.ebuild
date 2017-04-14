# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Experimental XEP-0280: Message Carbons plugin for libpurple"
HOMEPAGE="https://github.com/gkdr/carbons"
SRC_URI="https://github.com/gkdr/carbons/archive/v${PV}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
net-im/pidgin
dev-libs/libxml2
dev-libs/glib"

RDEPEND="${DEPEND}"

S="${WORKDIR}/carbons-${PV}"

src_install() {
	dodir /usr/lib/pidgin/
	insinto /usr/lib/pidgin/
	doins build/carbons.so
}
