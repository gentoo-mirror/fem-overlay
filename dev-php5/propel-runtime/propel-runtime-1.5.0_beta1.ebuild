# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/propel-runtime/propel-runtime-1.3.0_beta4.ebuild,v 1.1 2008/02/26 16:41:25 armin76 Exp $

inherit php-pear-lib-r1 depend.php

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Object Persistence Layer for PHP 5 (Runtime)."
HOMEPAGE="http://propel.phpdb.org/trac/wiki/"
SRC_URI="http://pear.phpdb.org/get/propel_runtime-${PV/_beta/BETA}.tgz"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/php-5.2.4"
RDEPEND="${DEPEND}
	>=dev-php/PEAR-Log-1.8.7-r1"

S="${WORKDIR}/propel_runtime-${PV/_beta/BETA}"

pkg_setup() {
	# We need PDO and a few other things
	require_php_with_use pdo reflection spl xml
}
