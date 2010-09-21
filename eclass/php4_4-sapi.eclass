# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/www/viewcvs.gentoo.org/raw_cvs/gentoo-x86/eclass/Attic/php4_4-sapi.eclass,v 1.44 2008/07/07 19:12:30 hoffie Exp $

# ========================================================================
# Based on robbat2's work on the php4 sapi eclass
#
# Author: Stuart Herbert <stuart@gentoo.org>
# Author: Luca Longinotti <chtekk@gentoo.org>
#
# ========================================================================

# @ECLASS: php4_4-sapi.eclass
# @MAINTAINER:
# Gentoo PHP team <php-bugs@gentoo.org>
# @BLURB: Eclass for building different php4 SAPI instances.
# @DESCRIPTION:
# Eclass for building different php4 SAPI instances. Use it for the new-style
# =dev-lang/php-4* ebuilds.


PHPCONFUTILS_MISSING_DEPS="adabas birdstep db2 dbmaker empress empress-bcs esoob frontbase hyperwave-api informix interbase mnogosearch msql oci8 oracle7 pfpro sapdb solid sybase sybase-ct"

WANT_AUTOCONF="latest"
WANT_AUTOMAKE="latest"

inherit flag-o-matic autotools toolchain-funcs libtool eutils phpconfutils php-common-r1

# @ECLASS-VARIABLE: MY_PHP_P
# @DESCRIPTION:
# Set MY_PHP_P in the ebuild as needed to match tarball version.

# @ECLASS-VARIABLE: PHP_PACKAGE
# @DESCRIPTION:
# We only set this variable if we are building a copy of php which can be
# installed as a package in its own.
# Copies of php which are compiled into other packages (e.g. php support
# for the thttpd web server) don't need this variable.
if [[ "${PHP_PACKAGE}" == 1 ]] ; then
	HOMEPAGE="http://www.php.net/"
	LICENSE="PHP-3"
	SRC_URI="http://www.php.net/distributions/${MY_PHP_P}.tar.bz2"
	S="${WORKDIR}/${MY_PHP_P}"
fi

IUSE="adabas bcmath berkdb birdstep bzip2 calendar cdb cjk crypt ctype curl db2 dbase dbmaker dbx debug doc empress empress-bcs esoob exif expat frontbase fdftk filepro firebird flatfile ftp gd gd-external gdbm gmp hyperwave-api iconv imap informix inifile interbase iodbc ipv6 java-internal java-external kerberos ldap libedit mcal mcve memlimit mhash ming mnogosearch msql mssql mysql ncurses nls oci8 oci8-instant-client odbc oracle7 overload pcntl pcre pfpro pic posix postgres readline recode sapdb session sharedext sharedmem snmp sockets solid spell sqlite ssl suhosin sybase sybase-ct sysvipc tokenizer truetype unicode wddx xml xmlrpc xpm xsl yaz zip zlib"

