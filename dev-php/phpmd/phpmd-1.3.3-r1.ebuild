# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_PN="PHP_PMD"
PHP_PEAR_URI="pear.phpmd.org"

inherit php-pear-lib-r1 eutils

DESCRIPTION="PHP mess detector"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
HOMEPAGE="http://www.phpmd.org"

RDEPEND="${RDEPEND}
	dev-php/phpdepend"

src_prepare() {
	cd "${WORKDIR}"
	epatch "${FILESDIR}/${P}-traits.patch"
}
