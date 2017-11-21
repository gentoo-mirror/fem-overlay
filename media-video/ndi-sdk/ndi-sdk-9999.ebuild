# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="NewTek NDI SDK"
SRC_URI="InstallNDISDK_v3_Linux.sh"

LICENSE="NDI_EULA_END"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

HOMEPAGE="https://www.newtek.com/ndi/sdk/"
# supress QA warnings about stripping etc., i.e. stuff we cannot change since we install prebuilt binaries
QA_PREBUILT="usr/lib64/libndi.so.3.0.9"

DEPEND=""
RDEPEND="${DEPEND}"

pkg_nofetch() {
        einfo "Please visit ${HOMEPAGE} and register for the NDI"
        einfo "from the mail download the linux sdk and move it to ${DISTDIR}"
        einfo ""
        einfo "  expected filenames: ${SRC_URI}"
        einfo ""
        einfo "The license should be shown and has to be accepted before the download"
        einfo "starts."
}

src_unpack() {
	ARCHIVE=`awk '/^__NDI_ARCHIVE_BEGIN__/ { print NR+1; exit 0; }' "${DISTDIR}/${SRC_URI}"`
	tail -n+$ARCHIVE "${DISTDIR}/${SRC_URI}" | tar xvz
	ln -s "${WORKDIR}/NDI SDK for Linux/" ${P}
}

src_install() {
	installdir="${D}opt/ndi"
	mkdir -p "${installdir}"
	dolib "${S}/lib/x86_64-linux-gnu/libndi.so.3.0.9"
	dosym "/usr/lib64/libndi.so.3.0.9" "/usr/lib64/libndi.so.3"
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
