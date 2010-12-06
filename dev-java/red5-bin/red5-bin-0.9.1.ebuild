# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# http://bugs.gentoo.org/309411

EAPI="2"
inherit eutils

MY_P=${P/_/}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Open Source Flash Server written in Java"
HOMEPAGE="http://code.google.com/p/red5/"
SRC_URI="http://www.red5.org/downloads/0_9/red5-0.9.1.tar.gz"
LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="~amd64 ~x86"
IUSE="doc source"
DEPEND=">=virtual/jdk-1.5
	>=dev-java/ant-core-1.5"
RDEPEND=">=virtual/jdk-1.5"

RED5_HOME=/opt/red5

pkg_setup() {
	enewgroup red5
	enewuser red5 -1 -1 ${RED5_HOME} red5
}


src_install() {
	newinitd "${FILESDIR}"/red5.initd red5
	newconfd "${FILESDIR}"/red5.confd red5
	doenvd "${FILESDIR}"/21red5

	if use doc ; then
		dodoc doc/*
	else
		rm -rf doc
	fi

	if ! use source ; then
		rm src.zip
	fi

	dodir ${RED5_HOME}
	cp -rp red5-0.9.1/* ${D}${RED5_HOME}
	fowners -R red5:red5 ${RED5_HOME}
	fperms 0750 ${RED5_HOME}/red5.sh
	dosym ${RED5_HOME}/webapps /var/lib/red5-webapps
}
