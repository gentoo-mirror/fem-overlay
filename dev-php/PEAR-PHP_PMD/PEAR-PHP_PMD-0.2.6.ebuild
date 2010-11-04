# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PEAR_PV="0.2.6"
PHP_PEAR_PKG_NAME="PHP_PMD"

inherit php-pear-r1

KEYWORDS="~amd64
"
SLOT="0"
DESCRIPTION="PHP Mess Detector"
LICENSE="BSD"
HOMEPAGE="pear.phpmd.org"
SRC_URI="http://pear.phpmd.org//get/PHP_PMD-0.2.6.tgz"

DEPEND="|| ( <dev-lang/php-5.3[pcre,spl,xml,simplexml]     >=dev-lang/php-5.3[xml,simplexml] )
    >=dev-lang/php-5.2.3
    >=dev-php/PEAR-PEAR-1.6.0
    >=dev-php/PEAR-PHP_Depend-0.9.11"
RDEPEND="${DEPEND}"

