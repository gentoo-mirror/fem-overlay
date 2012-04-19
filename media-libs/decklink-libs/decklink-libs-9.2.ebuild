# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit eutils multilib python

DESCRIPTION="everything you need to set up your Blackmagic DeckLink, Intensity or Multibridge"
HOMEPAGE="http://www.blackmagic-design.com/"
MY_PV=${PV/_rc*}
MY_RC=${PV/_}"a31"
SRC_URI="http://www.blackmagic-design.com/media/3397912/Blackmagic_Desktop_Video_Linux_${MY_PV}.tar.gz"

LICENSE="BlackMagicDesign"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="X"

DEPEND=""
RDEPEND="dev-libs/libxml2
	X? ( x11-libs/libXrender )"

X86_BM_PACKAGE="desktopvideo-${MY_RC}-i386"
AMD64_BM_PACKAGE="desktopvideo-${MY_RC}-x86_64"

S="${WORKDIR}"

src_unpack() {
	if use amd64 ; then
		tar -xzf "${DISTDIR}/Blackmagic_Desktop_Video_Linux_${MY_PV}.tar.gz" "desktopvideo-${MY_PV}-x86_64.tar.gz"
		tar -xzf "${WORKDIR}/desktopvideo-${MY_PV}-x86_64.tar.gz" "${AMD64_BM_PACKAGE}/usr/bin"
		tar -xzf "${WORKDIR}/desktopvideo-${MY_PV}-x86_64.tar.gz" "${AMD64_BM_PACKAGE}/usr/lib"
		LIBS="${WORKDIR}/${AMD64_BM_PACKAGE}/usr/lib"
	else
		tar -xzf "${DISTDIR}/Blackmagic_Desktop_Video_Linux_${MY_PV}.tar.gz" "desktopvideo-${MY_PV}-i386.tar.gz"
		tar -xzf "${WORKDIR}/desktopvideo-${MY_PV}-i386.tar.gz" "${X86_BM_PACKAGE}/usr/bin"
		tar -xzf "${WORKDIR}/desktopvideo-${MY_PV}-i386.tar.gz" "${X86_BM_PACKAGE}/usr/lib"
		LIBS="${WORKDIR}/${X86_BM_PACKAGE}/usr/lib"
	fi
}

src_install() {
	exeinto /usr/bin
	doexe ${LIBS}/../bin/BlackmagicFirmwareUpdater

	if use X ; then
		doexe ${LIBS}/../bin/BlackmagicControlPanel
	fi

	if use amd64 ; then
		insinto /usr/lib64
		doins ${LIBS}/libDeckLinkAPI.so
		doins ${LIBS}/libDeckLinkPreviewAPI.so
		exeinto /usr/lib64/blackmagic
		doexe ${LIBS}/blackmagic/BlackmagicPreferencesStartup
	else
		insinto /usr/lib
		doins ${LIBS}/libDeckLinkAPI.so
		doins ${LIBS}/libDeckLinkPreviewAPI.so
		exeinto /usr/lib/blackmagic
		doexe ${LIBS}/blackmagic/BlackmagicPreferencesStartup
	fi
}
