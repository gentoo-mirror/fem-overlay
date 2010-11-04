# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PEAR_PV="1.1.3"
PHP_PEAR_PKG_NAME="Console_CommandLine"

inherit php-pear-r1

KEYWORDS="~amd64
"
SLOT="0"
DESCRIPTION="A full featured command line options and arguments parser"
LICENSE="MIT"
HOMEPAGE="pear.php.net"
SRC_URI="http://pear.php.net/get/Console_CommandLine-1.1.3.tgz"

DEPEND=">=dev-lang/php-5.1.0
    >=dev-php/PEAR-PEAR-1.4.0"
RDEPEND="${DEPEND}"

