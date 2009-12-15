# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

inherit subversion

ESVN_REPO_URI="svn://svn.handbrake.fr/HandBrake/trunk"
ESVN_PROJECT="HandBrake"

DESCRIPTION="A DVD to MPEG-4 converter"
HOMEPAGE="http://handbrake.fr/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="dev-util/ftjam"
DEPEND="${RDEPEND}
"

src_unpack() {
	# Copy the subversion files
	subversion_src_unpack

	# Patch to prevent wget
	cd "${S}"
	epatch "${FILESDIR}/${PN}-wget.patch"

	# We need to create the ChangeLog here
	TZ=UTC svn log -v "${ESVN_REPO_URI}" >ChangeLog
}

src_compile() {
	./configure || die "configure failed"
	jam || die "jam failed"
}

src_install() {
	into /usr
	dobin HandBrakeCLI
	dolib.a libhb/libhb.a

	dodoc AUTHORS BUILD CREDITS ChangeLog NEWS THANKS TRANSLATIONS || die "dodoc failed"
}
