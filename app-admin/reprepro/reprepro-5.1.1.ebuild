# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit flag-o-matic

DESCRIPTION="Debian APT repository creator and maintainer application"
HOMEPAGE="http://mirrorer.alioth.debian.org"
SRC_URI="https://alioth.debian.org/frs/download.php/file/4207/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="archive bzip2 gpgme"

DEPEND=">=sys-libs/db-4.3:*
	sys-libs/zlib
	gpgme? ( app-crypt/gpgme dev-libs/libgpg-error )
	archive? ( app-arch/libarchive )"
RDEPEND="${DEPEND}"

src_configure() {
	use gpgme && append-cppflags -I/usr/include/gpgme
	econf \
		$(use_with gpgme libgpgme) \
		$(use_with archive libarchive) \
		$(use_with bzip2 libbz2)
}
