# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517="setuptools"
PYTHON_COMPAT=( python3_{10..11} )
inherit distutils-r1

DESCRIPTION="Official Zulip terminal client"
HOMEPAGE="https://github.com/zulip/zulip-terminal"
SRC_URI="https://github.com/zulip/zulip-terminal/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/beautifulsoup4-4.11.1[${PYTHON_USEDEP}]
	>=dev-python/lxml-4.9.2[${PYTHON_USEDEP}]
	>=dev-python/pygments-2.14.0[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.8.2[${PYTHON_USEDEP}]
	>=dev-python/python-zulip-api-0.8.2[${PYTHON_USEDEP}]
	>=dev-python/pytz-2022.7.1[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.5.0[${PYTHON_USEDEP}]
	>=dev-python/tzlocal-2.1[${PYTHON_USEDEP}]
	>=dev-python/urwid-2.1.2[${PYTHON_USEDEP}]
	>=dev-python/urwid_readline-0.13[${PYTHON_USEDEP}]
	dev-python/pyperclip[${PYTHON_USEDEP}]
"
BDEPEND="
	test? ( ${RDEPEND} )
"

distutils_enable_tests pytest

PATCHES=(
	"${FILESDIR}/${P}-pytest-no-cov.patch"
)

python_test() {
	local ignored_tests=(
		"TestMessageBox"
		"test_main_multiple_autohide_options"
		"test_main_multiple_notify_options"
	)
	local ignore_line=""

	local t
	for t in "${ignored_tests[@]}"; do
		ignore_line="${ignore_line} not ${t} and"
	done

	epytest -k "${ignore_line% and}"
}
