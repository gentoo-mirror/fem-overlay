# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_URI="pear.symfony.com"
PHP_PEAR_PN="Console"

inherit php-pear-lib-r1

HOMEPAGE="http://symfony.com/doc/current/components/console/introduction.html"
DESCRIPTION="The Console component eases the creation of beautiful and testable command line interfaces."

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
