# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils rpm

DESCRIPTION="Adaptec(tm) Storage Manager"
HOMEPAGE="https://www.adaptec.com/en-US/speed/raid/aac/sm/asm_linux_v4_30-16038_rpm.htm"
SRC_URI="amd64? ( https://download.adaptec.com/raid/aac/sm/asm_linux_x64_v4.30-16038.rpm )
		x86? ( https://download.adaptec.com/raid/aac/sm/asm_linux_v4.30-16038.rpm )"

LICENSE="Adaptec-EULA"
RESTRICT="mirror strip"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/glibc"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	exeinto /usr/bin
	doexe "${WORKDIR}/usr/StorMan/arcconf"
}
