EAPI=1

inherit eutils autotools

DESCRIPTION="Create MySQL- or PostgreSQL-Dumps via SSH using RSA or DSA Authentication (private key)."
HOMEPAGE="http://www.fem.tu-ilmenau.de/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

RESTRICT="test"

RDEPEND="net-misc/openssh"
DEPEND="${RDEPEND}"

src_install() {
	newbin ${FILESDIR}/${P} ${PN} || die "Installation failed."
}

pkg_postinst() {
	einfo "The command line option to select the database type has been altered."
	einfo "Use sql-ssh-config -h for further information!"
}
