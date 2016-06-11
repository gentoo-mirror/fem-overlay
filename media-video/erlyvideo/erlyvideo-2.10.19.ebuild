# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
inherit eutils multilib git-r3

DESCRIPTION="an RTMP flash streaming server, written in erlang"
HOMEPAGE="http://erlyvideo.org/"

EGIT_REPO_URI="git://github.com/erlyvideo/erlyvideo-old.git"
EGIT_COMMIT="b09d04ab28a35b416e14fb6942a3c2f4364e5040"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 amd64"
IUSE=""

DEPEND=">=dev-lang/erlang-14.1
	<=dev-lang/erlang-16"
RDEPEND="${DEPEND}"

QA_PRESTRIPPED="/opt/erlyvideo/.*"

src_prepare() {
	eapply_user
	epatch "${FILESDIR}/fix-release.patch"
}

src_compile() {
	emake -j1 release || die "emake release failed"
}

src_install() {
	insinto /opt
	doins -r erlyvideo

	dodir /opt/erlyvideo/lib/erl_interface/ebin
	dodir /opt/erlyvideo/lib/erl_interface/include

	insinto /etc/init.d
	newinitd contrib/erlyvideo erlyvideo

	insinto /etc/erlyvideo
	doins priv/*.conf.sample
}

pkg_preinst() {
	enewuser erlyvideo -1 -1 /opt/erlyvideo/
}

pkg_postinst() {
	if [[ ! -f ${EROOT}etc/erlyvideo/erlyvideo.conf ]] ; then
		einfo "Please create ${EROOT}etc/erlyvideo.conf from ${EROOT}etc/erlyvideo.conf.sample."
	fi
}
