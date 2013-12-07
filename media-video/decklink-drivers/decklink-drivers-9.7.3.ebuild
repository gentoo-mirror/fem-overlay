# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils multilib python linux-mod

DESCRIPTION="everything you need to set up your Blackmagic DeckLink, Intensity or Multibridge"
HOMEPAGE="http://www.blackmagic-design.com/"
MY_PV=${PV/_rc*}
MY_SDK=9.7.1
MY_RC=${PV/_}"a5"
SRC_URI="http://software.blackmagicdesign.com/DesktopVideo/Blackmagic_Desktop_Video_Linux_${MY_PV}.tar.gz
	 http://software.blackmagicdesign.com/SDK/Blackmagic_DeckLink_SDK_${MY_SDK}.zip"

LICENSE="BlackMagicDesign"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="X"

DEPEND="!media-libs/decklink-libs
	app-arch/unzip"
RDEPEND="${DEPEND}
	dev-libs/libxml2
	X? ( x11-libs/libXrender )"

X86_BM_PACKAGE="desktopvideo-${MY_RC}-i386"
AMD64_BM_PACKAGE="desktopvideo-${MY_RC}-x86_64"

S="${WORKDIR}"

src_unpack() {
	default_src_unpack

	if use amd64 ; then
		tar -xzf "${WORKDIR}/desktopvideo-${MY_PV}-x86_64.tar.gz"
		KSRCDIR="${WORKDIR}/${AMD64_BM_PACKAGE}/usr/src/desktopvideo-${MY_RC}/"
		UDEVRULES="${WORKDIR}/${AMD64_BM_PACKAGE}"
		LIBS="${WORKDIR}/${AMD64_BM_PACKAGE}/usr/lib"
	else
		tar -xzf "${WORKDIR}/desktopvideo-${MY_PV}-i386.tar.gz"
		KSRCDIR="${WORKDIR}/${X86_BM_PACKAGE}/usr/src/desktopvideo-${MY_RC}/"
		UDEVRULES="${WORKDIR}/${X86_BM_PACKAGE}"
		LIBS="${WORKDIR}/${X86_BM_PACKAGE}/usr/lib"
	fi
}

src_compile() {
	libdir="extra/"
	BUILD_PARAMS="KERNELDIR=/lib/modules/${KV_FULL}/build"
	BUILD_TARGETS="all"
	MODULE_NAMES="blackmagic(extra:${KSRCDIR}:${KSRCDIR})"
	ebegin "Building blackmagic"
	if use kernel_linux; then
		linux-mod_src_compile
	fi
	eend $?
}

src_install() {
	# install kernel module
	if use kernel_linux; then
		linux-mod_src_install
	fi
	insinto /lib/udev/rules.d/
	doins ${UDEVRULES}/etc/udev/rules.d/20-blackmagic.rules

	# install headers
	cd "${S}/Blackmagic DeckLink SDK ${MY_SDK}/Linux/include"
	insinto /usr/include/blackmagic
	doins *.h *.cpp

	# install binaries
	exeinto /usr/bin
	doexe ${LIBS}/../bin/BlackmagicFirmwareUpdater

	if use X ; then
		doexe ${LIBS}/../bin/BlackmagicControlPanel
	fi

	# install libraries
	insinto /usr/lib
	doins ${LIBS}/libDeckLinkAPI.so
	doins ${LIBS}/libDeckLinkPreviewAPI.so
	exeinto /usr/lib/blackmagic
	doexe ${LIBS}/blackmagic/BlackmagicPreferencesStartup
}
