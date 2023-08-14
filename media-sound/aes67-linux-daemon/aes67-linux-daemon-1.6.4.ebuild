# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LKM_PV="1.7"

inherit systemd linux-mod-r1 cmake

DESCRIPTION="AES67 Linux Daemon with configuration WebUI"
HOMEPAGE="https://github.com/bondagit/aes67-linux-daemon"
SRC_URI="
	https://github.com/bondagit/aes67-linux-daemon/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz
	https://github.com/bondagit/ravenna-alsa-lkm/archive/v${LKM_PV}.tar.gz -> ${PN}-lkm-${LKM_PV}.gh.tar.gz
	https://github.com/bondagit/aes67-linux-daemon/releases/download/v${PV}/webui.tar.gz -> ${P}-webui.tar.gz
"

# Daemon: GPL-3
# Kernel module: GPL-3
# WebApp:
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd zeroconf"

DEPEND="
	acct-user/aes67-daemon
	acct-group/aes67-daemon

	dev-cpp/cpp-httplib:=
	dev-libs/boost:=
	zeroconf? ( net-dns/avahi )
"
RDEPEND="${DEPEND}"

CMAKE_USE_DIR="${S}/daemon"
LKM_S="${WORKDIR}/ravenna-alsa-lkm-${LKM_PV}"
WEBUI_S="${WORKDIR}/dist"

# Weird linker errors on my laptop (nex)
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/daemon-fix-native-httplib-build.patch"
	"${FILESDIR}/daemon-fix-systemd-watchdog.patch"
	"${FILESDIR}/${P}-fix-string-nullptr.patch"
)

src_configure() {
	local mycmakeargs=(
		-DWITH_AVAHI="$(usex zeroconf)"
		-DWITH_SYSTEMD="$(usex systemd)"

		-DENABLE_TESTS=false
		-DFAKE_DRIVER=false
		-DRAVENNA_ALSA_LKM_DIR="${LKM_S}"
	)

	cmake_src_configure
}

src_compile() {
	local modlist=(
		MergingRavennaALSA="net:${LKM_S}/driver:${LKM_S}/driver"
	)

	cmake_src_compile
	linux-mod-r1_src_compile
}

src_install() {
	# Kernel module
	linux-mod-r1_src_install

	# Web UI
	insinto /usr/share/aes67-daemon/webui
	doins -r "${WEBUI_S}/"*

	# Daemon
	einstalldocs

	dobin "${BUILD_DIR}"/aes67-daemon

	exeinto /usr/share/aes67-daemon/scripts
	doexe "daemon/scripts/"*.sh

	insinto /etc/aes67-daemon
	doins systemd/daemon.conf
	sed -i "s#/usr/local\(.*\)#${EPREFIX}/usr\\1#g" "${ED}"/etc/aes67-daemon/daemon.conf
	sed -i "s#/etc/status.json#/var/lib/aes67-daemon/status.json#g" "${ED}"/etc/aes67-daemon/daemon.conf

	insinto /var/lib/aes67-daemon
	doins systemd/status.json
	fowners -R aes67-daemon:aes67-daemon /var/lib/aes67-daemon
	dosym ../../var/lib/aes67-daemon/status.json /etc/aes67-daemon/status.json

	systemd_dounit "${FILESDIR}/aes67-daemon.service"

	newinitd "${FILESDIR}/aes67-daemon-initd" "aes67-daemon"
	newconfd "${FILESDIR}/aes67-daemon-confd" "aes67-daemon"

	insinto /etc/logrotate.d
	newins "${FILESDIR}/logrotate.conf" "${PN}.conf"
}
