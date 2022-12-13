# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

SMARTCARDSERVICES_COMMIT="56d046746be2ae4f68bdf58980df588b4d0e6a16"

DESCRIPTION="PKCS#11 library for Gemalto .NET V2 smart cards"
HOMEPAGE="https://github.com/smartcardservices/smartcardservices"
SRC_URI="https://github.com/smartcardservices/smartcardservices/archive/${SMARTCARDSERVICES_COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/boost
	sys-apps/pcsc-lite
	app-crypt/ccid"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}/smartcardservices-${SMARTCARDSERVICES_COMMIT}/SmartCardServices/src/PKCS11dotNetV2"

src_prepare() {
	sed "s;lib/pkcs11;$(get_libdir)/pkcs11;g" -i "${S}/Makefile.am"
	default_src_prepare
	eautoreconf
}

src_configure() {
	econf --enable-system-boost
}

src_install() {
	default
	find "${ED}" -name "*.la" -delete || die
}
