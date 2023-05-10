# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10,11} )
inherit distutils-r1

DESCRIPTION="Python bindings for the Zulip message API"
HOMEPAGE="
	https://pypi.org/project/zulip/
	https://zulip.com/
"
SRC_URI="
	https://github.com/zulip/python-zulip-api/archive/${PV}.tar.gz -> ${P}.gh.tar.gz
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
	)
"

distutils_enable_tests unittest

S="${WORKDIR}/${P}/zulip"

src_prepare() {
	distutils-r1_src_prepare

	local disabled_tests=(
		"integrations/bridge_with_matrix/test_matrix.py"
	)
	rm "${disabled_tests[@]}" || die "Failed to disable tests"
}

src_install() {
	distutils-r1_src_install

	# These are duplicates and exist in the python package directories as well
	rm -r "${ED}/usr/share/zulip/integrations"
}
