# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_URI="pear.docblox-project.org"
PHP_PEAR_PN="DocBlox"
inherit php-pear-r1

DESCRIPTION="Documentation Generation Application (DGA) for use with PHP applications"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

SRC_URI="http://pear.docblox-project.org/get/${PHP_PEAR_PN}-${PV}.tgz"

DEPEND=">=dev-php/pear-1.9.4"
RDEPEND="${DEPEND}
dev-php/PEAR-DocBlox_Template_new_black"