# these USE flags should have the correct dependencies
DEPEND="adabas? ( >=dev-db/unixODBC-1.8.13 )
		berkdb? ( =sys-libs/db-4* )
		birdstep? ( >=dev-db/unixODBC-1.8.13 )
		bzip2? ( app-arch/bzip2 )
		cdb? ( || ( dev-db/cdb dev-db/tinycdb ) )
		cjk? ( !gd? ( !gd-external? ( >=media-libs/jpeg-6b media-libs/libpng sys-libs/zlib ) ) )
		crypt? ( >=dev-libs/libmcrypt-2.4 )
		curl? ( >=net-misc/curl-7.10.5 )
		db2? ( >=dev-db/unixODBC-1.8.13 )
		dbmaker? ( >=dev-db/unixODBC-1.8.13 )
		empress? ( >=dev-db/unixODBC-1.8.13 )
		empress-bcs? ( >=dev-db/unixODBC-1.8.13 )
		esoob? ( >=dev-db/unixODBC-1.8.13 )
		exif? ( !gd? ( !gd-external? ( >=media-libs/jpeg-6b media-libs/libpng sys-libs/zlib ) ) )
		fdftk? ( app-text/fdftk )
		firebird? ( dev-db/firebird )
		gd? ( >=media-libs/jpeg-6b media-libs/libpng sys-libs/zlib )
		gd-external? ( media-libs/gd )
		gdbm? ( >=sys-libs/gdbm-1.8.0 )
		gmp? ( >=dev-libs/gmp-4.1.2 )
		iconv? ( virtual/libiconv )
		imap? ( virtual/imap-c-client )
		iodbc? ( dev-db/libiodbc >=dev-db/unixODBC-1.8.13 )
		java-internal? ( >=virtual/jdk-1.4.2 dev-java/java-config )
		kerberos? ( virtual/krb5 )
		ldap? ( !oci8? ( >=net-nds/openldap-1.2.11 ) )
		libedit? ( || ( sys-freebsd/freebsd-lib dev-libs/libedit ) )
		mcal? ( >=dev-libs/libmcal-0.7-r5 )
		mcve? ( net-libs/libmonetra >=dev-libs/openssl-0.9.7 )
		mhash? ( app-crypt/mhash )
		ming? ( media-libs/ming )
		mssql? ( dev-db/freetds )
		mysql? ( virtual/mysql )
		ncurses? ( sys-libs/ncurses )
		nls? ( sys-devel/gettext )
		oci8-instant-client? ( dev-db/oracle-instantclient-basic )
		odbc? ( >=dev-db/unixODBC-1.8.13 )
		postgres? ( || ( >=dev-db/libpq-7.1 ( app-admin/eselect-postgresql
			>=dev-db/postgresql-base-7.1 ) ) )
		readline? ( sys-libs/readline )
		recode? ( app-text/recode )
		sapdb? ( >=dev-db/unixODBC-1.8.13 )
		sharedmem? ( dev-libs/mm )
		snmp? ( >=net-analyzer/net-snmp-5.2 )
		solid? ( >=dev-db/unixODBC-1.8.13 )
		spell? ( >=app-text/aspell-0.50 )
		ssl? ( >=dev-libs/openssl-0.9.7 )
		sybase? ( dev-db/freetds )
		truetype? ( =media-libs/freetype-2* >=media-libs/t1lib-5.0.0 !gd? ( !gd-external? ( >=media-libs/jpeg-6b media-libs/libpng sys-libs/zlib ) ) )
		xml? ( dev-libs/libxml2 sys-libs/zlib xsl? ( dev-libs/libxslt ) )
		xmlrpc? ( dev-libs/expat virtual/libiconv )
		xpm? ( x11-libs/libXpm >=media-libs/jpeg-6b media-libs/libpng sys-libs/zlib )
		xsl? ( app-text/sablotron dev-libs/expat virtual/libiconv )
		zlib? ( sys-libs/zlib )
		virtual/mta"

# libswf conflicts with ming and should not
# be installed with the new PHP ebuilds
DEPEND="${DEPEND}
		!media-libs/libswf"

# 9libs causes a configure error
DEPEND="${DEPEND}
		!dev-libs/9libs"

# simplistic for now
RDEPEND="${DEPEND}"

# those are only needed at compile-time
DEPEND="${DEPEND}
		>=sys-devel/m4-1.4.3
		>=sys-devel/libtool-1.5.18"

# Additional features
#
# They are in PDEPEND because we need PHP installed first!
PDEPEND="doc? ( app-doc/php-docs )
		java-external? ( dev-php4/php-java-bridge )
		java-internal? ( !dev-php4/php-java-bridge )
		sqlite? ( dev-php4/pecl-sqlite )
		suhosin? ( dev-php4/suhosin )
		yaz? ( dev-php4/pecl-yaz )
		zip? ( dev-php4/pecl-zip )"


# ========================================================================
# php.ini Support
# ========================================================================

PHP_INI_FILE="php.ini"
PHP_INI_UPSTREAM="php.ini-dist"

# ========================================================================

# @ECLASS-VARIABLE: PHP_PATCHSET_REV
# @DESCRIPTION:
# Provides PHP patchsets support.
SRC_URI="${SRC_URI} http://gentoo.longitekk.com/php-patchset-${MY_PHP_PV}-r${PHP_PATCHSET_REV}.tar.bz2"

# @ECLASS-VARIABLE: SUHOSIN_PATCH
# @DESCRIPTION:
# Tarball name for Suhosin patch (see http://www.suhosin.org/).
# This feature will not be available in php if unset.
[[ -n "${SUHOSIN_PATCH}" ]] && SRC_URI="${SRC_URI} suhosin? ( http://gentoo.longitekk.com/${SUHOSIN_PATCH} )"

