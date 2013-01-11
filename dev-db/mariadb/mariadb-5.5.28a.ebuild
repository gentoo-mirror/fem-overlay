# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/mariadb/mariadb-5.5.28.ebuild,v 1.2 2012/12/18 17:51:01 jer Exp $

EAPI="4"
# MY_EXTRAS_VER="20120906-1344Z"
MY_EXTRAS_VER="none"

# Build system
BUILD="cmake"

inherit toolchain-funcs mysql-v2
# only to make repoman happy. it is really set in the eclass
IUSE="$IUSE galera"

# REMEMBER: also update eclass/mysql*.eclass before committing!
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"

# When MY_EXTRAS is bumped, the index should be revised to exclude these.
EPATCH_EXCLUDE=''

DEPEND="|| ( >=sys-devel/gcc-3.4.6 >=sys-devel/gcc-apple-4.0 )"
RDEPEND="${RDEPEND}"

SRC_URI="http://mirror3.layerjet.com/mariadb/mariadb-galera-${PV}/kvm-tarbake-jaunty-x86/mariadb-${PV}.tar.gz"

# Please do not add a naive src_unpack to this ebuild
# If you want to add a single patch, copy the ebuild to an overlay
# and create your own mysql-extras tarball, looking at 000_index.txt
src_prepare() {
#	sed -i \
#		-e '/^noinst_PROGRAMS/s/basic-t//g' \
#		"${S}"/unittest/mytap/t/Makefile.am
	mysql-v2_src_prepare
}

mysql-cmake_src_prepare() {
	einfo ""
}

# @FUNCTION: configure_cmake_standard
# @DESCRIPTION:
# Helper function to configure standard build
configure_cmake_standard() {

	mycmakeargs+=(
		-DENABLED_LOCAL_INFILE=1
		-DEXTRA_CHARSETS=all
		-DMYSQL_USER=mysql
		-DMYSQL_UNIX_ADDR=${EPREFIX}/var/run/mysqld/mysqld.sock
		-DWITHOUT_READLINE=1
		-DWITH_ZLIB=system
		-DWITHOUT_LIBWRAP=1
	)

	mycmakeargs+=(
		$(cmake-utils_use_disable !static SHARED)
		$(cmake-utils_use_with debug)
		$(cmake-utils_use_with embedded EMBEDDED_SERVER)
		$(cmake-utils_use_with profiling)
		$(cmake-utils_use_enable systemtap DTRACE)
	)

	if use galera ; then
		mycmakeargs+=(
			-DWITH_WSREP=ON
			-DWITH_INNODB_DISALLOW_WRITES=1
		)
	fi

	if use ssl; then
		mycmakeargs+=( -DWITH_SSL=system )
	else
		mycmakeargs+=( -DWITH_SSL=0 )
	fi

	if mysql_version_is_at_least "5.5" && use jemalloc; then
		mycmakeargs+=( -DCMAKE_EXE_LINKER_FLAGS='-ljemalloc' -DWITH_SAFEMALLOC=OFF )
	fi

	if mysql_version_is_at_least "5.5" && use tcmalloc; then
		mycmakeargs+=( -DCMAKE_EXE_LINKER_FLAGS='-ltcmalloc' -DWITH_SAFEMALLOC=OFF )
	fi

	# Storage engines
	mycmakeargs+=(
		-DWITH_ARCHIVE_STORAGE_ENGINE=1
		-DWITH_BLACKHOLE_STORAGE_ENGINE=1
		-DWITH_CSV_STORAGE_ENGINE=1
		-DWITH_HEAP_STORAGE_ENGINE=1
		-DWITH_INNOBASE_STORAGE_ENGINE=1
		-DWITH_MYISAMMRG_STORAGE_ENGINE=1
		-DWITH_MYISAM_STORAGE_ENGINE=1
		-DWITH_PARTITION_STORAGE_ENGINE=1
		$(cmake-utils_use_with extraengine FEDERATED_STORAGE_ENGINE)
	)

	if pbxt_available ; then
		mycmakeargs+=( $(cmake-utils_use_with pbxt PBXT_STORAGE_ENGINE) )
	fi

	if [ "${PN}" == "mariadb" ]; then
		mycmakeargs+=(
			$(cmake-utils_use_with oqgraph OQGRAPH_STORAGE_ENGINE)
			$(cmake-utils_use_with sphinx SPHINX_STORAGE_ENGINE)
			$(cmake-utils_use_with extraengine FEDERATEDX_STORAGE_ENGINE)
		)
	fi
}


