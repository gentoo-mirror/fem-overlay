# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
inherit git-r3 python-single-r1

DESCRIPTION="Scripts for NetBox users by FeM e.V."
HOMEPAGE="https://bitbucket.fem.tu-ilmenau.de/projects/NETBOX/repos/netbox-user-scripts/browse"
SRC_URI=""
EGIT_REPO_URI="https://bitbucket.fem.tu-ilmenau.de/scm/netbox/netbox-user-scripts.git"
EGIT_COMMIT="v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+dokuwiki"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="
	${PYTHON_DEPS}

	$(python_gen_cond_dep '
		>=dev-python/fem-netbox-user-scripts-common-0.1[${PYTHON_USEDEP}]
	')

	dokuwiki? (
		$(python_gen_cond_dep '
			>=dev-python/dokuwiki-1.2.1[${PYTHON_USEDEP}]
			>=dev-python/progressbar-2.5[${PYTHON_USEDEP}]
		')
	)
"
BDEPEND=""

src_install() {
	default

	dodoc CHANGELOG.md

	local myscripts=(
		get-aruba-ap-uplinks.py
	)
	use dokuwiki && myscripts+=(export-netbox-to-dokuwiki.py)

	for script in "${myscripts}"; do
		python_newscript ${script} ${script%.py}
	done

	insinto /etc
	newins ${PN}.example.conf ${PN}.conf
}
