# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="NewTek NDI SDK"
SRC_URI="InstallNDISDK_v3_Linux.sh"

LICENSE="NDI_EULA_END"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
RESTRICT="fetch"

HOMEPAGE="https://www.newtek.com/ndi/sdk/"
# supress QA warnings about stripping etc., i.e. stuff we cannot change since we install prebuilt binaries
QA_PREBUILT="usr/lib64/libndi.so.${PV}"

DEPEND=""
RDEPEND="
net-dns/avahi[dbus]
${DEPEND}"

pkg_nofetch() {
	einfo "Please visit ${HOMEPAGE} and register for the NDI developer program."
	einfo "From the mail you will revice, download the linux sdk and move it to ${DISTDIR}"
	einfo ""
	einfo "  expected filenames: ${SRC_URI}"
	einfo ""
	einfo "The license should be shown and has to be accepted before the download"
	einfo "starts."
}

src_unpack() {
	ARCHIVE=`awk '/^__NDI_ARCHIVE_BEGIN__/ { print NR+1; exit 0; }' "${DISTDIR}/${SRC_URI}"`
	tail -n+$ARCHIVE "${DISTDIR}/${SRC_URI}" | tar xvz
	S="${WORKDIR}/NDI SDK for Linux/"
}

src_install() {
	dolib "${S}/lib/x86_64-linux-gnu/libndi.so.${PV}"
	dosym "libndi.so.${PV}" "/usr/lib64/libndi.so.3"
	dosym "libndi.so.3" "/usr/lib64/libndi.so"
	headers=(
		'Processing.NDI.DynamicLoad.h'
		'Processing.NDI.Find.h'
		'Processing.NDI.Lib.cplusplus.h'
		'Processing.NDI.Lib.h'
		'Processing.NDI.Recv.ex.h'
		'Processing.NDI.Recv.h'
		'Processing.NDI.Routing.h'
		'Processing.NDI.Send.h'
		'Processing.NDI.compat.h'
		'Processing.NDI.deprecated.h'
		'Processing.NDI.structs.h'
		'Processing.NDI.utilities.h'
	)
	for header in "${headers[@]}"; do
		doheader "${S}/include/${header}"
	done
}
