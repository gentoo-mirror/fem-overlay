# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Nagios plugins for Ceph"
HOMEPAGE="https://github.com/ceph/ceph-nagios-plugins"
SRC_URI=""
EGIT_REPO_URI="https://github.com/ceph/ceph-nagios-plugins.git"
EGIT_COMMIT="e2dc0c994b8636cc1537f83fbe7320f1546e4338"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	acct-group/nagios
	acct-user/nagios
	dev-lang/python:2.7
	sys-cluster/ceph
"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default
	sed -i -e 's;python;python2;g' "${S}"/src/*
}

src_install() {
	emake DESTDIR="${D}" install sysconfdir=/etc libdir=/usr/$(get_libdir)

	chown -R nagios:nagios "${D}"/usr/$(get_libdir)/nagios/plugins \
		|| die "Failed chown of ${D}usr/$(get_libdir)/nagios/plugins"

	chmod -R o-rwx "${D}"/usr/$(get_libdir)/nagios/plugins \
		|| die "Failed chmod of ${D}usr/$(get_libdir)/nagios/plugins"
}