# ========================================================================

EXPORT_FUNCTIONS pkg_setup src_compile src_install src_unpack pkg_postinst

# ========================================================================
# INTERNAL FUNCTIONS
# ========================================================================

php4_4-sapi_check_use_flags() {
	# Multiple USE dependencies
	phpconfutils_use_depend_any "truetype" "gd" "gd" "gd-external"
	phpconfutils_use_depend_any "cjk" "gd" "gd" "gd-external"
	phpconfutils_use_depend_any "exif" "gd" "gd" "gd-external"

	# Simple USE dependencies
	phpconfutils_use_depend_all "xpm"		"gd"
	phpconfutils_use_depend_all "gd"		"zlib"
	phpconfutils_use_depend_all "xml"		"zlib"
	phpconfutils_use_depend_all "xmlrpc"		"iconv"
	phpconfutils_use_depend_all "xsl"		"iconv"
	phpconfutils_use_depend_all "java-external"	"session"
	phpconfutils_use_depend_all "mcve"		"ssl"
	phpconfutils_use_depend_all "suhosin"		"unicode"
	phpconfutils_use_depend_all "adabas"		"odbc"
	phpconfutils_use_depend_all "birdstep"		"odbc"
	phpconfutils_use_depend_all "dbmaker"		"odbc"
	phpconfutils_use_depend_all "empress-bcs"	"odbc" "empress"
	phpconfutils_use_depend_all "empress"		"odbc"
	phpconfutils_use_depend_all "esoob"		"odbc"
	phpconfutils_use_depend_all "db2"		"odbc"
	phpconfutils_use_depend_all "iodbc"		"odbc"
	phpconfutils_use_depend_all "sapdb"		"odbc"
	phpconfutils_use_depend_all "solid"		"odbc"

	# Direct USE conflicts
	phpconfutils_use_conflict "gd" 			"gd-external"
	phpconfutils_use_conflict "java-external" 	"java-internal"
	phpconfutils_use_conflict "oci8" 		"oci8-instant-client"
	phpconfutils_use_conflict "readline" 		"libedit"
	phpconfutils_use_conflict "recode" 		"mysql" "imap" "yaz"
	phpconfutils_use_conflict "sharedmem" 		"threads"
	phpconfutils_use_conflict "firebird" 		"interbase"

	# IMAP support
	php_check_imap

	# Mail support
	php_check_mta

	# Java support
	php_check_java

	# PostgreSQL support
	php_check_pgsql

	# Oracle support
	php_check_oracle_all

	phpconfutils_warn_about_external_deps

	export PHPCONFUTILS_AUTO_USE="${PHPCONFUTILS_AUTO_USE}"
}

php4_4-sapi_set_php_ini_dir() {
	PHP_INI_DIR="/etc/php/${PHPSAPI}-php4"
	PHP_EXT_INI_DIR="${PHP_INI_DIR}/ext"
	PHP_EXT_INI_DIR_ACTIVE="${PHP_INI_DIR}/ext-active"
}

