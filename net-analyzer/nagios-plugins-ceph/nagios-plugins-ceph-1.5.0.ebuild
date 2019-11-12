# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Nagios plugins for Ceph"
HOMEPAGE="https://github.com/ceph/ceph-nagios-plugins"
SRC_URI="https://github.com/ceph/ceph-nagios-plugins/archive/ceph-nagios-plugins_${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-lang/python:2.7
	sys-cluster/ceph
"
RDEPEND="${DEPEND}"
BDEPEND=""
S="${WORKDIR}/ceph-nagios-plugins-ceph-nagios-plugins_${PV}"

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
