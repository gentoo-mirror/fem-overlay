# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PEAR_PV="0.9.19"
PHP_PEAR_PKG_NAME="PHP_Depend"

inherit php-pear-r1

KEYWORDS="~amd64
"
SLOT="0"
DESCRIPTION="PHP_Depend design quality metrics for PHP packages"
LICENSE="BSD"
HOMEPAGE="pear.pdepend.org"
SRC_URI="http://pear.pdepend.org/get/PHP_Depend-0.9.19.tgz"

DEPEND="|| ( <dev-lang/php-5.3[pcre,xml,spl,tokenizer,simplexml]     >=dev-lang/php-5.3[xml,tokenizer,simplexml] )
    >=dev-lang/php-5.2.3
    >=dev-php/PEAR-PEAR-1.6.0"
RDEPEND="${DEPEND}"

