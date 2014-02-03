# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_URI="pear.phpunit.de"
PHP_PEAR_PN="phpcpd"

inherit php-pear-lib-r1

DESCRIPTION="Copy/Paste Detector (CPD) for PHP code"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
HOMEPAGE="http://www.phpunit.de"

RDEPEND="${RDEPEND}
	>=dev-php/PHP_Timer-1.0.4
	>=dev-php/PHP_FinderFacade-1.1.0
	>=dev-php/PHP_fDOMDocument-1.4.0
	>=dev-php/PHP_Console-2.2.0
	dev-php/PHP_Version"
