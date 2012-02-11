# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/josm/josm-4550.ebuild,v 1.1 2011/11/24 18:55:06 hanno Exp $

EAPI=4

JAVA_ANT_ENCODING=UTF-8

[[ ${PV} == "9999" ]] && SUBVERSION_ECLASS="subversion"
ESVN_REPO_URI="http://josm.openstreetmap.de/svn/trunk"
inherit eutils java-pkg-2 java-ant-2 ${SUBVERSION_ECLASS}
unset SUBVERSION_ECLASS

DESCRIPTION="Java-based editor for the OpenStreetMap project"
HOMEPAGE="http://josm.openstreetmap.de/"
[[ ${PV} == "9999" ]] || SRC_URI="http://opensource.pennewiss.de/josm/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
[[ ${PV} == "9999" ]] || KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/${PN}"

IUSE=""
RESTRICT="mirror"

src_prepare() {
	if [[ ${PV} == "9999" ]]; then
		sed -i \
			-e "s:josm-custom.jar:josm.jar:" \
			-e "s:josm-custom-optimized.jar:josm-optimized.jar:" \
			build.xml || die "Sed failed"

		# create-revision needs the compile directory to be a svn directory
		# see also http://lists.openstreetmap.org/pipermail/dev/2009-March/014182.html
		sed -i \
			-e "s:arg[ ]value=\".\":arg value=\"${ESVN_STORE_DIR}\/${PN}\/trunk\":" \
			build.xml || die "Sed failed"
	fi
}

src_compile() {
	eant dist-optimized
}

src_install() {
	java-pkg_newjar "dist/${PN}-optimized.jar" "${PN}.jar" || die "java-pkg_newjar failed"
	java-pkg_dolauncher "${PN}" --jar "${PN}.jar" || die "java-pkg_dolauncher failed"

	newicon images/logo.png josm.png || die "newicon failed"
	make_desktop_entry "${PN}" "Java OpenStreetMap Editor" josm "Science;Geoscience"
}
