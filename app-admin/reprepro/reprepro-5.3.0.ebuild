# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

TAG="reprepro-debian-5.3.0-1"

DESCRIPTION="Debian APT repository creator and maintainer application"
HOMEPAGE="https://salsa.debian.org/brlink/reprepro"
SRC_URI="https://salsa.debian.org/brlink/${PN}/-/archive/${TAG}/${PN}-${TAG}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="archive bzip2 gpgme"

DEPEND=">=sys-libs/db-4.3:*
	sys-libs/zlib
	gpgme? ( app-crypt/gpgme dev-libs/libgpg-error )
	archive? ( app-arch/libarchive )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${TAG}"

src_configure() {
	use gpgme && append-cppflags -I/usr/include/gpgme
	econf \
		$(use_with gpgme libgpgme) \
		$(use_with archive libarchive) \
		$(use_with bzip2 libbz2)
}
