# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils

DESCRIPTION="radius authentication and accounting support for OpenVPN."
HOMEPAGE="http://www.nongnu.org/radiusplugin/index.html"
SRC_URI="http://www.nongnu.org/radiusplugin/radiusplugin_v2.1a_beta1.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="0"
IUSE=""

DEPEND="dev-libs/libgcrypt:0"
	#=net-misc/openvpn-2"

RDEPEND="${DEPEND}"

src_prepare() {
	cd radiusplugin_v2.1a_beta1
	epatch "${FILESDIR}/100-radiuspluginvlan.patch"
}

src_compile() {
	cd radiusplugin_v2.1a_beta1
	emake || die "emake failed"
}

src_install() {
	cd radiusplugin_v2.1a_beta1
	dodoc README ToDo radiusplugin.cnf
	insinto /etc/openvpn
	doins radiusplugin.cnf radiusplugin.so
}

pkg_postinst() {
	elog "Set the plugin in the OpenVPN configfile: plugin /path/to/plugin/radiusplugin.so [path_to_configfile]"
	elog "Create a configfile for the plugin. If no path is set in the configfile of OpenVPN"
	elog "the plugin will read the file /etc/openvpn/radiusplugin.cnf."
	elog "The configuration is case-sensitive, for an example see radiusplugin.cnf."
}
