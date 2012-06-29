# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

JAVA_PKG_IUSE="doc source"

WANT_ANT_TASKS="ant-nodeps"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Download files from the public broadcasting services"
HOMEPAGE="http://zdfmediathek.sourceforge.net"
SRC_URI="http://sourceforge.net/projects/zdfmediathk/files/Mediathek/Mediathek%20${PV}/MediathekView_${PV}.zip"

IUSE=""
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMONDEPEND="dev-java/jdom:1.0
			  dev-java/commons-lang:3.1
			>=dev-java/commons-compress-1.4"
DEPEND="${DEPEND}
		>=virtual/jdk-1.4
		${COMMONDEPEND}"
RDEPEND="${RDEPEND}
		 >=virtual/jre-1.4
		 media-video/vlc
		 media-video/mplayer
		 media-video/flvstreamer
		 ${COMMONDEPEND}"

S=${WORKDIR}

src_prepare() {
	einfo "Removing bundled jars."
	# for now no jdom 2.x ebuild available
	#rm libs/jdom-2.0.0.jar || die
	rm lib/commons-compress-1.4.jar || die
	rm lib/commons-lang3-3.1.jar || die

	cd "${S}"/lib || die
	#java-pkg_jar-from jdom-1.0 jdom.jar
	java-pkg_jar-from commons-compress commons-compress.jar
	java-pkg_jar-from commons-lang-3.1 commons-lang3.jar
}

src_install() {
	java-pkg_dojar MediathekView.jar
	java-pkg_jarinto /usr/share/${PN}/lib/lib
	java-pkg_dojar lib/jdom-2.0.0.jar
	java-pkg_dojar lib/commons-lang3.jar
	java-pkg_dojar lib/commons-compress.jar
	java-pkg_dolauncher ${PN} --main mediathek.Main
}
