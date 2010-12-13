# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/smarty/smarty-2.6.26.ebuild,v 1.1 2009/07/13 19:11:11 dertobi123 Exp $

inherit php-lib-r1 eutils

KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

MY_S="abhinavsingh-JAXL-f049d08"

DESCRIPTION="Jabber XMPP Client Library in PHP."
HOMEPAGE="http://code.google.com/p/jaxl/"
SRC_URI="http://jaxl.googlecode.com/files/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""
PDEPEND=""

S="${WORKDIR}/${MY_S}"

need_php_by_category

src_install() {
        php-lib-r1_src_install ./ `find core env xep xmpp -type f -print`
	
	fperms 755 ${PHP_LIB_DIR}/env/jaxl.php
	dosym ${PHP_LIB_DIR}/env/jaxl.php /usr/bin/jaxl
}
