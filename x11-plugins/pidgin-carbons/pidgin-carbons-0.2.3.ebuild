# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Experimental XEP-0280: Message Carbons plugin for libpurple"
HOMEPAGE="https://github.com/gkdr/carbons"
SRC_URI="https://github.com/gkdr/carbons/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	net-im/pidgin
	dev-libs/libxml2
	dev-libs/glib

	test? (
		dev-util/cmocka
	)
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/carbons-${PV}"

RESTRICT="!test? ( test )"
