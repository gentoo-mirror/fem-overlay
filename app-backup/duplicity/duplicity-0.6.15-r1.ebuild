# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-backup/duplicity/duplicity-0.6.15.ebuild,v 1.1 2011/09/06 19:33:01 patrick Exp $

EAPI="3"

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="duplicity is a secure backup system using gnupg to encrypt data"
HOMEPAGE="http://www.nongnu.org/duplicity/"
SRC_URI="http://code.launchpad.net/${PN}/0.6-series/${PV}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="ftp ftps s3"

DEPEND="
	>=net-libs/librsync-0.9.6
	app-crypt/gnupg
"
RDEPEND="${DEPEND}
	>=dev-python/py-gnupg-0.3.2
	>=dev-python/pexpect-2.1
	s3? ( dev-python/boto )
	ftp? ( net-lftp/ncftp )
	ftps? ( || ( net-ftp/lftp[ssl] net-ftp/lftp[gnutls] ) )
"

src_prepare() {
	distutils_src_prepare
	sed -i -r "s/'COPYING',//" setup.py || die "Couldn't remove unnecessary COPYING file."
}
