# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PEAR_PV="0.9.0"
PHP_PEAR_PKG_NAME="PHP_CodeBrowser"

inherit php-pear-r1

KEYWORDS="~amd64
"
SLOT="0"
DESCRIPTION="PHP_CodeBrowser for integration in Hudson and CruiseControl"
LICENSE="BSD"
HOMEPAGE="pear.phpunit.de"
SRC_URI="http://pear.phpunit.de/get/PHP_CodeBrowser-0.9.0.tgz"

DEPEND="|| ( <dev-lang/php-5.3[xml,pcre,spl]     >=dev-lang/php-5.3[xml] )
    >=dev-lang/php-5.2.6
    >=dev-php/PEAR-PEAR-1.8.1
    >=dev-php/PEAR-Console_CommandLine-1.1.3
    >=dev-php/PEAR-File_Iterator-1.2.1"
RDEPEND="${DEPEND}"

