# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit perl-module

DESCRIPTION="Lightweight RTSP/RTP streaming media server"
HOMEPAGE="https://github.com/revmischa/rtsp-server"
SRC_URI="https://github.com/revmischa/${PN}/archive/${PV}.tar.gz"
SRC_TEST=do

LICENSE="|| ( Artistic GPL-1+ )"
KEYWORDS="~amd64 ~x86"
SLOT="0"

DEPEND="dev-perl/Moose
	dev-perl/MooseX-Getopt
	dev-perl/AnyEvent
	dev-perl/namespace-autoclean
	dev-perl/URI"
RDEPEND="${DEPEND}"

src_install() {
	perl-module_src_install
	dodir /usr/bin
	dosym ${VENDOR_LIB}/RTSP/rtsp-server.pl /usr/bin/rtsp-server
}
