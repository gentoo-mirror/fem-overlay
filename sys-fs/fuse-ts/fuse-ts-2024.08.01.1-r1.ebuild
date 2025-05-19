# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="FUSE module for working with splitted MPEG TS files"
HOMEPAGE="https://github.com/a-tze/fuse-ts"
if [[ "${PV}" == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/a-tze/fuse-ts.git"
else
	SRC_URI="https://github.com/a-tze/fuse-ts/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="~amd64"
fi
LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="
	sys-fs/fuse:0
	dev-libs/mxml:=
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-mxml4-support.patch"
)

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		EXTRA_CFLAGS="${CFLAGS}" \
		EXTRA_LFLAGS="${LDFLAGS}"
}

src_install() {
	dobin fuse-ts || die
}
