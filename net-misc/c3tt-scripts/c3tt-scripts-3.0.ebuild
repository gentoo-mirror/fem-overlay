# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="scripts for running clients of the c3tickettracker"
HOMEPAGE="https://repository.fem.tu-ilmenau.de/trac/c3tt/"
#SRC_URI="http://subversion.fem.tu-ilmenau.de/repository/cccongress/"i
inherit subversion

ESVN_REPO_URI="http://subversion.fem.tu-ilmenau.de/repository/cccongress/trunk/tools/tracker3.0/"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-perl/DateTime
	dev-perl/DateTime-Format-SQLite
	dev-perl/File-Which
	dev-perl/JSON
	dev-perl/Math-Round
	dev-perl/Proc-ProcessTable
	dev-perl/REST-Client
	dev-perl/XML-RPC-Fast
	dev-perl/XML-Simple
	dev-perl/boolean
	dev-perl/rename
	media-video/ffmpeg
	"
RDEPEND="${DEPEND}"

src_install() {
	dodir /opt/crs/software/tools/
	cp -R "${S}/" "${D}/opt/crs/software/tools/tracker3.0/" || die "Install failed!"
}
