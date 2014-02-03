# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_URI="pear.phpunit.de"
PHP_PEAR_PN="Version"

inherit php-pear-lib-r1

HOMEPAGE="https://github.com/sebastianbergmann/version"
DESCRIPTION="Library that helps with managing the version number of Git-hosted PHP projects"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
