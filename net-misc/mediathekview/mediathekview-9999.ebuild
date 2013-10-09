# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
WANT_ANT_TASKS="ant-nodeps"

inherit eutils git-2 java-pkg-2 java-ant-2

DESCRIPTION="Java tool to browse media galleries of some german public broadcasting stations"
HOMEPAGE="http://zdfmediathk.sourceforge.net"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vlc mplayer flvstreamer"

EGIT_REPO_URI="git://zdfmediathk.git.sourceforge.net/gitroot/zdfmediathk/MediathekView-3"

COMMON_DEPS=" dev-java/commons-lang:3.1
			>=dev-java/commons-compress-1.4"

DEPEND="${COMMON_DEPS}
	>=virtual/jdk-1.4.0
	dev-java/ant-nodeps"

RDEPEND="${COMMON_DEPS}
	>=virtual/jre-1.4
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
	# skip post_jar.sh
	sed -i -e "s#post-jar#post-jar-disabled#g" "${S}"/build.xml

	cd "${S}/libs"
	rm -v commons-* || die

	java-pkg_jar-from commons-lang-3.1 commons-lang3.jar commons-lang3-3.1.jar
	java-pkg_jar-from commons-compress commons-compress.jar commons-compress-1.4.jar
}

src_install() {
	java-pkg_newjar dist/MediathekView.jar
	java-pkg_jarinto /usr/share/${PN}/lib/lib
	java-pkg_dojar libs/commons-lang3-3.1.jar
	java-pkg_dojar libs/commons-compress-1.4.jar
	java-pkg_dolauncher ${PN} --main mediathek.Main

	newicon "${FILESDIR}/java.png" ${PN}.png || die "newicon failed"
	make_desktop_entry "${PN}" "MediathekView" mediathekview "Network"
}
