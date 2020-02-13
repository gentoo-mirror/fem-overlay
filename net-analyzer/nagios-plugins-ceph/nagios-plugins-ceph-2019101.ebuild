# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

inherit git-r3 python-single-r1

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
"
RDEPEND="
	${DEPEND}
	${PYTHON_DEPS}
	sys-cluster/ceph
"
BDEPEND=""

src_prepare() {
	default
	python_fix_shebang "${S}"/src/*
}

src_install() {
	emake DESTDIR="${D}" install sysconfdir=/etc libdir=/usr/$(get_libdir)

	fowners -R nagios:nagios /usr/$(get_libdir)/nagios/plugins
	fperms -R o-rwx /usr/$(get_libdir)/nagios/plugins
}