# Official test instructions:
# USE='berkdb -cluster embedded extraengine perl ssl community' \
# FEATURES='test userpriv -usersandbox' \
# ebuild mariadb-X.X.XX.ebuild \
# digest clean package
src_test() {

	local TESTDIR="${CMAKE_BUILD_DIR}/mysql-test"
	local retstatus_unit
	local retstatus_tests

	# Bug #213475 - MySQL _will_ object strenously if your machine is named
	# localhost. Also causes weird failures.
	[[ "${HOSTNAME}" == "localhost" ]] && die "Your machine must NOT be named localhost"

	if ! use "minimal" ; then

		if [[ $UID -eq 0 ]]; then
			die "Testing with FEATURES=-userpriv is no longer supported by upstream. Tests MUST be run as non-root."
		fi
		has usersandbox $FEATURES && eerror "Some tests may fail with FEATURES=usersandbox"

		einfo ">>> Test phase [test]: ${CATEGORY}/${PF}"
		addpredict /this-dir-does-not-exist/t9.MYI

		# Run CTest (test-units)
		cmake-utils_src_test
		retstatus_unit=$?
		[[ $retstatus_unit -eq 0 ]] || eerror "test-unit failed"

		# Ensure that parallel runs don't die
		export MTR_BUILD_THREAD="$((${RANDOM} % 100))"

		# create directories because mysqladmin might right out of order
		mkdir -p "${S}"/mysql-test/var-{tests}{,/log}

		# These are failing in MySQL 5.5 for now and are believed to be
		# false positives:
		#
		# main.information_schema, binlog.binlog_statement_insert_delayed,
		# main.mysqld--help, funcs_1.is_triggers, funcs_1.is_tables_mysql,
		# funcs_1.is_columns_mysql
		# fails due to USE=-latin1 / utf8 default
		#
		# main.mysql_client_test, main.mysql_client_test_nonblock:
		# segfaults at random under Portage only, suspect resource limits.
		#
		# sys_vars.plugin_dir_basic
		# fails because PLUGIN_DIR is set to MYSQL_LIBDIR64/plugin
		# instead of MYSQL_LIBDIR/plugin
		#
		# main.flush_read_lock_kill
		# fails because of unknown system variable 'DEBUG_SYNC'
		#
		# main.openssl_1
		# error message changing
		# -mysqltest: Could not open connection 'default': 2026 SSL connection
		#  error: ASN: bad other signature confirmation
		# +mysqltest: Could not open connection 'default': 2026 SSL connection
		#  error: error:00000001:lib(0):func(0):reason(1)
		#
		# plugins.unix_socket
		# fails because portage strips out the USER enviornment variable
		#

		for t in main.mysql_client_test main.mysql_client_test_nonblock \
			binlog.binlog_statement_insert_delayed main.information_schema \
			main.mysqld--help main.flush_read_lock_kill \
			sys_vars.plugin_dir_basic main.openssl_1 plugins.unix_socket \
			funcs_1.is_triggers funcs_1.is_tables_mysql funcs_1.is_columns_mysql ; do
				mysql-v2_disable_test  "$t" "False positives in Gentoo"
		done

		# Run mysql tests
		pushd "${TESTDIR}"

		# run mysql-test tests
		perl mysql-test-run.pl --force --vardir="${S}/mysql-test/var-tests"
		retstatus_tests=$?
		[[ $retstatus_tests -eq 0 ]] || eerror "tests failed"
		has usersandbox $FEATURES && eerror "Some tests may fail with FEATURES=usersandbox"

		popd

		# Cleanup is important for these testcases.
		pkill -9 -f "${S}/ndb" 2>/dev/null
		pkill -9 -f "${S}/sql" 2>/dev/null

		failures=""
		[[ $retstatus_unit -eq 0 ]] || failures="${failures} test-unit"
		[[ $retstatus_tests -eq 0 ]] || failures="${failures} tests"
		has usersandbox $FEATURES && eerror "Some tests may fail with FEATURES=usersandbox"

		[[ -z "$failures" ]] || die "Test failures: $failures"
		einfo "Tests successfully completed"

	else

		einfo "Skipping server tests due to minimal build."
	fi
}
