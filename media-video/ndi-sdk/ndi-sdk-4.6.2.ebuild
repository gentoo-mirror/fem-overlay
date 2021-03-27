# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="NewTek NDI SDK"
FILE_NAME="InstallNDISDK_v4_Linux.sh"
SRC_URI="http://new.tk/NDISDKLINUX -> ${P}.tar.gz"

LICENSE="NDI_EULA_END"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

HOMEPAGE="https://www.newtek.com/ndi/sdk/"
# supress QA warnings about stripping etc., i.e. stuff we cannot change since we install prebuilt binaries
QA_PREBUILT="usr/lib64/libndi.so.${PV}"

DEPEND=""
RDEPEND="
net-dns/avahi[dbus]
${DEPEND}"

src_unpack() {
	unpack ${A}
	ARCHIVE=`awk '/^__NDI_ARCHIVE_BEGIN__/ { print NR+1; exit 0; }' "${WORKDIR}/${FILE_NAME}"`
	tail -n+$ARCHIVE "${WORKDIR}/${FILE_NAME}" | tar xvz
	S="${WORKDIR}/NDI SDK for Linux/"
}

#src_prepare() {
#	ARCHIVE=`awk '/^__NDI_ARCHIVE_BEGIN__/ { print NR+1; exit 0; }' "${W}/${FILE_NAME}"`
#	tail -n+$ARCHIVE "${DISTDIR}/${FILE_NAME}" | tar xvz
#	S="${WORKDIR}/NDI SDK for Linux/"
#}

src_install() {
	if use amd64; then
		dolib "${S}/lib/x86_64-linux-gnu/libndi.so.${PV}"
	fi
	dosym "libndi.so.${PV}" "/usr/$(get_libdir)/libndi.so.4"
	dosym "libndi.so.4" "/usr/$(get_libdir)/libndi.so"
	for header in `ls "${S}/include/"`; do
		doheader "${S}/include/${header}"
	done
}
