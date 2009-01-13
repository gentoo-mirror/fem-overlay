# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-block/megacli/megacli-2.00.11.ebuild,v 1.1 2008/07/30 06:18:00 wschlich Exp $

inherit rpm

DESCRIPTION="LSI Logic MegaRAID Command Line Interface management tool"
HOMEPAGE="http://www.lsi.com/"
SRC_URI="http://www.lsi.com/DistributionSystem/AssetDocument/support/downloads/megaraid/miscellaneous/linux/${PV}_Linux_MegaCLI.zip"

LICENSE="LSI"
SLOT="0"
# This package can never enter stable, it can't be mirrored and upstream
# can remove the distfiles from their mirror anytime.
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"

RESTRICT="strip mirror test"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	unpack ./MegaCliLin.zip || die "failed to unpack inner ZIP"
	rpm_unpack "${S}"/MegaCli-${PV}-1.i386.rpm || die "failed to unpack RPM"
}

src_compile() {
	echo "Nothing to compile."
}

src_install() {
	exeinto /opt/MegaRAID/MegaCli
	case ${ARCH} in
		amd64) MegaCli=MegaCli64;;
		x86) MegaCli=MegaCli;;
		*) die "invalid ARCH";;
	esac
	doexe opt/MegaRAID/MegaCli/${MegaCli}
	dosym /opt/MegaRAID/MegaCli/${MegaCli} /usr/sbin/MegaCli
}

pkg_postinst() {
	einfo
	einfo "As there's no dedicated manual, you might want to have"
	einfo "a look at the following cheat sheet:"
	einfo "http://tools.rapidsoft.de/perc/perc-cheat-sheet.pdf"
	einfo
}
