# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/php/php-4.4.8.ebuild,v 1.2 2008/03/23 11:53:04 hollow Exp $

# bug 280029
APACHE_VERSION=2

CGI_SAPI_USE="discard-path force-cgi-redirect"
APACHE2_SAPI_USE="concurrentmodphp threads"
IUSE="cli cgi ${CGI_SAPI_USE} ${APACHE2_SAPI_USE} fastbuild"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"

# NOTE: Portage doesn't support setting PROVIDE based on the USE flags
#		that have been enabled, so we have to PROVIDE everything for now
#		and hope for the best
PROVIDE="virtual/php virtual/httpd-php"

# php package settings
SLOT="4"
MY_PHP_PV="${PV}"
MY_PHP_P="php-${MY_PHP_PV}"
PHP_PACKAGE="1"

# php patch settings, general
PHP_PATCHSET_REV="0"
SUHOSIN_PATCH="suhosin-patch-4.4.8-0.9.6.patch.gz"
MULTILIB_PATCH="${MY_PHP_PV}/opt/php${MY_PHP_PV}-multilib-search-path.patch"
# php patch settings, ebuild specific
FASTBUILD_PATCH="${MY_PHP_PV}/opt/php${MY_PHP_PV}-fastbuild.patch"
CONCURRENTMODPHP_PATCH="${MY_PHP_PV}/opt/php${MY_PHP_PV}-concurrent_apache_modules.patch"

inherit php4_4-sapi apache-module

# Suhosin patch support
[[ -n "${SUHOSIN_PATCH}" ]] && SRC_URI="${SRC_URI} suhosin? ( http://emailhabitat.com/dist/${SUHOSIN_PATCH} )"

# Patchset has moved
SRC_URI="${SRC_URI} http://overlays.gentoo.org/svn/proj/php/patches/php-patches/php-patchset-4.4.9-r0.tar.bz2"

DESCRIPTION="The PHP language runtime engine: CLI, CGI and Apache2 SAPIs."

DEPEND="app-admin/php-toolkit"
RDEPEND="${DEPEND}"

want_apache

pkg_setup() {
	PHPCONFUTILS_AUTO_USE=""

	# Make sure the user has specified at least one SAPI
	einfo "Determining SAPI(s) to build"
	phpconfutils_require_any "  Enabled  SAPI:" "  Disabled SAPI:" cli cgi apache2

	# Threaded Apache2 support
	if use apache2 ; then
		has_apache_threads
	fi

	# Concurrent PHP Apache2 modules support
	if use apache2 ; then
		if use concurrentmodphp ; then
			ewarn
			ewarn "'concurrentmodphp' makes it possible to load multiple, differently"
			ewarn "versioned mod_php's into the same Apache instance. This is done with"
			ewarn "a few linker tricks and workarounds, and is not guaranteed to always"
			ewarn "work correctly, so use it at your own risk. Especially, do not use"
			ewarn "this in conjunction with PHP modules (PECL, ...) other than the ones"
			ewarn "you may find in the Portage tree or the PHP Overlay!"
			ewarn "This is an experimental feature, so please rebuild PHP"
			ewarn "without the 'concurrentmodphp' USE flag if you experience"
			ewarn "any problems, and then reproduce any bugs before filing"
			ewarn "them in Gentoo's Bugzilla or bugs.php.net."
			ewarn "If you have conclusive evidence that a bug directly"
			ewarn "derives from 'concurrentmodphp', please file a bug in"
			ewarn "Gentoo's Bugzilla only."
			ewarn
			ebeep 5
		fi
	fi

	# fastbuild support
	if use fastbuild ; then
		ewarn
		ewarn "'fastbuild' attempts to build all SAPIs in a single pass."
		ewarn "This is an experimental feature, so please rebuild PHP"
		ewarn "without the 'fastbuild' USE flag if you experience"
		ewarn "any problems, and then reproduce any bugs before filing"
		ewarn "them in Gentoo's Bugzilla or bugs.php.net."
		ewarn "If you have conclusive evidence that a bug directly"
		ewarn "derives from 'fastbuild', please file a bug in"
		ewarn "Gentoo's Bugzilla only."
		ewarn
	fi

	php4_4-sapi_pkg_setup
}

php_determine_sapis() {
	# holds the list of sapis that we want to build
	PHPSAPIS=

	if use cli || phpconfutils_usecheck cli ; then
		PHPSAPIS="${PHPSAPIS} cli"
	fi

	if use cgi ; then
		PHPSAPIS="${PHPSAPIS} cgi"
	fi

	# note - apache SAPI comes after the simpler cli/cgi sapis
	if use apache2 ; then
		PHPSAPIS="${PHPSAPIS} apache${APACHE_VERSION}"
	fi
}

