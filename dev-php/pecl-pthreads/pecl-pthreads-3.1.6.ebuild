# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

USE_PHP="php7-0 php7-1"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Threading API for PHP"
LICENSE="PHP-3.01"
SLOT="7"
IUSE=""

DEPEND="
	php_targets_php7-0? ( dev-lang/php:7.0[threads] )
	php_targets_php7-1? ( dev-lang/php:7.1[threads] )
"
RDEPEND="${DEPEND}"
