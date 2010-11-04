# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PEAR_PV="1.2.3"
PHP_PEAR_PKG_NAME="File_Iterator"

inherit php-pear-r1

KEYWORDS="~amd64
"
SLOT="0"
DESCRIPTION="FilterIterator implementation that filters files based on a list of suffixes."
LICENSE="BSD"
HOMEPAGE="pear.phpunit.de"
SRC_URI="http://pear.phpunit.de/get/File_Iterator-1.2.3.tgz"

DEPEND=">=dev-lang/php-5.2.7
    >=dev-php/PEAR-PEAR-1.9.0"
RDEPEND="${DEPEND}"

