# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Multi Multicast DVB to redistribute streams from DVB or ATSC"
HOMEPAGE="https://mumudvb.net"
COMMIT_ID="ed1c176759b544d178c6741789588e6005299de6"
SRC_URI="https://github.com/braice/MuMuDVB/archive/${COMMIT_ID}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-tv/dvbtune
	media-tv/linuxtv-dvb-apps"
RDEPEND="${DEPEND}"

S="${WORKDIR}/MuMuDVB-${COMMIT_ID}"

DOCS=(
	"ChangeLog"
	"doc/README.asciidoc"
	"doc/README_CONF.asciidoc"
	"doc/FAQ.asciidoc"
	"doc/QUICKSTART.asciidoc"
)

src_prepare() {
	autoreconf -i -f
	default
}

src_install() {
	default
	doinitd "${FILESDIR}/mumudvb"
	#doinitd "${S}/scripts/debian/etc/init.d/mumudvb"
	insinto "/etc"
	doins "${FILESDIR}/mumudvb.conf"
}
