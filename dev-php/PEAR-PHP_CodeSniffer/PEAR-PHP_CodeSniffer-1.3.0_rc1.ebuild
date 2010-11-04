# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

PEAR_PV="1.3.0RC1"
PHP_PEAR_PKG_NAME="PHP_CodeSniffer"

inherit php-pear-r1

KEYWORDS="~amd64
"
SLOT="0"
DESCRIPTION="PHP_CodeSniffer tokenises PHP, JavaScript and CSS files and detects violations of a defined set of coding standards."
LICENSE="BSD"
HOMEPAGE="pear.php.net"
SRC_URI="http://pear.php.net/get/PHP_CodeSniffer-1.3.0RC1.tgz"

DEPEND=">=dev-lang/php-5.1.2
    >=dev-php/PEAR-PEAR-1.4.0"
RDEPEND="${DEPEND}"

