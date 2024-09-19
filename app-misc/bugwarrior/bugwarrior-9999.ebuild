# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )
inherit optfeature distutils-r1

DESCRIPTION="Bugtracker to taskwarrior importer"
HOMEPAGE="http://pypi.python.org/pypi/bugwarrior https://github.com/ralphbean/bugwarrior"
if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/GothenburgBitFactory/bugwarrior.git"
	EGIT_BRANCH="develop"
else
	SRC_URI="
		https://github.com/GothenburgBitFactory/bugwarrior/archive/${PV}.tar.gz -> ${P}.gh.tar.gz
	"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"

RDEPEND="
	>=dev-python/dogpile-cache-0.5.3[${PYTHON_USEDEP}]
	>=dev-python/email-validator-1.0.3[${PYTHON_USEDEP}]
	>=dev-python/lockfile-0.9.1[${PYTHON_USEDEP}]
	>=dev-python/pydantic-2[${PYTHON_USEDEP}]
	>=dev-python/taskw-0.8[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/tomli[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}

		dev-python/responses[${PYTHON_USEDEP}]

		dev-python/python-bugzilla[${PYTHON_USEDEP}]
		dev-python/keyring[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

DOCS=( bugwarrior/README.rst )

PATCHES=(
	"${FILESDIR}/${P}-pydanticv2-compat.patch"
)

src_prepare() {
	# Some modules don't have packaged dependencies
	local ignore_modules=(
		"activecollab"
		"bts"
		"gmail"
		"jira"
		"kanboard"
		"megaplan"
		"phab"
		"trac"
		"versionone"
	)
	local m
	for m in "${ignore_modules[@]}"; do
		rm "tests/test_${m}.py"
	done

	distutils-r1_src_prepare
}

pkg_postinst() {
	optfeature "Bugzilla support" "dev-python/python-bugzilla"
	optfeature "GitLab support" "dev-vcs/python-gitlab"
	optfeature "Jira support" "dev-python/jira"
}
