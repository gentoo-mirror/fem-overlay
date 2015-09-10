# Copyright 2012-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools subversion

DESCRIPTION="PKCS#11 library for Gemalto .NET V2 smart cards"
HOMEPAGE="http://smartcardservices.macosforge.org/trac/browser/trunk/SmartCardServices/src/PKCS11dotNetV2"

ESVN_REPO_URI="http://svn.macosforge.org/repository/smartcardservices/trunk/SmartCardServices/src/PKCS11dotNetV2"
ESVN_PROJECT="PKCS11dotNetV2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/boost
	 sys-apps/pcsc-lite"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	epatch "${FILESDIR}/${PN}-boost-1.56.patch"
	eautoreconf
}

src_configure() {
	econf --enable-system-boost
}
