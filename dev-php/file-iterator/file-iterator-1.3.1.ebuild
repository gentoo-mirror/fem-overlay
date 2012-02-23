# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/file-iterator/file-iterator-1.3.0.ebuild,v 1.1 2011/11/02 13:30:45 olemarkus Exp $

PHP_PEAR_URI="pear.phpunit.de"
PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_PN="File_Iterator"
inherit php-pear-lib-r1

DESCRIPTION="FilterIterator implementation that filters files based on a list of suffixes"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
HOMEPAGE="http://www.phpunit.de"
