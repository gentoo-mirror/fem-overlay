# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"
WANT_ANT_TASKS="ant-nodeps"

inherit eutils git java-pkg-2 java-ant-2

DESCRIPTION="Java tool to browse media galleries of some german public broadcasting stations"
HOMEPAGE="http://zdfmediathk.sourceforge.net"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vlc mplayer flvstreamer"

EGIT_REPO_URI="git://zdfmediathk.git.sourceforge.net/gitroot/zdfmediathk/zdfmediathk"

COMMON_DEPS="dev-java/jdom
	     dev-java/commons-lang
	     dev-java/rome
	     dev-java/commons-compress"

DEPEND="${COMMON_DEPS}
	>=virtual/jdk-1.5.0
	dev-java/ant-nodeps"

RDEPEND="${COMMON_DEPS}
	virtual/jre
	vlc? ( media-video/vlc )
	mplayer? ( || (
		media-video/mplayer
		media-video/mplayer2
	) )
	flvstreamer? ( media-video/flvstreamer )"

pkg_setup() {
	if ! ( use vlc || use mplayer ); then
		ewarn "No mediaplayer selected."
		ewarn "You should select at least one mediaplayer (mplayer, flv, vlc)."
		die
	fi
}

java_prepare() {
	cd "${S}/libs"
	rm -v commons-* jdom-* rome-*  || die

	java-pkg_jar-from jdom-1.0
	java-pkg_jar-from commons-lang-2.1 commons-lang.jar commons-lang-2.5.jar
	java-pkg_jar-from commons-compress commons-compress.jar commons-compress-1.1.jar
	java-pkg_jar-from rome rome.jar rome-1.0.jar
}

src_install() {
	java-pkg_newjar dist/Mediathek.jar
	java-pkg_dolauncher ${PN} --main mediathek.Main

	newicon ${FILESDIR}/java.png ${PN}.png || die "newicon failed"
	make_desktop_entry "${PN}" "MediathekView" mediathekview "Network"
}
