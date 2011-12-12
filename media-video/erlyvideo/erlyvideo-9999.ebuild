# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils multilib python git-2

DESCRIPTION="an RTMP flash streaming server, written in erlang"
HOMEPAGE="http://erlyvideo.org/"

EGIT_REPO_URI="git://github.com/erlyvideo/erlyvideo.git"
#EGIT_COMMIT="master"
#EGIT_BRANCH="${EGIT_COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-lang/erlang-14.1
	dev-lang/ruby"
RDEPEND="${DEPEND}"

QA_PRESTRIPPED="/opt/erlyvideo/.*"

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
