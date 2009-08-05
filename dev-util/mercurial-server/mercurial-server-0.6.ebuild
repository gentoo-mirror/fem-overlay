# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/xen/xen-3.3.0.ebuild,v 1.1 2008/09/01 00:30:53 rbu Exp $

inherit mercurial distutils

DESCRIPTION="mercurial-server -- software to hosting mercurial repositories"
HOMEPAGE="http://hg.opensource.lshift.net/mercurial-server/"

EHG_REPO_URI="http://hg.opensource.lshift.net/mercurial-server/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/python"
DEPEND="${RDEPEND}"

S="${WORKDIR}"/${PN}

DOCS="doc/configuring-access doc/file-conditions doc/how-it-works doc/security"

pkg_setup() {
    enewgroup hg
    enewuser hg -1 /bin/sh /var/hg hg
}

src_unpack() {
    mercurial_src_unpack
    
    cd "${S}"
    epatch "${FILESDIR}"/${P}-setup_py.patch

    # remove default rule for write access for all users
    sed -i -e '/write user=users\/\*\*/d' "${S}"/src/init/conf/access.conf
}

src_install() {
    distutils_src_install

    cd "${S}"/src
    exeinto /usr/share/${PN}
    doexe hg-ssh refresh-auth init/hginit
    
    insinto /usr/share/${PN}/init
    doins init/hgadmin-hgrc
    
    insinto /etc/${PN}
    doins init/conf/remote-hgrc init/conf/access.conf

    keepdir /etc/${PN}/keys/root
    keepdir /etc/${PN}/keys/users
}

pkg_postinst() {
	elog "Initializing hgadmin repository..."
	su hg -c "/usr/share/${PN}/hginit /usr/share/${PN}"
}
