# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit php-pear-lib-r1

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Mock Object library for PHPUnit"
HOMEPAGE="http://www.phpunit.de/"
SRC_URI="http://pear.phpunit.de/get/PHPUnit_MockObject-${PV}.tgz"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=">=dev-php/PEAR-PEAR-1.9.1"
RDEPEND="${DEPEND}
	>=dev-php/Text_Template-1.1.1"

need_php_by_category

S="${WORKDIR}/PHPUnit_MockObject-${PV}"
