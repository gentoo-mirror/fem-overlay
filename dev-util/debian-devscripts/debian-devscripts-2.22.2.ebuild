# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit bash-completion-r1 perl-functions python-any-r1

MY_PN="${PN#debian-}"
MY_P="${MY_PN}-v${PV}"

DESCRIPTION="Scripts to help Debian package maintenance"
HOMEPAGE="https://www.debian.org/ https://salsa.debian.org/debian/devscripts"
SRC_URI="https://salsa.debian.org/debian/devscripts/-/archive/v${PV}/devscripts-v${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	dev-lang/perl
	dev-perl/Git-Wrapper
	dev-perl/List-Compare
	dev-perl/Moo
	dev-perl/String-ShellQuote
	virtual/perl-DB_File
"
BDEPEND="
	${PYTHON_DEPS}
	app-arch/dpkg
	virtual/pkgconfig
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	echo "${PV}" > version
	# Stylesheet not available in Gentoo, so we patch it to use a different one
	for dir in scripts po4a; do
		sed -i \
			's#/usr/share/sgml/docbook/stylesheet/xsl/nwalsh/manpages/docbook.xsl#/usr/share/sgml/docbook/xsl-stylesheets/manpages/docbook.xsl#g' \
			${dir}/Makefile || die
		sed -i \
			"s#python3#${EPYTHON}#g" \
			${dir}/Makefile || die
		sed -i \
			"s#--install-layout=deb##g" \
			${dir}/Makefile || die
	done
}

src_compile() {
	emake \
		version \
		make_scripts \
		conf.default
}

src_install() {
	einstalldocs
	emake COMPL_DIR="$(get_bashcompdir)" PREFIX="${EPREFIX}/usr" DESTDIR="${D}" install_scripts install_doc

	perl_domodule -r lib/*

	dosym debchange "${EPREFIX}"/usr/bin/dch
}
