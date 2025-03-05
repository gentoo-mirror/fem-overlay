# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

MY_P="${PN}-v${PV}"

DESCRIPTION="C++ library for best-effort Landlock support"
HOMEPAGE="https://gitlab.fem-net.de/admindb/landlockpp/"

if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.fem-net.de/admindb/landlockpp.git"
else
	SRC_URI="https://gitlab.fem-net.de/admindb/landlockpp/-/archive/v${PV}/${MY_P}.tar.bz2"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="test"

DEPEND="
	sys-kernel/linux-headers
	test? (
		dev-cpp/catch:0
	)
"

RESTRICT="!test? ( test )"

src_configure() {
	local emesonargs=(
		"$(meson_use test)"
	)
	meson_src_configure
}
