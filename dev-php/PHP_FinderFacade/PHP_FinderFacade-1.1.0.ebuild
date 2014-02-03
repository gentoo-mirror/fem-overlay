# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_URI="pear.phpunit.de"
PHP_PEAR_PN="FinderFacade"

inherit php-pear-lib-r1

HOMEPAGE="https://github.com/sebastianbergmann/finder-facade"
DESCRIPTION="Convenience wrapper for Symfony's Finder component."

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-php/PHP_Finder
	dev-php/PHP_fDOMDocument"
RDEPEND="${DEPEND}"