php4_4-sapi_install_ini() {
	destdir=/usr/$(get_libdir)/php4

	# get the extension dir, if not already defined
	[[ -z "${PHPEXTDIR}" ]] && PHPEXTDIR="`"${D}/${destdir}/bin/php-config" --extension-dir`"

	# work out where we are installing the ini file
	php4_4-sapi_set_php_ini_dir

	cp "${PHP_INI_UPSTREAM}" "${PHP_INI_UPSTREAM}-${PHPSAPI}"
	local phpinisrc="${PHP_INI_UPSTREAM}-${PHPSAPI}"

	# Set the extension dir
	einfo "Setting extension_dir in php.ini"
	sed -e "s|^extension_dir .*$|extension_dir = ${PHPEXTDIR}|g" -i ${phpinisrc}

	# A patch for PHP for security
	einfo "Securing fopen wrappers"
	sed -e 's|^allow_url_fopen .*|allow_url_fopen = Off|g' -i ${phpinisrc}

	# Set the include path to point to where we want to find PEAR packages
	einfo "Setting correct include_path"
	sed -e 's|^;include_path = ".:/php/includes".*|include_path = ".:/usr/share/php4:/usr/share/php"|' -i ${phpinisrc}

	# Add needed MySQL extension charset configuration
	local phpmycnfcharset=""

	if [[ "${PHPSAPI}" == "cli" ]] ; then
		phpmycnfcharset="`php_get_mycnf_charset cli`"
		einfo "MySQL extension charset for 'cli' SAPI is: ${phpmycnfcharset}"
	elif [[ "${PHPSAPI}" == "cgi" ]] ; then
		phpmycnfcharset="`php_get_mycnf_charset cgi-fcgi`"
		einfo "MySQL extension charset for 'cgi' SAPI is: ${phpmycnfcharset}"
	elif [[ "${PHPSAPI}" == "apache2" ]] ; then
		phpmycnfcharset="`php_get_mycnf_charset apache2handler`"
		einfo "MySQL extension charset for 'apache2' SAPI is: ${phpmycnfcharset}"
	else
		einfo "No supported SAPI found for which to get the MySQL charset."
	fi

	if [[ -n "${phpmycnfcharset}" ]] && [[ "${phpmycnfcharset}" != "empty" ]] ; then
		einfo "Setting MySQL extension charset to ${phpmycnfcharset}"
		echo "" >> ${phpinisrc}
		echo "; MySQL extension default connection charset settings" >> ${phpinisrc}
		echo "mysql.connect_charset = ${phpmycnfcharset}" >> ${phpinisrc}
	else
		echo "" >> ${phpinisrc}
		echo "; MySQL extension default connection charset settings" >> ${phpinisrc}
		echo ";mysql.connect_charset = utf8" >> ${phpinisrc}
	fi

	dodir ${PHP_INI_DIR}
	insinto ${PHP_INI_DIR}
	newins ${phpinisrc} ${PHP_INI_FILE}

	dodir ${PHP_EXT_INI_DIR}
	dodir ${PHP_EXT_INI_DIR_ACTIVE}

	# Java needs to insert the correct ini files
	php_install_java_inifile

	# Install any extensions built as shared objects
	if use sharedext ; then
		for x in `ls "${D}/${PHPEXTDIR}/"*.so | sort | sed -e "s|.*java.*||g"` ; do
			inifilename=${x/.so/.ini}
			inifilename=`basename ${inifilename}`
			echo "extension=`basename ${x}`" >> "${D}/${PHP_EXT_INI_DIR}/${inifilename}"
			dosym "${PHP_EXT_INI_DIR}/${inifilename}" "${PHP_EXT_INI_DIR_ACTIVE}/${inifilename}"
		done
	fi
}

# ========================================================================
# EXPORTED FUNCTIONS
# ========================================================================

# @FUNCTION: php4_4-sapi_pkg_setup
# @DESCRIPTION:
# Performs all the USE flag testing and magic before we do anything else.
# This way saves a lot of time.
php4_4-sapi_pkg_setup() {
	php4_4-sapi_check_use_flags
}

# @FUNCTION: php4_4-sapi_src_unpack
# @DESCRIPTION:
# Takes care of unpacking, patching and autotools magic and disables
# interactive tests.

