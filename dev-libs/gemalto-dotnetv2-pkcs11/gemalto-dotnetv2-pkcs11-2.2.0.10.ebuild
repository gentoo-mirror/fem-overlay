# Copyright 2012-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools git-r3

DESCRIPTION="PKCS#11 library for Gemalto .NET V2 smart cards"
HOMEPAGE="http://smartcardservices.macosforge.org/trac/browser/trunk/SmartCardServices/src/PKCS11dotNetV2"

EGIT_REPO_URI="https://github.com/smartcardservices/smartcardservices"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/boost
	 sys-apps/pcsc-lite"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S="${S}/SmartCardServices/src/PKCS11dotNetV2"

src_prepare() {
	epatch "${FILESDIR}/${PN}-boost-1.56.patch"
	eautoreconf
}

src_configure() {
	econf --enable-system-boost
}
