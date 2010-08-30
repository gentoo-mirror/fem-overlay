# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="3"

inherit distutils eutils

DESCRIPTION="duplicity is a secure backup system using gnupg to encrypt data"
HOMEPAGE="http://www.nongnu.org/duplicity/"
SRC_URI="http://savannah.nongnu.org/download/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="s3 ftps"

DEPEND=">=dev-lang/python-2.3
	>=net-libs/librsync-0.9.6
	!ftps? ( >=net-ftp/ncftp-3.1.9 )
	ftps? ( net-ftp/lftp )
	app-crypt/gnupg"
RDEPEND="${DEPEND}
	>=dev-python/py-gnupg-0.3.2
	>=dev-python/pexpect-2.1
	s3? ( dev-python/boto )"

src_prepare() {
	use ftps && epatch "${FILESDIR}/${P}-ftps.patch"
}

src_install() {
	distutils_src_install
	rm "${ED}"/usr/share/doc/${P}/COPYING
}
