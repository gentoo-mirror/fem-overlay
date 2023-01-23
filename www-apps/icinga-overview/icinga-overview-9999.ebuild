# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Simple Icinga-Classic-UI-like overview for Icinga2"
HOMEPAGE="https://gitlab.fem-net.de/monitoring/icinga-overview"
SRC_URI=""
EGIT_REPO_URI="https://gitlab.fem-net.de/monitoring/icinga-overview.git"

# Only the upstream license. The dependencies are installed in pkg_config() and
# thus not directly by portage.
LICENSE="AGPL-3"
SLOT="0"
KEYWORDS=""

# We run npm in pkg_config
DEPEND="
	acct-group/nginx
"
RDEPEND="
	${DEPEND}

	net-libs/nodejs[npm]
"

src_install() {
	insinto /opt/icinga-overview
	doins -r ./*

	insinto /etc/icinga-overview
	newins config.example.php api-config.php
	newins vue.config.example.js vue-config.js
	newins src/config.example.js frontend-config.js

	local configs=(
		"api-config.php:config.php"
		"vue-config.js:vue.config.js"
	)
	local config
	for config in "${configs[@]}"; do
		dosym "../../etc/icinga-overview/${config%:*}" "/opt/icinga-overview/${config#*:}"
		fperms 640 "/etc/icinga-overview/${config%:*}"
	done
	# That one config file that is in a different directory
	dosym "../../../etc/icinga-overview/frontend-config.js" "/opt/icinga-overview/src/config.js"

	fowners -R root:nginx /etc/icinga-overview
	fperms 750 /etc/icinga-overview

	# So the symlink isn't dangling before pkg_config is executed
	keepdir /opt/icinga-overview/dist
	dosym ../../opt/icinga-overview/dist /usr/share/icinga-overview
}

pkg_postinst() {
	elog
	elog "The configuration is located at:"
	elog "    ${EROOT}/etc/icinga-overview"
	elog "    |-- api-config.php      Configuration for the API (config.php)"
	elog "    |-- vue-config.js       Configuration for Vue (vue.config.js)"
	elog "    |-- frontend-config.js  Configuration for the frontend (src/config.js)"
	elog
	elog "Please configure the package. Then, run"
	elog "    emerge --config =${CATEGORY}/${PF}"
	elog "to finalize the package build."
	elog
	elog "Point your webserver to ${EROOT}/opt/icinga-overview/api.php for the API and"
	elog "${EROOT}/usr/share/icinga-overview for the frontend. The package must be"
	elog "configured accordingly."
}

pkg_prerm() {
	ewarn "Files created by this package might remain in"
	ewarn "    ${EROOT}/opt/icinga-overview/dist"
	ewarn "You have to remove these files manually."
}

pkg_config() {
	cd "${EROOT}/opt/icinga-overview" || die
	elog "Installing dependencies"
	npm install || die "Failed to install dependencies"
	elog "Fixing security issues"
	npm audit fix || die "Failed to fix security problems"
	elog "Building web root"
	npm run build || die "Failed to build website"

	elog "Your package is now initialized. The web root is available at"
	elog "    ${EROOT}/usr/share/icinga-overview"
	elog "and the API is available at"
	elog "    ${EROOT}/opt/icinga-overview/backend/api.php"
	elog
	elog "Configure your webserver to serve these files in the paths"
	elog "described by the package's configuration files."
}
