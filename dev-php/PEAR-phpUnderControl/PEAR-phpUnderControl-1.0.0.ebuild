# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PHP_PEAR_PKG_NAME="phpUnderControl"

inherit php-pear-r1

KEYWORDS="~amd64 ~x86"
SLOT="0"
DESCRIPTION="CruiseControl addon for PHP"
LICENSE="BSD"
HOMEPAGE="pear.phpundercontrol.org"
SRC_URI="http://pear.phpundercontrol.org/get/${PEAR_PN}.tgz"
IUSE=""

DEPEND="dev-lang/php[xml]
	>=dev-php/PEAR-PEAR-1.6.0
	>=dev-php/ezc-Base-1.7
	>=dev-php/ezc-Graph-1.4.3"
RDEPEND="${DEPEND}"
