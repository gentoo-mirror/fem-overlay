# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="$(ver_cut 1)"

DESCRIPTION="Compatibility symlinks for llvm-core/lld"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI=""

LICENSE="GPL-2"
SLOT="${MY_PV}"
KEYWORDS="~amd64"

RDEPEND="
	llvm-core/lld:${MY_PV}
"

S="${WORKDIR}"

src_install() {
	local l
	for l in lld ld.lld ld64.lld lld-link wasm-ld llvm-ar; do
		dosym "../lib/llvm/${MY_PV}/bin/${l}" "/usr/bin/${l}-${MY_PV}"
	done
}
