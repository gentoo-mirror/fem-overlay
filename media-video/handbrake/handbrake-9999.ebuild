# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: 

inherit subversion

ESVN_REPO_URI="svn://svn.handbrake.fr/HandBrake/trunk"
ESVN_PROJECT="HandBrake"


# Build the list of tarballs that HandBrake will use
# This prevents the downloading of the tarballs everytime the 
# package is emerged. They are cached in distfiles like any
# other tarball
CONTRIB_DIR="${ESVN_STORE_DIR}/${ESVN_PROJECT}/trunk/contrib"

SRC_URI="
`
for CONTRIB_FILE in ${CONTRIB_DIR}/version*.txt;
do
	cat ${CONTRIB_FILE};
	echo;
done;
`
"
# Download directly from HandBrake site
RESTRICT="mirror"

DESCRIPTION="A DVD to MPEG-4 converter"
HOMEPAGE="http://handbrake.fr/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
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

	# Check the contrib packages
	einfo "Checking if contrib packages have changed..."
	for CONTRIB_FILE in ${CONTRIB_DIR}/version*.txt;
	do
		CONTRIB_PACKAGE="`cat ${CONTRIB_FILE} \
			| sed 's:.*/::'`"
		if [ ! -e ${DISTDIR}/${CONTRIB_PACKAGE} ]
		then
			eerror "One of the contrib packages is out of date. (${DISTDIR}/${CONTRIB_PACKAGE})"
			eerror "Please run ebuild ${PORTDIR}/${CATEGORY}/${PN}/${PF}.ebuild digest"
			eerror "and restart the merge."
		fi
	done
	einfo "Everything is okay."
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