# @VARIABLE: PHP_EXTRA_BRANDING
# @DESCRIPTION:
# This variable allows an ebuild to add additional information like
# snapshot dates to the version line.
php4_4-sapi_src_unpack() {
	cd "${S}"

	[[ -z "${PHP_EXTRA_BRANDING}" ]] && PHP_EXTRA_BRANDING=""

	# Change PHP branding
	PHPPR=${PR/r/}
	sed -e "s|^EXTRA_VERSION=\".*\"|EXTRA_VERSION=\"${PHP_EXTRA_BRANDING}-pl${PHPPR}-gentoo\"|g" -i configure.in || die "Unable to change PHP branding to ${PHP_EXTRA_BRANDING}-pl${PHPPR}-gentoo"

	# multilib-strict support
	if [[ -n "${MULTILIB_PATCH}" ]] && [[ -f "${WORKDIR}/${MULTILIB_PATCH}" ]] ; then
		epatch "${WORKDIR}/${MULTILIB_PATCH}"
	else
		ewarn "There is no multilib-strict patch available for this PHP release yet!"
	fi

	# Apply general PHP4 patches
	if [[ -d "${WORKDIR}/${MY_PHP_PV}/php4" ]] ; then
		EPATCH_SOURCE="${WORKDIR}/${MY_PHP_PV}/php4" EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" epatch
	fi

	# Apply version-specific PHP patches
	if [[ -d "${WORKDIR}/${MY_PHP_PV}/${MY_PHP_PV}" ]] ; then
		EPATCH_SOURCE="${WORKDIR}/${MY_PHP_PV}/${MY_PHP_PV}" EPATCH_SUFFIX="patch" EPATCH_FORCE="yes" epatch
	fi

	# Patch PHP to show Gentoo as the server platform
	sed -e "s/PHP_UNAME=\`uname -a | xargs\`/PHP_UNAME=\`uname -s -n -r -v | xargs\`/g" -i configure.in || die "Failed to fix server platform name"

	# Disable interactive make test
	sed -e 's/'`echo "\!getenv('NO_INTERACTION')"`'/false/g' -i run-tests.php

	# Stop PHP from activating the Apache config, as we will do that ourselves
	for i in configure sapi/apache2filter/config.m4 sapi/apache2handler/config.m4 ; do
		sed -i.orig -e 's,-i -a -n php,-i -n php,g' ${i}
		sed -i.orig -e 's,-i -A -n php,-i -n php,g' ${i}
	done

	# Patch PHP to support heimdal instead of mit-krb5
	if has_version "app-crypt/heimdal" ; then
		sed -e 's|gssapi_krb5|gssapi|g' -i acinclude.m4 || die "Failed to fix heimdal libname"
		sed -e 's|PHP_ADD_LIBRARY(k5crypto, 1, $1)||g' -i acinclude.m4 || die "Failed to fix heimdal crypt library reference"
	fi

	# Patch for PostgreSQL support
	if use postgres ; then
		sed -e 's|include/postgresql|include/postgresql include/postgresql/pgsql|g' -i ext/pgsql/config.m4 || die "Failed to fix PostgreSQL include paths"
	fi

	# Suhosin support
	if use suhosin ; then
		if [[ -n "${SUHOSIN_PATCH}" ]] && [[ -f "${DISTDIR}/${SUHOSIN_PATCH}" ]] ; then
			epatch "${DISTDIR}/${SUHOSIN_PATCH}"
		else
			ewarn "There is no Suhosin patch available for this PHP release yet!"
		fi
	fi

	# We are heavily patching autotools base files (configure.in) because
	# of suhosin etc., so let's regenerate the whole stuff now

	# eaclocal doesn't accept --force, so we try to force re-generation
	# this way
	rm aclocal.m4
	eautoreconf --force -W no-cross
}

