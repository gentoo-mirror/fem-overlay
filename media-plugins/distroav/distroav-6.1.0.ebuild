# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="DistroAV"
MY_P="DistroAV-${PV}"

DESCRIPTION="NewTek NDI integration for OBS Studio"
HOMEPAGE="https://github.com/distroav/distroav"
SRC_URI="https://github.com/distroav/distroav/archive/${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=media-video/obs-studio-31.0.0
	dev-qt/qtbase:6[network,widgets]
	>=media-video/ndi-sdk-6.0:0=
	net-misc/curl
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-4.13.1-ndi-search-paths.patch"
)

src_prepare() {
	# Remove bundled NDI headers, required to support multiple NDI major versions
	rm -r lib/ndi
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		# Build doesn't work without Qt
		-DENABLE_QT=true
	)
	cmake_src_configure
}
