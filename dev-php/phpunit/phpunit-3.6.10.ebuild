# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

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
	dev-lang/php[simplexml,xml,tokenizer]
	>=dev-php/Text_Template-1.1.1
	>=dev-php/PHP_CodeCoverage-1.1.0
	>=dev-php/PHP_Timer-1.0.1
	>=dev-php/PHPUnit_MockObject-1.1.0
	>=dev-php/PHPUnit_Selenium-1.0.1
	>=dev-php/File_Iterator-1.2.3
	>=dev-php/YAML-1.0.2"

pkg_postinst() {
	elog "${PN} can optionally use json, pdo-sqlite and pdo-mysql features."
	elog "If you want those, emerge dev-lang/php with USE=\"json pdo sqlite mysql\"."
}