# @FUNCTION: php4_4-sapi_src_compile
# @DESCRIPTION:
# Takes care of compiling php according to USE flags set by user (and those automagically
# enabled via phpconfutils eclass if unavoidable).
php4_4-sapi_src_compile() {
	destdir=/usr/$(get_libdir)/php4

	php4_4-sapi_set_php_ini_dir

	cd "${S}"

	phpconfutils_init

	my_conf="${my_conf} --with-config-file-path=${PHP_INI_DIR} --with-config-file-scan-dir=${PHP_EXT_INI_DIR_ACTIVE} --without-pear"

	#				extension		USE flag		shared support?
	phpconfutils_extension_enable	"bcmath"		"bcmath"		1
	phpconfutils_extension_with	"bz2"			"bzip2"			1
	phpconfutils_extension_enable	"calendar"		"calendar"		1
	phpconfutils_extension_disable	"ctype"			"ctype"			0
	phpconfutils_extension_with	"curl"			"curl"			1
	phpconfutils_extension_enable	"dbase"			"dbase"			1
	phpconfutils_extension_with	"dom"			"xml"			0
	phpconfutils_extension_enable	"exif"			"exif"			1
	phpconfutils_extension_with	"fbsql"			"frontbase"		1
	phpconfutils_extension_with	"fdftk"			"fdftk"			1 "/opt/fdftk-6.0"
	phpconfutils_extension_enable	"filepro"		"filepro"		1
	phpconfutils_extension_enable	"ftp"			"ftp"			1
	phpconfutils_extension_with	"gettext"		"nls"			1
	phpconfutils_extension_with	"gmp"			"gmp"			1
	phpconfutils_extension_with	"hwapi"			"hyperwave-api"		1
	phpconfutils_extension_with	"iconv"			"iconv"			0
	phpconfutils_extension_with	"informix"		"informix"		1
	phpconfutils_extension_disable	"ipv6"			"ipv6"			0
	phpconfutils_extension_with	"kerberos"		"kerberos"		0 "/usr"
	phpconfutils_extension_enable	"mbstring"		"unicode"		1
	phpconfutils_extension_with	"mcal"			"mcal"			1 "/usr"
	phpconfutils_extension_with	"mcrypt"		"crypt"			1
	phpconfutils_extension_with	"mcve"			"mcve"			1
	phpconfutils_extension_enable	"memory-limit"		"memlimit"		0
	phpconfutils_extension_with	"mhash"			"mhash"			1
	phpconfutils_extension_with	"ming"			"ming"			1
	phpconfutils_extension_with	"mnogosearch"		"mnogosearch"		1
	phpconfutils_extension_with	"msql"			"msql"			1
	phpconfutils_extension_with	"mssql"			"mssql"			1
	phpconfutils_extension_with	"ncurses"		"ncurses"		1
	phpconfutils_extension_with	"oci8"			"oci8"			1
	phpconfutils_extension_with	"oci8-instant-client"	"oci8-instant-client"	1
	phpconfutils_extension_with	"oracle"		"oracle7"		1
	phpconfutils_extension_with	"openssl"		"ssl"			0
	phpconfutils_extension_with	"openssl-dir"		"ssl"			0 "/usr"
	phpconfutils_extension_disable	"overload"		"overload"		0
	phpconfutils_extension_enable	"pcntl" 		"pcntl" 		1
	phpconfutils_extension_without	"pcre-regex"		"pcre"			0
	phpconfutils_extension_with	"pfpro"			"pfpro"			1
	phpconfutils_extension_with	"pgsql"			"postgres"		1
	phpconfutils_extension_disable	"posix"			"posix"			0
	phpconfutils_extension_with	"pspell"		"spell"			1
	phpconfutils_extension_with	"recode"		"recode"		1
	phpconfutils_extension_enable	"shmop"			"sharedmem"		0
	phpconfutils_extension_with	"snmp"			"snmp"			1
	phpconfutils_extension_enable	"sockets"		"sockets"		1
	phpconfutils_extension_with	"sybase"		"sybase"		1
	phpconfutils_extension_with	"sybase-ct"		"sybase-ct"		1
	phpconfutils_extension_enable	"sysvmsg"		"sysvipc"		1
	phpconfutils_extension_enable	"sysvsem"		"sysvipc"		1
	phpconfutils_extension_enable	"sysvshm"		"sysvipc"		1
	phpconfutils_extension_disable	"tokenizer"		"tokenizer"		0
	phpconfutils_extension_enable	"wddx"			"wddx"			1
	phpconfutils_extension_disable	"xml"			"expat"			0
	phpconfutils_extension_with	"xmlrpc"		"xmlrpc"		1
	phpconfutils_extension_with	"zlib"			"zlib"			1
	phpconfutils_extension_enable	"debug"			"debug"			0

	# DBA support
	if use cdb || use berkdb || use flatfile || use gdbm || use inifile ; then
		my_conf="${my_conf} --enable-dba${shared}"
	fi

	# DBA drivers support
	phpconfutils_extension_with 	"cdb"			"cdb"			0
	phpconfutils_extension_with 	"db4"			"berkdb"		0
	phpconfutils_extension_with 	"flatfile"		"flatfile"		0
	phpconfutils_extension_with 	"gdbm"			"gdbm"			0
	phpconfutils_extension_with 	"inifile"		"inifile"		0

	# DBX support
	phpconfutils_extension_enable	"dbx"			"dbx"			1

	# Support for the GD graphics library
	if use gd-external || phpconfutils_usecheck gd-external ; then
		phpconfutils_extension_with	"freetype-dir"	"truetype"		0 "/usr"
		phpconfutils_extension_with	"t1lib"		"truetype"		0 "/usr"
		phpconfutils_extension_enable	"gd-jis-conv"	"cjk" 			0
		phpconfutils_extension_with 	"gd" 		"gd-external"		1 "/usr"
	else
		phpconfutils_extension_with	"freetype-dir"	"truetype"		0 "/usr"
		phpconfutils_extension_with	"t1lib"		"truetype"		0 "/usr"
		phpconfutils_extension_enable	"gd-jis-conv"	"cjk"			0
		phpconfutils_extension_with	"jpeg-dir"	"gd"			0 "/usr"
		phpconfutils_extension_with 	"png-dir" 	"gd" 			0 "/usr"
		phpconfutils_extension_with 	"xpm-dir" 	"xpm" 			0 "/usr/X11R6"
		# enable gd last, so configure can pick up the previous settings
		phpconfutils_extension_with 	"gd" 		"gd" 			0
	fi

	# Java support
	if use java-internal || phpconfutils_usecheck java-internal ; then
		phpconfutils_extension_with	"java"		"java-internal"		0 "`java-config --jdk-home`"
	fi

	# IMAP support
	if use imap || phpconfutils_usecheck imap ; then
		phpconfutils_extension_with	"imap"		"imap"			1
		phpconfutils_extension_with	"imap-ssl"	"ssl"			0
	fi

	# Interbase support
	if use interbase ; then
		my_conf="${my_conf} --with-interbase=/opt"
	fi

	# Firebird support - see Bug 186791
	if use firebird ; then
		my_conf="${my_conf} --with-interbase=/usr"
	fi

	# LDAP support
	if use ldap || phpconfutils_usecheck ldap ; then
		if use oci8 ; then
			phpconfutils_extension_with	"ldap"		"ldap"		1 "${ORACLE_HOME}"
		else
			phpconfutils_extension_with	"ldap"		"ldap"		1
		fi
	fi

	# MySQL support
	# In PHP4, MySQL is enabled by default, so if no 'mysql' USE flag is set,
	# we must turn it off explicitely
	if use mysql ; then
		phpconfutils_extension_with	"mysql"		"mysql"			1 "/usr"
		phpconfutils_extension_with	"mysql-sock"	"mysql"			0 "/var/run/mysqld/mysqld.sock"
	else
		phpconfutils_extension_without	"mysql"		"mysql"			0
	fi

	# ODBC support
	if use odbc || phpconfutils_usecheck odbc ; then
		phpconfutils_extension_with	"unixODBC"	"odbc"			1 "/usr"

		phpconfutils_extension_with	"adabas"	"adabas"		1
		phpconfutils_extension_with	"birdstep"	"birdstep"		1
		phpconfutils_extension_with	"dbmaker"	"dbmaker"		1
		phpconfutils_extension_with	"empress"	"empress"		1
		if use empress || phpconfutils_usecheck empress ; then
			phpconfutils_extension_with	"empress-bcs"	"empress-bcs"	0
		fi
		phpconfutils_extension_with	"esoob"		"esoob"			1
		phpconfutils_extension_with	"ibm-db2"	"db2"			1
		phpconfutils_extension_with	"iodbc"		"iodbc"			1 "/usr"
		phpconfutils_extension_with	"sapdb"		"sapdb"			1
		phpconfutils_extension_with	"solid"		"solid"			1
	fi

	# readline/libedit support
	# You can use readline or libedit, but you can't use both
	phpconfutils_extension_with		"readline"	"readline"		0
	phpconfutils_extension_with		"libedit"	"libedit"		0

	# Sablotron/XSLT support
	phpconfutils_extension_enable		"xslt"		"xsl"			1
	phpconfutils_extension_with		"xslt-sablot"	"xsl"			1
	if use xml || phpconfutils_usecheck xml ; then
		phpconfutils_extension_with	"dom-xslt"	"xsl"			0 "/usr"
		phpconfutils_extension_with	"dom-exslt"	"xsl"			0 "/usr"
	fi

	# Session support
	if ! use session && ! phpconfutils_usecheck session ; then
		phpconfutils_extension_disable	"session"	"session"		0
	else
		phpconfutils_extension_with	"mm"		"sharedmem"		0
	fi

	# Fix ELF-related problems
	if use pic || phpconfutils_usecheck pic ; then
		einfo "Enabling PIC support"
		my_conf="${my_conf} --with-pic"
	fi

	# Catch CFLAGS problems
	php_check_cflags

	# multilib support
	if [[ $(get_libdir) != lib ]] ; then
		my_conf="--with-libdir=$(get_libdir) ${my_conf}"
	fi

	# Support user-passed configuration parameters
	[[ -z "${EXTRA_ECONF}" ]] && EXTRA_ECONF=""

	# Set the correct compiler for cross-compilation
	tc-export CC

	# We don't use econf, because we need to override all of its settings
	./configure --prefix=${destdir} --host=${CHOST} --mandir=${destdir}/man --infodir=${destdir}/info --sysconfdir=/etc --cache-file=./config.cache ${my_conf} ${EXTRA_ECONF} || die "configure failed"
	emake || die "make failed"
}

