# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10,11} )
inherit python-single-r1

DESCRIPTION="Scripts for NetBox users by FeM e.V."
HOMEPAGE="https://gitlab.fem-net.de/nexbox/netbox-user-scripts"
SRC_URI="https://gitlab.fem-net.de/nexbox/netbox-user-scripts/-/archive/v${PV}/netbox-user-scripts-v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+dokuwiki"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
# shellcheck disable=SC2016
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

S="${WORKDIR}/netbox-user-scripts-v${PV}"

src_install() {
	default

	dodoc CHANGELOG.md

	local plugin_list="get-aruba-ap-uplinks.py"
	use dokuwiki && plugin_list="${plugin_list} export-netbox-to-dokuwiki.py"

	for script in ${plugin_list}; do
		python_newscript ${script} ${script%.py}
	done

	insinto /etc
	newins ${PN}.example.conf ${PN}.conf
}
