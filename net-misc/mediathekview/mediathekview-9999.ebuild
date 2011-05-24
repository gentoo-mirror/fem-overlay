# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
WANT_ANT_TASKS="ant-nodeps"

inherit eutils git java-pkg-2 java-ant-2

DESCRIPTION="Java tool to browse media galleries of some german public broadcasting stations"
HOMEPAGE="zdfmediathk.sourceforge.net"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

EGIT_REPO_URI="git://zdfmediathk.git.sourceforge.net/gitroot/zdfmediathk/zdfmediathk"

COMMON_DEPS="dev-java/jdom
	     dev-java/commons-lang
	     dev-java/rome"

DEPEND="${COMMON_DEPS}
	>=virtual/jdk-1.5.0
	dev-java/ant-nodeps"

RDEPEND="${COMMON_DEPS}
	virtual/jre
 	media-video/flvstreamer"

java_prepare() {
        cd "${S}/libs"
        rm -v commons-lang-* jdom-* rome-*  || die

        java-pkg_jar-from jdom-1.0
        java-pkg_jar-from commons-lang-2.1 commons-lang.jar commons-lang-2.5.jar
        java-pkg_jar-from rome rome.jar rome-1.0.jar
}

src_install() {
	java-pkg_newjar dist/Mediathek.jar
	java-pkg_dojar libs/commons-compress-1.1.jar
	java-pkg_dolauncher ${PN} --main mediathek.Main
}
