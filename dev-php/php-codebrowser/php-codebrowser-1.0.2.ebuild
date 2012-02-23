# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/php-codebrowser/php-codebrowser-1.0.0.ebuild,v 1.2 2011/04/16 12:49:34 olemarkus Exp $

PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_URI="pear.phpunit.de"
PHP_PEAR_PN="PHP_CodeBrowser"
inherit php-pear-lib-r1

DESCRIPTION="Generates a highlighted code browsing parsed from xml reports generated from codesniffer or phpunit."
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
HOMEPAGE="http://pear.phpunit.de"

RDEPEND="${RDEPEND}
	>=dev-php/PEAR-Console_CommandLine-1.1.3
	>=dev-php/file-iterator-1.2.1
	>=dev-php/PEAR-Log-1.12.1"
