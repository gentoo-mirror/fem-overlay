# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/tuxonice-sources/tuxonice-sources-3.0.22.ebuild,v 1.1 2012/02/25 12:53:08 pacho Exp $

EAPI="4"

ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="8"

inherit kernel-2 git-2
detect_version
detect_arch

DESCRIPTION="TuxOnIce + Gentoo patchset sources"
HOMEPAGE="http://dev.gentoo.org/~mpagano/genpatches/ http://www.tuxonice.net"
IUSE=""

EGIT_REPO_URI="git://github.com/NigelCunningham/tuxonice-kernel.git
		https://github.com/NigelCunningham/tuxonice-kernel.git"
EGIT_BRANCH="tuxonice-head"

UNIPATCH_STRICTORDER="yes"

KEYWORDS="~amd64 ~x86"

RDEPEND="${RDEPEND}
	>=sys-apps/tuxonice-userui-1.0
	|| ( >=sys-power/hibernate-script-2.0 sys-power/pm-utils )"

K_EXTRAELOG="If there are issues with this kernel, please direct any
queries to the tuxonice-users mailing list:
http://lists.tuxonice.net/mailman/listinfo/tuxonice-users/"
K_SECURITY_UNSUPPORTED="1"

src_unpack() {
	git-2_src_unpack

        debug-print "Doing epatch_user"
        epatch_user

        debug-print "Doing unpack_set_extraversion"

        [[ -z ${K_NOSETEXTRAVERSION} ]] && unpack_set_extraversion
        unpack_fix_install_path
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}
