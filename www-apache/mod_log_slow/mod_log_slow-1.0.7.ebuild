# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit apache-module

DESCRIPTION="Apache module for logging of slow requests handling"
HOMEPAGE="https://code.google.com/p/modlogslow/"

MY_P=${P//_/}

SRC_URI="http://modlogslow.googlecode.com/files/${MY_P}.tar.gz"

KEYWORDS="amd64 ppc x86"
LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="sys-devel/libtool"
RDEPEND=""

APACHE2_MOD_CONF="13_${PN}"
APACHE2_MOD_DEFINE="LOG_SLOW"

need_apache2_2

S="${WORKDIR}/${MY_P}"
