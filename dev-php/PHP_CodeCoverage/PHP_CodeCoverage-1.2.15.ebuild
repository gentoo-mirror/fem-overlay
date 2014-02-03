# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PHP_PEAR_CHANNEL="${FILESDIR}/channel.xml"
PHP_PEAR_URI="pear.phpunit.de"
PHP_PEAR_PN="${PN}"

inherit php-pear-lib-r1

HOMEPAGE="https://github.com/sebastianbergmann/php-code-coverage"
DESCRIPTION="Provides collection, processing, and rendering functionality for PHP code coverage information."

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-php/File_Iterator
	dev-php/PHP_TokenStream
	dev-php/Text_Template"
RDEPEND="${DEPEND}"
