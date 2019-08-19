# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cmake-utils

DESCRIPTION="Tool to derive Icingaweb2 roles file from Icinga2 API"
HOMEPAGE="https://bitbucket.fem.tu-ilmenau.de/projects/MONITOR/repos/webaccess-to-icingaweb2"
SRC_URI=""
EGIT_REPO_URI="https://bitbucket.fem.tu-ilmenau.de/scm/monitor/${PN}.git"
EGIT_SUBMODULES=()

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="net-misc/curl
	>=dev-cpp/nlohmann_json-3.6.0"
RDEPEND="${DEPEND}"
BDEPEND=""

src_prepare() {
	default
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUSE_EXTERNAL_JSON=ON
	)
	cmake-utils_src_configure
}
