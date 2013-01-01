# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit autotools fixheadtails eutils multilib scons-utils toolchain-funcs

DESCRIPTION="Galera Cluster for MySQL - synchronous multi-master replication"
HOMEPAGE="http://www.codership.com"
SRC_URI="https://launchpad.net/galera/2.x/${PV}/+download/galera-${PV}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="boost"

RESTRICT="test"

RDEPEND=""
DEPEND="${RDEPEND}
	boost? ( >=dev-libs/boost-1.49.0-r2 )
	dev-libs/check"

src_unpack() {
	unpack ${A}
	mv "${WORKDIR}"/galera-23.2.2-src "${WORKDIR}"/galera-23.2.2
}

src_prepare() {
	epatch "${FILESDIR}"/001_ignoring_return_value.patch
	epatch "${FILESDIR}"/002_boost_build_options.patch
}

src_compile() {
	if use boost ; then
		escons boost=1 CC="$(tc-getCC)"
	else
		escons boost=0 CC="$(tc-getCC)"
	fi
}

src_install() {
	# note: this can be DESTDIR, INSTALL_ROOT, ... depending on package
	escons tests
	# escons INSTALL_ROOT="${D}" install
	dobin garb/garbd
	dolib.so libgalera_smm.so
}
