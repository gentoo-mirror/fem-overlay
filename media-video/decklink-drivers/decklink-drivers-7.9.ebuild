# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils multilib python

DESCRIPTION="everything you need to set up your Blackmagic DeckLink, Intensity or Multibridge"
HOMEPAGE="http://www.blackmagic-design.com/"
SRC_URI="http://www.blackmagic-design.com/downloads/software/DeckLink_Linux_${PV}.tar.gz"

LICENSE="Blackmagic Design"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="dev-lang/python"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/trunk
instdir="/usr/share/${PN}"

src_unpack() {
#	tar -xzf ${WORKDIR}/DeckLink_Linux_${PV}.tar.gz DeckLink-7.9rc7-x86_64.tar.gz
	if [[ $(uname -m) == "x86_64" ]]; then
		tar -xzf ${DISTDIR}/DeckLink_Linux_${PV}.tar.gz DeckLink-7.9rc7-x86_64.tar.gz
		tar -xzf ${WORKDIR}/DeckLink-7.9rc7-x86_64.tar.gz DeckLink-7.9rc7-x86_64/usr/src/DeckLink-7.9rc7
		mv ${WORKDIR}/DeckLink-7.9rc7-x86_64/usr/src/DeckLink-7.9rc7/* .
		rm ${WORKDIR}/DeckLink-7.9rc7-x86_64.tar.gz
		rm -rf ${WORKDIR}/DeckLink-7.9rc7-x86_64
	else
		tar -xzf ${DISTDIR}/DeckLink_Linux_${PV}.tar.gz DeckLink-7.9rc7-i386.tar.gz
		tar -xzf ${WORKDIR}/DeckLink-7.9rc7-i386.tar.gz DeckLink-7.9rc7-i386/usr/src/DeckLink-7.9rc7
		tar -xzf ${WORKDIR}/DeckLink-7.9rc7-i386.tar.gz DeckLink-7.9rc7-i386/etc
		mv ${WORKDIR}/DeckLink-7.9rc7-i386/usr/src/DeckLink-7.9rc7/* .
		mv ${WORKDIR}/DeckLink-7.9rc7-i386/etc .
		rm ${WORKDIR}/DeckLink-7.9rc7-i386.tar.gz
		rm -rf ${WORKDIR}/DeckLink-7.9rc7-i386
	fi
}

src_compile() {
	make all
}

src_install() {
	mkdir -p ${D}/lib/modules/$(uname -r)/extra
	cp ${WORKDIR}/blackmagic.ko ${D}/lib/modules/$(uname -r)/extra
	cp -a ${WORKDIR}/etc ${D}/etc
}
