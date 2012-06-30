# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
SLOT="0"
ETYPE="sources"

EGIT_REPO_URI="https://github.com/nicolasff/phpredis.git"
EGIT_PROJECT="phpredis"
EGIT_COMMIT="882c7dc92b981ec31e4e3d53c979c4b2a9ee2696"

DESCRIPTION="The phpredis extension provides an API for communicating with the Redis key-value store."
HOMEPAGE="https://github.com/nicolasff/phpredis"
SRC_URI=""

LICENSE="PHP-3.01"
IUSE=""
KEYWORDS="~amd64 ~x86"

PHP_EXT_NAME="redis"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
PHPSAPILIST="apache2 cgi fpm"

USE_PHP="php5-3"
inherit git-2 php-ext-source-r2 confutils

src_unpack() {
	git-2_src_unpack

	for slot in $(php_get_slots); do
		cp -r "${S}" "${WORKDIR}/${slot}"
	done
}

src_install() {
	php-ext-source-r2_src_install
}