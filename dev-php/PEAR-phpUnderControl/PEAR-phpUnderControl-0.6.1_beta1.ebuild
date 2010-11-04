# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PEAR_PV="0.6.1beta1"
PHP_PEAR_PKG_NAME="phpUnderControl"

inherit php-pear-r1

KEYWORDS="~amd64
"
SLOT="0"
DESCRIPTION="CruiseControl addon for PHP"
LICENSE="BSD"
HOMEPAGE="pear.phpundercontrol.org"
SRC_URI="http://pear.phpundercontrol.org//get/phpUnderControl-0.6.1beta1.tgz"

DEPEND="|| ( <dev-lang/php-5.3[pcre,xml,spl]     >=dev-lang/php-5.3[xml] )
    >=dev-lang/php-5.2.0
    >=dev-php/PEAR-PEAR-1.6.0
    >=dev-php5/ezc-Base-1.7
    >=dev-php5/ezc-Graph-1.4.3"
RDEPEND="${DEPEND}"

