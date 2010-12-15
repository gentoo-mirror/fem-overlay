# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php5/pecl-memcache/pecl-memcache-2.2.5.ebuild,v 1.8 2010/02/07 15:57:39 armin76 Exp $

EAPI="2"
PHP_EXT_NAME="memcache"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README"

inherit php-ext-pecl-r2 php-ext-base-r1 depend.php

KEYWORDS="amd64 hppa ppc ppc64 sparc x86"

DESCRIPTION="PHP extension for using memcached."
LICENSE="PHP-3"
SLOT="0"
IUSE="+session"

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

# upstream does not ship any testsuite, so the PHPize test-runner fails.
RESTRICT='test'

need_php_by_category

pkg_setup() {
	use session && require_php_with_use session
}

src_compile() {
	my_conf="--enable-memcache --with-zlib-dir=/usr $(use_enable session memcache-session)"
	php-ext-pecl-r2_src_compile
}

src_install() {
	php-ext-pecl-r2_src_install

	php-ext-source-r2_addtoinifiles "memcache.allow_failover" "true"
	php-ext-source-r2_addtoinifiles "memcache.max_failover_attempts" "20"
	php-ext-source-r2_addtoinifiles "memcache.chunk_size" "32768"
	php-ext-source-r2_addtoinifiles "memcache.default_port" "11211"
	php-ext-source-r2_addtoinifiles "memcache.hash_strategy" "standard"
	php-ext-source-r2_addtoinifiles "memcache.hash_function" "crc32"
}
