# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit cmake-utils

DESCRIPTION="XMPP transport/gateway"
HOMEPAGE="http://spectrum.im"

SRC_URI="http://spectrum.im/attachments/download/43/spectrum-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="mysql sqlite symlinks tools staticport"

RDEPEND="dev-libs/libev
		>=dev-libs/poco-1.3.3[mysql?,sqlite?]
		dev-python/xmpppy
		media-gfx/imagemagick[cxx]
		>=net-im/pidgin-2.6.0
		>=net-libs/gloox-1.0"
DEPEND="${RDEPEND}
		dev-util/cmake
		sys-devel/gettext"

PROTOCOL_LIST="aim facebook gg icq irc msn msn_pecan myspace qq simple sipe twitter xmpp yahoo"

pkg_setup() {
	if ! ( use sqlite || use mysql ); then
		ewarn "No database use flag set!"
		ewarn "You need to enable the mysql or sqlite use flag!"
		die
	fi
}

src_install () {
	cmake-utils_src_install

	# Install transports with seperate config files (default).
	# If USE="symlinks" is set, install one config file with symlinks to all transports.

	# Declare (start) port
	port=5347

	# prepare config for mysql or just copy
	cp "${FILESDIR}/spectrum.cfg" "${WORKDIR}/spectrum.cfg"

	if use mysql ; then
	sed -e 's,^\(type\)=sqlite$,\1=mysql,' \
		-e 's,^#\(host=localhost\)$,\1,' \
		-e 's,^#\(user=user\)$,\1,' \
		-e 's,^#\(password=password\)$,\1,' \
		-e 's,^\(database=.*\),#\1,' \
		-e 's,^#\(prefix=.*\),\1,' \
		-i "${WORKDIR}/spectrum.cfg" || die
	fi

	# install shared-config when using symlinks
	if use symlinks; then
		insinto /etc/spectrum
		newins "${WORKDIR}"/spectrum.cfg spectrum-shared-conf || die
	fi

	# install protocol-specific configs or symlinks
	insinto /etc/spectrum
	for protocol in ${PROTOCOL_LIST}; do
		if use symlinks; then
			dosym spectrum-shared-conf "/etc/spectrum/${protocol}:${port}.cfg" || die
			sed -e 's,PROTOCOL,'${protocol}:${port}',g' \
				"${FILESDIR}"/spectrum.confd > "${WORKDIR}"/spectrum.confd
		else
			sed -e 's,\$filename:protocol,'${protocol}',g' \
				-e 's,\$filename:port,'${port}',g' \
				"${WORKDIR}"/spectrum.cfg > "${WORKDIR}/${protocol}.cfg" || die
			sed -e 's,PROTOCOL,'${protocol}',g' \
				"${FILESDIR}"/spectrum.confd > "${WORKDIR}"/spectrum.confd
			doins "${WORKDIR}/${protocol}.cfg" || die
		fi

		# install prepared confd
		newconfd "${WORKDIR}"/spectrum.confd spectrum.${protocol} || die

		if ! use staticport; then
			port=$[${port}+1]
		fi
	done

	# Install init files
	newinitd "${FILESDIR}"/spectrum.initd spectrum || die
	for protocol in ${PROTOCOL_LIST}; do
		dosym spectrum /etc/init.d/spectrum."${protocol}"
	done

	# Directories
	dodir "/var/lib/spectrum" || die
	dodir "/var/log/spectrum" || die
	dodir "/var/run/spectrum" || die

	# Directories for each transport
	for protocol in ${PROTOCOL_LIST}; do
		dodir "/var/lib/spectrum/$protocol/database" || die
		dodir "/var/lib/spectrum/$protocol/userdir" || die
		dodir "/var/lib/spectrum/$protocol/filetransfer_cache" || die
	done

	# Install mysql schema
	if use mysql; then
		insinto "/usr/share/spectrum/schemas"
		doins schemas/* || die
	fi

	# Install misc tools
	if use tools; then
		insinto "/usr/share/spectrum/tools"
		doins tools/* || die
	fi
}

pkg_postinst() {
	# Create jabber-user
	enewgroup jabber
	enewuser jabber -1 -1 -1 jabber

	# Set correct rights
	chown jabber:jabber -R "/etc/spectrum" || die
	chown jabber:jabber -R "/var/lib/spectrum" || die
	chown jabber:jabber -R "/var/log/spectrum" || die
	chown jabber:jabber -R "/var/run/spectrum" || die
	chmod 750 "/etc/spectrum" || die
	chmod 750 "/var/lib/spectrum" || die
	chmod 750 "/var/log/spectrum" || die
	chmod 750 "/var/run/spectrum" || die
}