src_unpack() {
	if [[ "${PHP_PACKAGE}" == 1 ]] ; then
		unpack ${A}
	fi

	cd "${S}"

	# Concurrent PHP Apache2 modules support
	if use apache2 ; then
		if use concurrentmodphp ; then
			if [[ -n "${CONCURRENTMODPHP_PATCH}" ]] && [[ -f "${WORKDIR}/${CONCURRENTMODPHP_PATCH}" ]] ; then
				epatch "${WORKDIR}/${CONCURRENTMODPHP_PATCH}"
			else
				ewarn "There is no concurrent mod_php patch available for this PHP release yet!"
			fi
		fi
	fi

	# fastbuild support
	if use fastbuild ; then
		if [[ -n "${FASTBUILD_PATCH}" ]] && [[ -f "${WORKDIR}/${FASTBUILD_PATCH}" ]] ; then
			epatch "${WORKDIR}/${FASTBUILD_PATCH}"
		else
			ewarn "There is no fastbuild patch available for this PHP release yet!"
		fi
	fi

	# patch the patch to make it compile
	cp ${FILESDIR}/php4-iodbc-config-r1.patch ${WORKDIR}/${MY_PHP_PV}/php4/php4-iodbc-config.patch

	if has_version '>=sys-devel/autoconf-2.64' ; then
		sed -i -r \
			-e 's:^((m4_)?divert)[(]([0-9]*)[)]:\1(600\3):' \
			$(grep -l divert $(find . -name '*.m4') configure.in) || die
	fi

	# Now let the eclass do the rest and regenerate the configure
	php4_4-sapi_src_unpack

	# Fix Makefile.global:test to consider the CGI SAPI if present
	if use cgi ; then
		sed -e "s|test \! -z \"\$(top_builddir)/php-cli\" \&\& test -x \"\$(top_builddir)/php-cli\"|test \! -z \"\$(top_builddir)/php-cli\" \&\& test -x \"\$(top_builddir)/php-cli\" \&\& test \! -z \"\$(top_builddir)/php-cgi\" \&\& test -x \"\$(top_builddir)/php-cgi\"|g" -i Makefile.global
		sed -e "s|TEST_PHP_EXECUTABLE=\"\$(top_builddir)/php-cli\"|TEST_PHP_EXECUTABLE=\"\$(top_builddir)/php-cli\" TEST_PHP_CGI_EXECUTABLE=\"\$(top_builddir)/php-cgi\"|g" -i Makefile.global
	fi
}

src_compile() {
	if use fastbuild && [[ -n "${FASTBUILD_PATCH}" ]] ; then
		src_compile_fastbuild
	else
		src_compile_normal
	fi
}

