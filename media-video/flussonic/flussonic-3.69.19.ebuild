# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

if [ "${PV#9999}" != "${PV}" ] ; then
	EGIT_REPO_URI="https://github.com/iSchluff/flussonic-old.git"
	SCM="git-r3"
else
	SRC_URI="https://github.com/iSchluff/flussonic-old/archive/v${PV}.tar.gz"
	SCM=""
fi

inherit ${SCM}

DESCRIPTION="Flussonic (Erlyvideo 3) media streaming server"
HOMEPAGE="https://github.com/iSchluff/flussonic-old"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/erlang"
RDEPEND="${DEPEND}"

S="${WORKDIR}/flussonic-old-${PV}"

src_prepare() {
	eapply_user
	cp "${FILESDIR}/${PN}.initd" "${S}/priv/flussonic"
}
