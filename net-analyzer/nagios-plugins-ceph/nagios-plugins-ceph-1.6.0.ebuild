# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )

inherit python-single-r1

DESCRIPTION="Nagios plugins for Ceph"
HOMEPAGE="https://github.com/ceph/ceph-nagios-plugins"
#SRC_URI="https://github.com/ceph/ceph-nagios-plugins/archive/ceph-nagios-plugins_${PV}.tar.gz"
SRC_URI="https://github.com/j-licht/ceph-nagios-plugins/archive/ceph-nagios-plugins_${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	acct-group/nagios
	acct-user/nagios
"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
	sys-cluster/ceph
"
BDEPEND=""
S="${WORKDIR}/ceph-nagios-plugins-ceph-nagios-plugins_${PV}"

src_prepare() {
	default
	python_fix_shebang "${S}"/src/*
}

src_install() {
	emake DESTDIR="${D}" install sysconfdir=/etc libdir=/usr/$(get_libdir)

	fowners -R nagios:nagios /usr/$(get_libdir)/nagios/plugins
	fperms -R o-rwx /usr/$(get_libdir)/nagios/plugins
}
