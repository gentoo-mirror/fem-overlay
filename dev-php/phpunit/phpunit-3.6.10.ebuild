# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/phpunit/phpunit-3.6.0.ebuild,v 1.1 2011/11/03 09:43:18 olemarkus Exp $

EAPI="2"
PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_PN="PHPUnit"

PHP_PEAR_URI="pear.phpunit.de"
inherit php-pear-lib-r1

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Unit testing framework for PHP5"
HOMEPAGE="http://www.phpunit.de/"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=">=dev-php/PEAR-PEAR-1.9.1"
RDEPEND="${DEPEND}
	>=dev-lang/php-5.2.7[simplexml,xml,tokenizer]
	|| ( <dev-lang/php-5.3[pcre,reflection,spl] >=dev-lang/php-5.3 )
	>=dev-php/Text_Template-1.1.1
	>=dev-php/PHP_CodeCoverage-1.1.0
	>=dev-php/PHP_Timer-1.0.1
	>=dev-php/PHPUnit_MockObject-1.1.0
	>=dev-php/PHPUnit-Selenium-1.0.1
	>=dev-php/File_Iterator-1.2.3
	>=dev-php/YAML-1.0.2"

pkg_postinst() {
	elog "${PN} can optionally use json, pdo-sqlite and pdo-mysql features."
	elog "If you want those, emerge dev-lang/php with USE=\"json pdo sqlite mysql\"."
}