# @FUNCTION: php4_4-sapi_src_install
# @DESCRIPTION:
# Takes care of installing php (and its shared extensions if enabled).
php4_4-sapi_src_install() {
	destdir=/usr/$(get_libdir)/php4

	cd "${S}"

	addpredict /usr/share/snmp/mibs/.index

	# Install PHP
	make INSTALL_ROOT="${D}" install-build install-headers install-programs || die "make install failed"

	# Install missing header files
	if use unicode || phpconfutils_usecheck unicode ; then
		dodir ${destdir}/include/php/ext/mbstring
		insinto ${destdir}/include/php/ext/mbstring
		doins ext/mbstring/mbregex/mbregex.h
	fi

	# Get the extension dir, if not already defined
	[[ -z "${PHPEXTDIR}" ]] && PHPEXTDIR="`"${D}/${destdir}/bin/php-config" --extension-dir`"

	# And install the modules to it
	if use sharedext ; then
		for x in `ls "${S}/modules/"*.so | sort | sed -e "s|.*java.*||g"` ; do
			module=`basename ${x}`
			modulename=${module/.so/}
			insinto "${PHPEXTDIR}"
			einfo "Installing PHP ${modulename} extension"
			doins "modules/${module}"
		done
	fi

	# Java module and support needs to be installed
	php_install_java

	# Generate the USE file for PHP
	phpconfutils_generate_usefile

	# Create the directory where we'll put php4-only php scripts
	keepdir /usr/share/php4
}

