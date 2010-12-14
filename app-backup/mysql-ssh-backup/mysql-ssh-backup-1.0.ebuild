EAPI=1

inherit eutils autotools

# mysql-ssh-backup
#
# Create MySQL-Dumps via SSH using RSA or DSA authentication (private key).
# Each database will be dumped as a single file and can be compressed optional.

DESCRIPTION="Create MySQL-Dumps via SSH using RSA or DSA Authentication (private key)."
HOMEPAGE="http://www.fem.tu-ilmenau.de/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86"
IUSE=""

RESTRICT="test"

RDEPEND="net-misc/openssh"
DEPEND="${RDEPEND}"

src_install() {
	newbin ${FILESDIR}/${P} ${PN} || die "Installation failed."
}
