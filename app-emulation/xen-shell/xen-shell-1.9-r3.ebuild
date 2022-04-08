# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit "bash-completion-r1"

DESCRIPTION="allow a user to control multiple Xen instances"
HOMEPAGE="https://www.xen-tools.org/software/xen-shell/"
SRC_URI="https://www.xen-tools.org/software/xen-shell/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-lang/perl
	dev-perl/Term-ReadLine-Gnu
	app-misc/screen
	app-admin/sudo"
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Pod )"

SRC_TEST="do"

RESTRICT="!test? ( test )"

src_prepare() {
	eapply "${FILESDIR}/destroy-xen-shell-fix.patch"
	eapply_user
	( echo ""; echo "# set default shell"; echo "shell /usr/bin/xen-shell" ) >> "${S}"/misc/_screenrc

	sed -i -e 's/\*-\*/xen-shell/' "${S}/Makefile"
	sed -i -e 's;sudo xm;sudo xl;g' -e 's;"xm;"xl;' "${S}/bin/xen-shell"
}

src_compile() {
	emake makemanpages || die "makemanpages failed"
}

src_install() {
	dobin bin/xm-reimage bin/xen-login-shell bin/xen-shell

	insinto /etc/xen-shell
	doins misc/_screenrc misc/xen-shell.conf

	dobashcomp misc/xen-shell

	newman man/xen-shell.man xen-shell.1
}

pkg_postinst() {
	einfo "Updating ${ROOT}/etc/shells"
	( grep -v -e "^/usr/bin/xen-\(login-\)\?shell$" "${ROOT}"/etc/shells; echo "/usr/bin/xen-login-shell"; echo "/usr/bin/xen-shell" ) > "${T}"/shells
	mv -f "${T}"/shells "${ROOT}"/etc/shells

	elog ""
	elog " To use xen-shell, set /usr/bin/xen-login-shell as users login shell"
	elog ""
	elog " You'll also need to ensure that xen-shell users have the ability"
	elog " to run \"xl\" as root with no password, via sudo (in /etc/sudoers):"
	elog ""
	elog "   <xen-shell-user-name>     ALL      = NOPASSWD: /usr/sbin/xl"
	elog ""
	elog " See man page for further configuration"
	elog ""
}
