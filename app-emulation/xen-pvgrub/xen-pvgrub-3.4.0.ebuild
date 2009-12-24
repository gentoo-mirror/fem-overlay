# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/xen-tools/xen-tools-3.4.1-r1.ebuild,v 1.2 2009/10/11 17:00:04 betelgeuse Exp $

EAPI="2"

inherit flag-o-matic eutils multilib

DESCRIPTION="allows to boot Xen domU kernels from a menu.lst laying inside guest filesystem"
HOMEPAGE="http://xen.org/"
SRC_URI="http://bits.xensource.com/oss-xen/release/${PV}/xen-${PV}.tar.gz
	http://alpha.gnu.org/gnu/grub/grub-0.97.tar.gz
	http://www.zlib.net/zlib-1.2.3.tar.gz
	http://www.kernel.org/pub/software/utils/pciutils/pciutils-2.2.9.tar.bz2
	http://download.savannah.gnu.org/releases/lwip/lwip-1.3.0.tar.gz
	ftp://sources.redhat.com/pub/newlib/newlib-1.16.0.tar.gz"
S="${WORKDIR}/xen-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="custom-cflags"

DEPEND="sys-devel/gettext
	sys-devel/gcc"

RDEPEND=">=app-emulation/xen-3.3.0"

src_prepare() {
	# if the user *really* wants to use their own custom-cflags, let them
	if use custom-cflags; then
		einfo "User wants their own CFLAGS - removing defaults"
		# try and remove all the default custom-cflags
		find "${S}" -name Makefile -o -name Rules.mk -o -name Config.mk -exec sed \
			-e 's/CFLAGS\(.*\)=\(.*\)-O3\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-march=i686\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-fomit-frame-pointer\(.*\)/CFLAGS\1=\2\3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-g3*\s\(.*\)/CFLAGS\1=\2 \3/' \
			-e 's/CFLAGS\(.*\)=\(.*\)-O2\(.*\)/CFLAGS\1=\2\3/' \
			-i {} \;
	fi

	sed -i \
	-e 's/WGET=.*/WGET=cp -t . /' \
	-e "s;\$(XEN_EXTFILES_URL);${DISTDIR};" \
	-e 's/$(LD)/$(LD) LDFLAGS=/' \
	-e 's;install-grub: pv-grub;install-grub:;' \
	"${S}"/stubdom/Makefile

	# fix variable declaration to avoid sandbox issue, #253134
	epatch "${FILESDIR}/${PN}-3.3.1-sandbox-fix.patch"
}

src_compile() {
	use custom-cflags || unset CFLAGS
	if test-flag-CC -fno-strict-overflow; then
		append-flags -fno-strict-overflow
	fi

	emake -C tools/include || die "prepare libelf headers failed"

	if use x86; then
		emake XEN_TARGET_ARCH="x86_32" -C stubdom pv-grub || die "compile pv-grub_x86_32 failed"
	fi
	if use amd64; then
		emake XEN_TARGET_ARCH="x86_64" -C stubdom pv-grub || die "compile pv-grub_x86_64 failed"
	fi
}

src_install() {
	if use x86; then
		emake XEN_TARGET_ARCH="x86_32" DESTDIR="${D}" -C stubdom install-grub || die "install pv-grub_x86_32 failed"
	fi
	if use amd64; then
		emake XEN_TARGET_ARCH="x86_64" DESTDIR="${D}" -C stubdom install-grub || die "install pv-grub_x86_64 failed"
	fi
}

pkg_postinst() {
	elog "Official Xen Guide and the unoffical wiki page:"
	elog " http://www.gentoo.org/doc/en/xen-guide.xml"
	elog " http://en.gentoo-wiki.com/wiki/Xen/"
}

