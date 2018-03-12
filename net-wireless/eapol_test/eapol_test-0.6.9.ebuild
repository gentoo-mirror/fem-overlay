# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit toolchain-funcs

MY_PN=wpa_supplicant
MY_P=${MY_PN}-${PV}

DESCRIPTION="WPA Supplicants's EAP test utility"
HOMEPAGE="http://hostap.epitest.fi/wpa_supplicant/"
SRC_URI="http://hostap.epitest.fi/releases/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 BSD )"
SLOT="0"
KEYWORDS="~x86 amd64"
IUSE=""

DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}/${MY_PN}"

src_configure() {
	echo "CC = $(tc-getCC)" > .config
	cat defconfig >> .config
}

src_compile() {
	emake "${PN}" || die "emake ${PN} failed."
}

src_install() {
	dobin "${PN}" || die "dobin ${PN} failed."
}
