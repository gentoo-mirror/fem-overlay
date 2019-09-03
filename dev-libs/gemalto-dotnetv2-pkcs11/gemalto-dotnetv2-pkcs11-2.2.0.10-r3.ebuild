# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools git-r3 eutils

DESCRIPTION="PKCS#11 library for Gemalto .NET V2 smart cards"
HOMEPAGE="http://smartcardservices.macosforge.org/trac/browser/trunk/SmartCardServices/src/PKCS11dotNetV2"

EGIT_REPO_URI="https://github.com/smartcardservices/smartcardservices"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/boost
	sys-apps/pcsc-lite
	app-crypt/ccid"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${S}/SmartCardServices/src/PKCS11dotNetV2"

src_prepare() {
	sed 's;lib/pkcs11;lib64/pkcs11;g' -i "${S}/Makefile.am"
	default_src_prepare
	eautoreconf
}

src_configure() {
	econf --enable-system-boost
}
