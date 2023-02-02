# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop systemd linux-mod udev

DESCRIPTION="Desktop Video drivers & tools for products by Blackmagic Design (e.g. DeckLink)"
HOMEPAGE="https://www.blackmagicdesign.com/"

# Desktop Video Revision
REV="a15"

# SDK Package Version
SDK_VERSION="${PV}"

SRC_URI="Blackmagic_Desktop_Video_Linux_${PV}.tar.gz
headers? ( Blackmagic_DeckLink_SDK_${SDK_VERSION}.zip )"
UNPACKED_DIR="desktopvideo-${PV}${REV}-x86_64"

LICENSE="BlackmagicDesktopVideo"
SLOT="0"
# Some files are precompiled binaries for amd64 only
KEYWORDS="-* ~amd64"
IUSE="autostart +headers X"
# xdg autostart is used, so it won't work on a machine without desktop
REQUIRED_USE="autostart? ( X )"
RESTRICT="fetch"

RDEPEND="
	sys-apps/systemd-utils[udev]
	sys-libs/libcxx
	sys-libs/libcxxabi
	virtual/libusb

	X? (
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5
		dev-qt/qtgui:5
		dev-qt/qtdbus:5
		dev-qt/qtwidgets:5
	)
"
BDEPEND="
	app-arch/unzip
"

PATCHES=(
	"${FILESDIR}/${P}-fix-deprecated-linux-api.patch"
)
S="${WORKDIR}/${UNPACKED_DIR}"

# for kernel module compilation
MODULE_NAMES="
	blackmagic(misc:${S}/usr/src/blackmagic-${PV}${REV})
	blackmagic-io(misc:${S}/usr/src/blackmagic-io-${PV}${REV})
"
BUILD_TARGETS="all"

QA_PREBUILT="usr/*"

pkg_nofetch() {
	einfo "Please visit ${HOMEPAGE} and download \"Desktop Video ${PV} for Linux\""
	if use headers; then
		einfo "and \"Desktop Video ${SDK_VERSION} SDK for Linux\""
	fi
	einfo "for your product from the support section and move it to DISTDIR"
	einfo ""
	einfo "  expected filenames: ${SRC_URI}"
	einfo ""
	einfo "The license should be shown and has to be accepted before the download"
	einfo "starts."
}

src_unpack() {
	# shellcheck disable=SC2086
	unpack ${A}

	cd "${WORKDIR}" || die
	tar xfz "Blackmagic_Desktop_Video_Linux_${PV}/other/x86_64/${UNPACKED_DIR}.tar.gz" \
		|| die "Failed to unpack driver sources"
}

src_prepare() {
	default
	sed -i "s:usr/lib:usr/$(get_libdir):g" \
		usr/lib/systemd/system/* \
		etc/udev/rules.d/* \
		|| die "Failed to correct lib paths in config files"
}

src_compile() {
	# library/tools are binary but kernel module requires compilation
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install

	udev_dorules etc/udev/rules.d/*.rules

	insinto /etc/dracut.conf.d
	doins etc/dracut.conf.d/*.conf

	dolib.so usr/lib/lib*.so
	dodir "/usr/$(get_libdir)/blackmagic/DesktopVideo"
	cp -vR usr/lib/blackmagic/DesktopVideo/* \
		"${ED}/usr/$(get_libdir)/blackmagic/DesktopVideo" \
		|| die "Failed to copy libs and firmware"

	dosym \
		"../$(get_libdir)/blackmagic/DesktopVideo/DesktopVideoUpdateTool" \
		/usr/bin/DesktopVideoUpdateTool
	dosym \
		"../$(get_libdir)/blackmagic/DesktopVideo/DesktopVideoHelper" \
		/usr/sbin/DesktopVideoHelper
	use X && dosym \
		"../$(get_libdir)/blackmagic/DesktopVideo/BlackmagicDesktopVideoSetup" \
		/usr/bin/BlackmagicDesktopVideoSetup

	if use X; then
		domenu usr/share/applications/*.desktop
		dodoc -r usr/share/doc/*

		local icon_size
		for icon_size in 256 128 48 32 16; do
			doicon -s ${icon_size} usr/share/icons/hicolor/${icon_size}x${icon_size}/*
		done
	fi

	doman usr/share/man/man1/*

	newinitd "${FILESDIR}/DesktopVideoHelper.initd" blackmagic-DesktopVideoHelper
	systemd_dounit usr/lib/systemd/system/*

	if use headers; then
		insinto /usr/include/blackmagic
		# The .cpp files are needed as well
		doins "${WORKDIR}/Blackmagic DeckLink SDK ${SDK_VERSION}/Linux/include"/*.{h,cpp}
	fi

	if use autostart; then
		insinto /etc/xdg/autostart
		doins etc/xdg/autostart/*
	fi

	find "${ED}" -iname "*License*.*" -delete || die
	find "${ED}" \( \
		-iname "libc++*.so*" -o \
		-iname "libgcc*.so*" -o \
		-iname "libqt*.so*" -o \
		-iname "libusb*.so*" \
		\) -delete || die "Failed to remove vendored libs"
}

pkg_postinst() {
	linux-mod_pkg_postinst
	udev_reload

	einfo ""
	einfo "Please do *NOT* report any QA errors to Gentoo or Blackmagic!"
	einfo ""
	einfo "The kernel module is simply called blackmagic or blackmagic-io "
	einfo "depends on your BMD device. You may want to modprobe it now to see "
	einfo "if it works (it should print your devices to kernel log)."
	einfo ""
	einfo "Installed tools are DesktopVideoUpdateTool.  !!!! Notice rename. !!!!"
	einfo "maybe you need to add blackmagic-DesktopVideoHelper to autostart, to be able to list devices"
	einfo ""
	if use autostart; then
		einfo "Automated update check has been installed."
	else
		einfo "Automated update check has *not* been installed this time. (set USE flag"
		einfo "autostart if you want that)"
	fi
	einfo ""
	einfo "If your product is not being recognized, you may need to increase the vmalloc"
	einfo "limit in your kernel. You can do that by adding e.g. vmalloc=256M to your kernel"
	einfo "boot line. You can see current usage by running"
	einfo ""
	einfo " # grep VmallocUsed /proc/meminfo"
	einfo ""
}

pkg_postrm() {
	linux-mod_pkg_postrm
	udev_reload
}
