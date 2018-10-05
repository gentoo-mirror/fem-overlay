# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1

DESCRIPTION="Mount Apple iPhone/iPod Touch file systems for backup purposes"
HOMEPAGE="http://www.libimobiledevice.org/"
SRC_URI="http://www.libimobiledevice.org/downloads/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="~app-pda/usbmuxd-1.1.0_pre20181004
	~app-pda/libimobiledevice-1.2.1_pre20181004
	>=app-pda/libplist-1.8
	>=sys-fs/fuse-2.7.0"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOC_CONTENTS="Only use this filesystem driver to create backups of your data.
The music database is hashed, and attempting to add files will cause the
iPod/iPhone to consider your database unauthorised.
It will respond by wiping all media files, requiring a restore through iTunes."

src_install() {
	default
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
