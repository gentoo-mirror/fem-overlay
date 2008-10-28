# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit eutils rpm versionator

DESCRIPTION="LSI(tm) Logic MegaRAID Linux Command Line Interface"
HOMEPAGE="http://www.lsi.com/storage_home/products_home/internal_raid/megaraid_sas/megaraid_sas_8480e/index.html"
#SRC_URI="http://www.lsi.com/support/downloads/megaraid/miscellaneous/linux/${PV}_Linux_Cli.zip"
SRC_URI="http://www.lsi.com/DistributionSystem/AssetDocument/support/downloads/megaraid/miscellaneous/linux/1.01.39_Linux_Cli.zip"

LICENSE="LSI"
RESTRICT="mirror strip"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
	unpack ${A}
	rpm_unpack "${WORKDIR}/${PN}-${PV}-0.i386.rpm"
}

src_install() {
	exeinto /opt/MegaRAID/${PN}

	use amd64 && newexe ${WORKDIR}/opt/MegaRAID/${PN}/${PN}64 ${PN}
	use x86 && doexe ${WORKDIR}/opt/MegaRAID/${PN}/${PN}

	dodir /usr/bin
        dosym /opt/MegaRAID/${PN}/${PN} /usr/bin/${PN}
}
