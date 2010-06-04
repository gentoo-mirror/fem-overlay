EAPI=1

inherit eutils autotools

DESCRIPTION="Nagios $PV plugins - Pack of plugins to make Nagios work properly"
HOMEPAGE="http://www.nagios.org/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"
IUSE="+suid"

DEPEND=""

RESTRICT="test"

RDEPEND="${DEPEND}"

pkg_setup() {
	enewgroup nagios
	enewuser nagios -1 /bin/bash /var/nagios/home nagios
}

src_unpack() {
	cp "${FILESDIR}"/check_gentoo_portage "${WORKDIR}"
}

src_install() {
	dodir /usr/$(get_libdir)/nagios/plugins
	exeinto /usr/$(get_libdir)/nagios/plugins
	doexe check_gentoo_portage

	chown -R root:nagios "${D}"/usr/$(get_libdir)/nagios/plugins \
		|| die "Failed chown of ${D}usr/$(get_libdir)/nagios/plugins"

	chmod -R o-rwx "${D}"/usr/$(get_libdir)/nagios/plugins \
		|| die "Failed chmod of ${D}usr/$(get_libdir)/nagios/plugins"

	if use suid ; then
		chmod 04750 "${D}"/usr/$(get_libdir)/nagios/plugins/check_gentoo_portage \
			|| die "Failed setting the suid bit for various plugins"
	fi
}
