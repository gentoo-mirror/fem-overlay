# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils rpm versionator

DESCRIPTION="Adaptec(tm) Storage Manager"
HOMEPAGE="http://www.adaptec.com/en-US/speed/raid/aac/sm/asm_linux_v4_30-16038_rpm.htm"
SRC_URI="amd64? ( http://download.adaptec.com/raid/aac/sm/asm_linux_x64_v4.30-16038.rpm )
         x86? ( http://download.adaptec.com/raid/aac/sm/asm_linux_v4.30-16038.rpm )"

LICENSE="Adaptec"
RESTRICT="mirror strip"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND="sys-libs/glibc
          amd64? ( app-emulation/emul-linux-x86-compat  )
          x86? ( sys-libs/lib-compat )
        "
RDEPEND="${DEPEND}"

#src_unpack() {
#       rpm_src_unpack
#}

src_install() {
        exeinto /usr/bin
        doexe ${WORKDIR}/usr/StorMan/arcconf
}

