# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=2

inherit eutils toolchain-funcs

DESCRIPTION="Check_MK's Livestatus Module provides immediate access to Nagios' status and log data"
HOMEPAGE="http://mathias-kettner.de/checkmk_livestatus.html"

VERSION="1.1.6p1"
SRC_URI="http://mathias-kettner.de/download/mk-livestatus-${VERSION}.tar.gz"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"

DEPEND=">=net-analyzer/nagios-core-3.2.0"
RDEPEND="${DEPEND}"
S="${WORKDIR}/mk-livestatus-${VERSION}"

src_configure() {
	cd ${S}
	econf \
	    --host=${CHOST} \
	    --prefix=/usr \
	    --libdir=/usr/$(get_libdir)/nagios \
	    --localstatedir=/var/nagios \
	    --sysconfdir=/etc/nagios || die "econf failed"
}

src_compile() {
	cd ${S}
	emake || die "make failed"
}

src_install() {
	cd "${S}/src"
	emake DESTDIR="${D}" install || die "make failed"
}

pkg_postinst() {
	einfo
	einfo "Your task is to load livestatus.o into Nagios. Nagios is told to"
	einfo "load that module and send all status updates event to the module"
	einfo "by the following two lines to nagios.cfg:"
	einfo "  broker_module=/usr/$(get_libdir)/nagios/mk-livestatus/livestatus.o /var/nagios/rw/live"
	einfo "  event_broker_options=-1"
	einfo "Afterwards please restart Nagios."
}
