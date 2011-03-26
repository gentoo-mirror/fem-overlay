# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/duplicity/duplicity-0.6.11.ebuild,v 1.2 2011/01/04 22:01:07 xmw Exp $

EAPI="3"
PYTHON_DEPEND="2"

inherit distutils

DESCRIPTION="duplicity is a secure backup system using gnupg to encrypt data"
HOMEPAGE="http://www.nongnu.org/duplicity/"
SRC_URI="http://code.launchpad.net/${PN}/0.6-series/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="s3 ftps"

DEPEND=">=dev-lang/python-2.3
	>=net-libs/librsync-0.9.6
	!ftps? ( >=net-ftp/ncftp-3.1.9 )
        ftps? ( net-ftp/lftp[gnutls] )
	app-crypt/gnupg"
RDEPEND="${DEPEND}
	>=dev-python/py-gnupg-0.3.2
	>=dev-python/pexpect-2.1
	s3? ( dev-python/boto )"

pkg_setup() {
        python_set_active_version 2
        python_pkg_setup
}

src_install() {
	distutils_src_install
	rm "${ED}"/usr/share/doc/${P}/COPYING
}