# @FUNCTION: php4_4-sapi_pkg_postinst
# @DESCRIPTION:
# Provides important information to users after install is finished.
php4_4-sapi_pkg_postinst() {
	ewarn
	ewarn "If you have additional third party PHP extensions (such as"
	ewarn "dev-php4/phpdbg) you may need to recompile them now."
	ewarn "A new way of enabling/disabling PHP extensions was introduced"
	ewarn "with the newer PHP packages releases, so please reemerge any"
	ewarn "PHP extensions you have installed to automatically adapt to"
	ewarn "the new configuration layout."
	if use sharedext ; then
		ewarn "The core PHP extensions are now loaded through external"
		ewarn ".ini files, not anymore using a 'extension=name.so' line"
		ewarn "in the php.ini file. Portage will take care of this by"
		ewarn "creating new, updated config-files, please make sure to"
		ewarn "install those using etc-update or dispatch-conf."
	fi
	ewarn

	if use curl ; then
		ewarn "Please be aware that CURL can allow the bypass of open_basedir restrictions."
		ewarn "This can be a security risk!"
		ewarn
	fi

	ewarn "The 'pic' USE flag was added to newer releases of dev-lang/php."
	ewarn "With PIC enabled, your PHP installation may become slower, but"
	ewarn "PIC is required on Hardened-Gentoo platforms (where the USE flag"
	ewarn "is enabled automatically). You may also need this on other"
	ewarn "configurations where TEXTRELs are disabled, for example when using"
	ewarn "certain PaX options in the kernel."
	ewarn

	ewarn "The Ovrimos extension was recently removed and has no available"
	ewarn "substitute, our ebuilds reflect this."
	ewarn "The configure option --enable-gd-native-ttf (enabled by the"
	ewarn "'truetype' USE flag) was removed at upstreams request,"
	ewarn "as it's considered old and broken."
	ewarn "Hardened-PHP was also removed from the PHP 4.4 ebuilds in"
	ewarn "favour of its successor Suhosin, enable the 'suhosin' USE"
	ewarn "flag to install it."
	ewarn

	ewarn "The 'xml' and 'xml2' USE flags were unified in only the 'xml' USE"
	ewarn "flag. To get the features that were once controlled by the 'xml2'"
	ewarn "USE flag, turn the 'xml' USE flag on. To get the features that were"
	ewarn "once controlled by the 'xml' USE flag, turn the 'expat' USE flag on."
	ewarn
}
