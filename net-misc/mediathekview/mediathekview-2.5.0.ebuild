# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

JAVA_PKG_IUSE="doc source"

WANT_ANT_TASKS="ant-nodeps"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Download files from the public broadcasting services"
HOMEPAGE="http://zdfmediathek.sourceforge.net"
SRC_URI="http://users.minet.uni-jena.de/~veelai/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMONDEPEND="dev-java/rome
			  dev-java/jdom:1.0
			  dev-java/commons-lang:2.1"
DEPEND="${DEPEND}
		>=virtual/jdk-1.4
		${COMMONDEPEND}"
RDEPEND="${RDEPEND}
		 >=virtual/jre-1.4
		 media-video/vlc
		 media-video/mplayer
		 media-video/flvstreamer
		 ${COMMONDEPEND}"

src_prepare() {
	einfo "Removing bundled jars."
	rm libs/jdom.jar || die
	rm libs/rome.jar || die
	rm libs/commons-lang.jar || die

	cd "${S}"/libs || die
	java-pkg_jar-from jdom-1.0 jdom.jar
	java-pkg_jar-from rome rome.jar
	java-pkg_jar-from commons-lang-2.1 commons-lang.jar
}

src_install() {
	java-pkg_dojar dist/Mediathek.jar
	java-pkg_jarinto /usr/share/${PN}/lib/lib/
	java-pkg_dojar libs/jdom.jar
	java-pkg_dojar libs/rome.jar
	java-pkg_dojar libs/commons-lang.jar
	java-pkg_dojar libs/commons-compress.jar
	java-pkg_dolauncher ${PN} --main mediathek.Main
}