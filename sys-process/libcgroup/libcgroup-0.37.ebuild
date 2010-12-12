# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit autotools

DESCRIPTION="Control groups, a new kernel feature in Linux 2.6.24 provides a file system interface to manipulate and control the details on task grouping including creation of new task groups (control groups), permission handling and task assignment."
HOMEPAGE="http://libcg.sourceforge.net/"
#SRC_URI="http://downloads.sourceforge.net/project/libcg/libcgroup/v${PV}/${P}.tar.bz2"
SRC_URI="mirror://sourceforge/project/libcg/libcgroup/v${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm"
IUSE="daemon tools pam"

RDEPEND=""
DEPEND="${RDEPEND}"

src_configure() {
	econf $(use_enable tools) $(use_enable pam) $(use_enable daemon)
}

src_install() {
	emake DESTDIR="${D}" install || die "econf failed"
	
	insinto /etc/udev/rules.d
	newins "${FILESDIR}"/${PN}.udev 60-${PN}.rules

	insinto /etc/cgroup/
	newins "${FILESDIR}"/cgconfig.conf cgconfig.conf
	newins "${FILESDIR}"/cgrules.conf cgrules.conf 

	newinitd "${FILESDIR}"/${PN}.initd ${PN}
	newconfd "${FILESDIR}"/${PN}.confd ${PN}

	newinitd "${FILESDIR}"/cgred.initd cgred
	newconfd "${FILESDIR}"/cgred.confd cgred
}

pkg_postinst() {
	elog "To use CGROUPS since system startup"
	elog "add the following line to /etc/fstab"
	elog " cgroup /dev/cgroup cgroup rw 0 0"
	elog " "
}
