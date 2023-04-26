# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

INSTALLER_VER="$(ver_cut 1)"
FILE_NAME="Install_NDI_SDK_v${INSTALLER_VER}_Linux.sh"

DESCRIPTION="NewTek NDI SDK"
HOMEPAGE="https://www.newtek.com/ndi/sdk/"
SRC_URI="https://downloads.ndi.tv/SDK/NDI_SDK_Linux/Install_NDI_SDK_v${INSTALLER_VER}_Linux.tar.gz -> ${P}.tar.gz"

LICENSE="NDI_EULA_END"
# subslot is SONAME version
SLOT="0/$(ver_cut 1)"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="net-dns/avahi[dbus]"

S="${WORKDIR}/NDI SDK for Linux/"

RESTRICT="bindist mirror"
QA_PREBUILT="usr/*/libndi.so.${PV}"

src_unpack() {
	unpack ${A}
	ARCHIVE="$(awk '/^__NDI_ARCHIVE_BEGIN__/ { print NR+1; exit 0; }' "${WORKDIR}/${FILE_NAME}")" \
		|| die "Failed to find internal archive location"
	tail -n+"$ARCHIVE" "${WORKDIR}/${FILE_NAME}" | tar xvz \
		|| die "Failed to unpack internal archive"
}

src_install() {
	local host
	case "${CHOST}" in
		x86_64-*-linux-gnu)
			host="x86_64-linux-gnu"
			;;
		*)
			die "Unsupported CHOST ${CHOST}"
			;;
	esac

	local ndi_so
	ndi_so="libndi.so.${PV}"
	dolib.so "lib/${host}/${ndi_so}"
	dosym "${ndi_so}" "usr/$(get_libdir)/libndi.so.$(ver_cut 1)"
	dosym "libndi.so.$(ver_cut 1)" "usr/$(get_libdir)/libndi.so"

	doheader -r include/*
}
