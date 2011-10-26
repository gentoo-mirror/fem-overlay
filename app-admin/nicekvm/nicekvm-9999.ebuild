# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/syslog-ng/syslog-ng-3.2.4.ebuild,v 1.8 2011/06/25 16:37:35 armin76 Exp $

EAPI=2
inherit autotools fixheadtails eutils multilib subversion

MY_PV=${PV/_/}
DESCRIPTION="syslog replacement with advanced filtering features"
HOMEPAGE="http://wiki.fem.tu-ilmenau.de/technik/tools/nicekvm"
ESVN_REPO_URI="http://subversion.fem.tu-ilmenau.de/repository/kvm-management-tools"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""
RESTRICT="test"

DEPEND="net-misc/socat
	sys-process/lsof"

src_install() {
	dobin scripte/nkvm
	newinitd scripte/init.d/nicekvm nkvm
}