src_compile_fastbuild() {
	php_determine_sapis

	build_cli=0
	build_cgi=0
	build_apache2=0
	my_conf=""

	for x in ${PHPSAPIS} ; do
		case ${x} in
			cli)
				build_cli=1
				;;
			cgi)
				build_cgi=1
				;;
			apache2)
				build_apache2=1
				;;
		esac
	done

	if [[ ${build_cli} = 1 ]] ; then
		my_conf="${my_conf} --enable-cli"
	else
		my_conf="${my_conf} --disable-cli"
	fi

	if [[ ${build_cgi} = 1 ]] ; then
		my_conf="${my_conf} --enable-cgi --enable-fastcgi"
		phpconfutils_extension_enable "discard-path" "discard-path" 0
		phpconfutils_extension_enable "force-cgi-redirect" "force-cgi-redirect" 0
	else
		my_conf="${my_conf} --disable-cgi"
	fi

	if [[ ${build_apache2} = 1 ]] ; then
		my_conf="${my_conf} --with-apxs2=/usr/sbin/apxs2"

		# Threaded Apache2 support
		if use threads ; then
			my_conf="${my_conf} --enable-experimental-zts"
			ewarn "Enabling ZTS for Apache2 MPM"
		fi

		# Concurrent PHP Apache2 modules support
		if use concurrentmodphp ; then
			append-ldflags "-Wl,--version-script=${FILESDIR}/php4-ldvs"
		fi
	fi

	# Now we know what we are building, build it
	php4_4-sapi_src_compile

	# To keep the separate php.ini files for each SAPI, we change the
	# build-defs.h and recompile

	if [[ ${build_cli} = 1 ]] ; then
		einfo
		einfo "Building CLI SAPI"
		einfo

		sed -e 's|^#define PHP_CONFIG_FILE_PATH.*|#define PHP_CONFIG_FILE_PATH "/etc/php/cli-php4"|g;' -i main/build-defs.h
		sed -e 's|^#define PHP_CONFIG_FILE_SCAN_DIR.*|#define PHP_CONFIG_FILE_SCAN_DIR "/etc/php/cli-php4/ext-active"|g;' -i main/build-defs.h
		for x in main/main.o main/main.lo main/php_ini.o main/php_ini.lo ; do
			[[ -f ${x} ]] && rm -f ${x}
		done
		make sapi/cli/php || die "Unable to make CLI SAPI"
		cp sapi/cli/php php-cli || die "Unable to copy CLI SAPI"
	fi

	if [[ ${build_cgi} = 1 ]] ; then
		einfo
		einfo "Building CGI SAPI"
		einfo

		sed -e 's|^#define PHP_CONFIG_FILE_PATH.*|#define PHP_CONFIG_FILE_PATH "/etc/php/cgi-php4"|g;' -i main/build-defs.h
		sed -e 's|^#define PHP_CONFIG_FILE_SCAN_DIR.*|#define PHP_CONFIG_FILE_SCAN_DIR "/etc/php/cgi-php4/ext-active"|g;' -i main/build-defs.h
		for x in main/main.o main/main.lo main/php_ini.o main/php_ini.lo ; do
			[[ -f ${x} ]] && rm -f ${x}
		done
		make sapi/cgi/php || die "Unable to make CGI SAPI"
		cp sapi/cgi/php php-cgi || die "Unable to copy CGI SAPI"
	fi

	if [[ ${build_apache2} = 1 ]] ; then
		einfo
		einfo "Building apache${APACHE_VERSION} SAPI"
		einfo

		sed -e "s|^#define PHP_CONFIG_FILE_PATH.*|#define PHP_CONFIG_FILE_PATH \"/etc/php/apache${APACHE_VERSION}-php4\"|g;" -i main/build-defs.h
		sed -e "s|^#define PHP_CONFIG_FILE_SCAN_DIR.*|#define PHP_CONFIG_FILE_SCAN_DIR \"/etc/php/apache${APACHE_VERSION}-php4/ext-active\"|g;" -i main/build-defs.h
		for x in main/main.o main/main.lo main/php_ini.o main/php_ini.lo ; do
			[[ -f ${x} ]] && rm -f ${x}
		done
		make || die "Unable to make apache${APACHE_VERSION} SAPI"
	fi
}

src_compile_normal() {
	php_determine_sapis

	CLEAN_REQUIRED=0
	my_conf=""

	# Support the Apache2 extras, they must be set globally for all
	# SAPIs to work correctly, especially for external PHP extensions
	if use apache2 ; then
		# Concurrent PHP Apache2 modules support
		if use concurrentmodphp ; then
			append-ldflags "-Wl,--version-script=${FILESDIR}/php4-ldvs"
		fi
	fi

	for x in ${PHPSAPIS} ; do
		# Support the Apache2 extras, they must be set globally for all
		# SAPIs to work correctly, especially for external PHP extensions
		if use apache2 ; then
			# Threaded Apache2 support
			if use threads ; then
				my_conf="${my_conf} --enable-experimental-zts"
				ewarn "Enabling ZTS for Apache2 MPM"
			fi
		fi

		if [[ "${CLEAN_REQUIRED}" = 1 ]] ; then
			make clean
		fi

		PHPSAPI="${x}"

		case ${x} in
			cli)
				my_conf="${my_conf} --enable-cli --disable-cgi"
				php4_4-sapi_src_compile
				cp sapi/cli/php php-cli || die "Unable to copy CLI SAPI"
				;;
			cgi)
				my_conf="${my_conf} --disable-cli --enable-cgi --enable-fastcgi"
				phpconfutils_extension_enable "discard-path" "discard-path" 0
				phpconfutils_extension_enable "force-cgi-redirect" "force-cgi-redirect" 0
				php4_4-sapi_src_compile
				cp sapi/cgi/php php-cgi || die "Unable to copy CGI SAPI"
				;;
			apache2)
				my_conf="${my_conf} --disable-cli --with-apxs2=/usr/sbin/apxs2"
				php4_4-sapi_src_compile
				;;
		esac

		CLEAN_REQUIRED=1
		my_conf=""
	done
}

