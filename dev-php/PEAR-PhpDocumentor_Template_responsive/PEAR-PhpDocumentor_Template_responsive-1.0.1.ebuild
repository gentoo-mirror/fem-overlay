# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_URI="pear.phpdoc.org"
PHP_PEAR_PKG_NAME="phpDocumentor_Template_responsive"

inherit php-pear-r1

DESCRIPTION="Default template for phpDocumentor 2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE=""

SRC_URI="http://pear.phpdoc.org/get/${PHP_PEAR_PKG_NAME}-${PEAR_PV}.tgz"

DEPEND=">=dev-php/pear-1.9.4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${PHP_PEAR_PKG_NAME}-${PV}"