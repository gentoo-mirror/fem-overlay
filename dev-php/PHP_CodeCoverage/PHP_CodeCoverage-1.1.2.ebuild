# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PHP_CodeCoverage/PHP_CodeCoverage-1.1.0.ebuild,v 1.2 2012/03/10 15:28:43 olemarkus Exp $

PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_URI="pear.phpunit.de"
PHP_PEAR_PN="PHP_CodeCoverage"
inherit php-pear-lib-r1

DESCRIPTION="Library that provides collection, processing, and rendering functionality for PHP code coverage"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
HOMEPAGE="http://pear.phpunit.de"

RDEPEND="${RDEPEND}
	>=dev-php/ezc-ConsoleTools-1.6
	>=dev-php/File_Iterator-1.3.0
	>=dev-php/PHP_TokenStream-1.1.0
	>=dev-php/Text_Template-1.1.1"