src_install() {
	php_determine_sapis

	destdir=/usr/$(get_libdir)/php4

	# Let the eclass do the common work
	php4_4-sapi_src_install

	einfo
	einfo "Installing SAPI(s) ${PHPSAPIS}"
	einfo

	for x in ${PHPSAPIS} ; do

		PHPSAPI="${x}"

		case ${x} in
			cli)
				einfo "Installing CLI SAPI"
				into ${destdir}
				newbin php-cli php || die "Unable to install ${x} sapi"
				php4_4-sapi_install_ini
				;;
			cgi)
				einfo "Installing CGI SAPI"
				into ${destdir}
				dobin php-cgi || die "Unable to install ${x} sapi"
				php4_4-sapi_install_ini
				;;
			apache2)
				einfo "Installing Apache${APACHE_VERSION} SAPI"
				make INSTALL_ROOT="${D}" install-sapi || die "Unable to install ${x} SAPI"
				if use concurrentmodphp ; then
					einfo "Installing Apache${APACHE_VERSION} config file for PHP4-concurrent (70_mod_php_concurr.conf)"
					insinto ${APACHE_MODULES_CONFDIR}
					newins "${FILESDIR}/70_mod_php_concurr.conf-apache2" "70_mod_php_concurr.conf"

					# Put the ld version script in the right place so it's always accessible
					insinto "/var/lib/php-pkg/${CATEGORY}/${PN}-${PVR}/"
					doins "${FILESDIR}/php4-ldvs"

					# Redefine the extension dir to have the modphp suffix
					PHPEXTDIR="`"${D}/${destdir}/bin/php-config" --extension-dir`-versioned"
				else
					einfo "Installing Apache${APACHE_VERSION} config file for PHP4 (70_mod_php.conf)"
					insinto ${APACHE_MODULES_CONFDIR}
					newins "${FILESDIR}/70_mod_php.conf-apache2" "70_mod_php.conf"
				fi
				php4_4-sapi_install_ini
				;;
		esac
	done

	# Install env.d files
	newenvd "${FILESDIR}/20php4-envd" "20php4"
	sed -e "s|/lib/|/$(get_libdir)/|g" -i "${D}/etc/env.d/20php4"
}

pkg_postinst() {
	# Output some general info to the user
	if use apache2 ; then
		APACHE2_MOD_DEFINE="PHP4"
		if use concurrentmodphp ; then
			APACHE2_MOD_CONF="70_mod_php_concurr"
		else
			APACHE2_MOD_CONF="70_mod_php"
		fi
		apache-module_pkg_postinst
	fi

	# Update Apache2 to use mod_php
	if use apache2 ; then
		"${ROOT}/usr/sbin/php-select" -t apache2 php4 > /dev/null 2>&1
		exitStatus=$?
		if [[ ${exitStatus} == 2 ]] ; then
			php-select apache2 php4
		elif [[ ${exitStatus} == 4 ]] ; then
			ewarn
			ewarn "Apache2 is configured to load a different version of PHP."
			ewarn "To make Apache2 use PHP v4, use php-select:"
			ewarn
			ewarn "    php-select apache2 php4"
			ewarn
		fi
	fi

	# Create the symlinks for php-cli
	if use cli || phpconfutils_usecheck cli ; then
		"${ROOT}/usr/sbin/php-select" -t php php4 > /dev/null 2>&1
		exitStatus=$?
		if [[ ${exitStatus} == 5 ]] ; then
			php-select php php4
		elif [[ ${exitStatus} == 4 ]] ; then
			ewarn
			ewarn "/usr/bin/php links to a different version of PHP."
			ewarn "To make /usr/bin/php point to PHP v4, use php-select:"
			ewarn
			ewarn "    php-select php php4"
			ewarn
		fi
	fi

	# Create the symlinks for php-cgi
	if use cgi ; then
		"${ROOT}/usr/sbin/php-select" -t php-cgi php4 > /dev/null 2>&1
		exitStatus=$?
		if [[ ${exitStatus} == 5 ]] ; then
			php-select php-cgi php4
		elif [[ ${exitStatus} == 4 ]] ; then
			ewarn
			ewarn "/usr/bin/php-cgi links to a different version of PHP."
			ewarn "To make /usr/bin/php-cgi point to PHP v4, use php-select:"
			ewarn
			ewarn "    php-select php-cgi php4"
			ewarn
		fi
	fi

	# Create the symlinks for php-devel
	"${ROOT}/usr/sbin/php-select" -t php-devel php4 > /dev/null 2>&1
	exitStatus=$?
	if [[ $exitStatus == 5 ]] ; then
		php-select php-devel php4
	elif [[ $exitStatus == 4 ]] ; then
		ewarn
		ewarn "/usr/bin/php-config and/or /usr/bin/phpize are linked to a"
		ewarn "different version of PHP. To make them point to PHP v4, use"
		ewarn "php-select:"
		ewarn
		ewarn "    php-select php-devel php4"
		ewarn
	fi

	php4_4-sapi_pkg_postinst
}

src_test() {
	einfo ">>> Test phase [test]: ${CATEGORY}/${PF}"
	if ! emake -j1 test ; then
		hasq test ${FEATURES} && die "Make test failed. See above for details."
		hasq test ${FEATURES} || eerror "Make test failed. See above for details."
	fi
}
