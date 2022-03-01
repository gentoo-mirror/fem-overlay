# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 cmake

DESCRIPTION="Tool to derive Icingaweb2 roles file from Icinga2 API"
HOMEPAGE="https://gitlab.fem-net.de/monitoring/webaccess-to-icingaweb2"
SRC_URI=""
EGIT_REPO_URI="https://gitlab.fem-net.de/monitoring/webaccess-to-icingaweb2.git"
EGIT_SUBMODULES=()

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="net-misc/curl
	>=dev-cpp/nlohmann_json-3.6.0"
RDEPEND="${DEPEND}"
BDEPEND=""

src_configure() {
	local mycmakeargs=(
		-DUSE_EXTERNAL_JSON=ON
	)
	cmake_src_configure
}
