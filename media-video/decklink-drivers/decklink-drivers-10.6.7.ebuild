# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit linux-mod

DESCRIPTION="Desktop Video - drivers and tools for products by Blackmagic Design including DeckLink and Intensity"
HOMEPAGE="http://www.blackmagicdesign.com/"

# Desktop Video Revision
REV="a1"

# SDK Package Version
SDK_VERSION="10.6.6"

SRC_URI="Blackmagic_Desktop_Video_Linux_${PV}.tar.gz
headers? ( Blackmagic_DeckLink_SDK_${SDK_VERSION}.zip )"
UNPACKED_DIR="desktopvideo-${PV}${REV}-x86_64"

LICENSE="BlackmagicDesktopVideo"
SLOT="0"
KEYWORDS="~amd64"
IUSE="autostart +headers X"
RESTRICT="fetch"

DEPEND="!media-libs/decklink-libs"
RDEPEND="${DEPEND}
X? ( dev-qt/qtgui:4 )"

# supress QA warnings about stripping etc., i.e. stuff we cannot change since we install prebuilt binaries
QA_PREBUILT="opt/blackmagic-desktop-video/usr/bin/* opt/blackmagic-desktop-video/usr/lib/*"

# for kernel module compilation
MODULE_NAMES="blackmagic(misc:${S}/usr/src/blackmagic-${PV}${REV})
blackmagic-io(misc:${S}/usr/src/blackmagic-io-${PV}${REV})"
BUILD_TARGETS="clean all"

pkg_nofetch() {
        einfo "Please visit ${HOMEPAGE} and download \"Desktop Video ${PV} for Linux\""
        if use headers; then   
                einfo "and \"Desktop Video ${SDK_VERSION} SDK for Linux\""
        fi
        einfo "for your product from the support section and move it to ${DISTDIR}"
        einfo ""
        einfo "  expected filenames: ${SRC_URI}"
        einfo ""
        einfo "The license should be shown and has to be accepted before the download"
        einfo "starts."
}

src_unpack() {
        unpack ${A}

        cd "${WORKDIR}"
        tar xfz Blackmagic_Desktop_Video_Linux_${PV}/other/x86_64/${UNPACKED_DIR}.tar.gz

        # symlink to what is supposed to have been prepared
        ln -s ${UNPACKED_DIR} ${P}
}

src_compile() {
        # library/tools are binary but kernel module requires compilation
        linux-mod_src_compile  
}

src_install() {
        # all pre-built binaries should go into /opt and be symlinked to usr/bin etc.
        installdir="${D}/opt/blackmagic-desktop-video"

        mkdir -p ${installdir} 
        cp -a "${WORKDIR}"/${UNPACKED_DIR}/* ${installdir}/
        rm -rf ${installdir}/usr/src

        symlinks=(
                        'usr/bin/BlackmagicFirmwareUpdater'
                        'usr/lib/libDeckLinkAPI.so'
                        'usr/lib/libDeckLinkPreviewAPI.so'
                        'usr/lib/blackmagic'
                        'usr/sbin/DesktopVideoHelper'
                        'usr/share/doc/desktopvideo'
        )
        for path in "${symlinks[@]}"; do
                dosym /opt/blackmagic-desktop-video/${path} ${path}
        done

        if use X; then
                symlinks=(
                        'usr/bin/BlackmagicControlPanel'
                        'usr/bin/BlackmagicFirmwareUpdaterGui'
                        'usr/share/applications/BlackmagicControlPanel.desktop'
                        'usr/share/applications/BlackmagicFirmwareUpdaterGui.desktop'
                        'usr/share/doc/desktopvideo'
                        'usr/share/icons/hicolor/16x16/apps/BlackmagicControlPanel.png'
                        'usr/share/icons/hicolor/16x16/apps/BlackmagicFirmwareUpdaterGui.png'
                        'usr/share/icons/hicolor/32x32/apps/BlackmagicControlPanel.png'
                        'usr/share/icons/hicolor/32x32/apps/BlackmagicFirmwareUpdaterGui.png'
                        'usr/share/icons/hicolor/48x48/apps/BlackmagicControlPanel.png'
                        'usr/share/icons/hicolor/48x48/apps/BlackmagicFirmwareUpdaterGui.png'
                        'usr/share/icons/hicolor/128x128/apps/BlackmagicControlPanel.png'
                        'usr/share/icons/hicolor/128x128/apps/BlackmagicFirmwareUpdaterGui.png'
                        'usr/share/icons/hicolor/256x256/apps/BlackmagicControlPanel.png'
                        'usr/share/icons/hicolor/256x256/apps/BlackmagicFirmwareUpdaterGui.png'
                )
                for path in "${symlinks[@]}"; do
                        dosym /opt/blackmagic-desktop-video/${path} ${path}
                done

                # add firmware check to autostart?
                if use autostart; then
                        dosym /opt/blackmagic-desktop-video/etc/xdg/autostart/BlackmagicFirmwareUpdaterGuiAutostart.desktop /etc/xdg/autostart/BlackmagicFirmwareUpdaterGuiAutostart.desktop
                fi
        fi

        # udev rule should be placed in /lib/udev/rules.d instead
        dosym /opt/blackmagic-desktop-video/etc/udev/rules.d/55-blackmagic.rules /lib/udev/rules.d/55-blackmagic.rules

        if use headers; then   
                # copy headers from SDK
                mkdir -p ${installdir}/usr/include
                cp -a "${WORKDIR}/Blackmagic DeckLink SDK ${SDK_VERSION}/Linux/include" ${installdir}/usr/include/blackmagic

                dosym ${installdir}/usr/include/blackmagic usr/include/blackmagic
        fi

        newinitd "${FILESDIR}/DesktopVideoHelper.initd" blackmagic-DesktopVideoHelper

        # kernel module
        linux-mod_src_install  
}

pkg_postinst() {
        # kernel module
        linux-mod_pkg_postinst 

        #      12345678901234567890123456789012345678901234567890123456789012345678901234567890
        einfo ""
        einfo "Please do *NOT* report any QA errors to Gentoo or Blackmagic!"
        einfo ""
        einfo "The kernel module is simply called blackmagic. You may want to modprobe it now"
        einfo "to see if it works (it should print your devices to kernel log)."
        einfo ""
        einfo "Installed tools are BlackmagicFirmwareUpdater and BlackmagicControlPanel."
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
        einfo "We are reloading udev rules now..."
        /bin/udevadm control --reload-rules || einfo " ... failed, you may want to check this before rebooting!"
}

pkg_postrm() {
        # kernel module
        linux-mod_pkg_postrm   
}

