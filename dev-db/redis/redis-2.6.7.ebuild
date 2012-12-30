# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/redis/redis-2.4.8.ebuild,v 1.1 2012/03/02 08:57:11 djc Exp $

EAPI="4"

inherit eutils flag-o-matic git-2

DESCRIPTION="Redis is an open source, advanced key-value store. It is often
referred to as a data structure server since keys can contain strings, hashes,
lists, sets and sorted sets."

HOMEPAGE="http://redis.io/"
EGIT_REPO_URI="https://github.com/antirez/redis"
EGIT_MASTER="unstable"
EGIT_BRANCH="2.6"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~x86-macos ~x86-solaris"
IUSE="+jemalloc test"
SLOT="0"

RDEPEND=""
DEPEND=">=sys-devel/autoconf-2.63
	jemalloc? ( dev-libs/jemalloc )
	test? ( dev-lang/tcl )
	${RDEPEND}"

S="${WORKDIR}/${PN}-${PV/_/-}"

REDIS_PIDDIR=/var/run/redis
REDIS_PIDFILE=${REDIS_PIDDIR}/redis.pid
REDIS_DATAPATH=/var/lib/redis
REDIS_LOGPATH=/var/log/redis
REDIS_LOGFILE=${REDIS_LOGPATH}/redis.log

pkg_setup() {
	enewgroup redis 75
	enewuser redis 75 -1 ${REDIS_DATAPATH} redis
	if use jemalloc ; then
		export EXTRA_EMAKE="${EXTRA_EMAKE} MALLOC=jemalloc"
	else
		export EXTRA_EMAKE="${EXTRA_EMAKE} MALLOC=libc"
	fi
}

src_compile() {
	append-ldflags $(no-as-needed)
	emake
}
src_prepare() {
	for MKF in $(find -name 'Makefile' | cut -b 3-); do
		sed -i -e 's:ARCH:TARCH:g' \
			"${MKF}" \
		|| die "Sed failed for ${MKF}"
	done
}

src_test() {
	vecho ">>> Test phase [test]: ${CATEGORY}/${PF}"
	if ! emake test; then
		hasq test $FEATURES && die "Make test failed. See above for details."
		hasq test $FEATURES || eerror "Make test failed. See above for details."
	fi
}

src_install() {
	# configuration file rewrites
	insinto /etc/
	sed -r \
		-e "/^pidfile\>/s,/var.*,${REDIS_PIDFILE}," \
		-e '/^daemonize\>/s,no,yes,' \
		-e '/^# bind/s,^# ,,' \
		-e '/^# maxmemory\>/s,^# ,,' \
		-e '/^maxmemory\>/s,<bytes>,67108864,' \
		-e "/^dbfilename\>/s,dump.rdb,${REDIS_DATAPATH}/dump.rdb," \
		-e "/^dir\>/s, .*, ${REDIS_DATAPATH}/," \
		<redis.conf \
		>redis.conf.gentoo
	newins redis.conf.gentoo redis.conf
	use prefix || fowners redis:redis /etc/redis.conf
	fperms 0644 /etc/redis.conf

	newconfd "${FILESDIR}/redis.confd" redis
	newinitd "${FILESDIR}/redis.initd" redis

	nonfatal dodoc 00-RELEASENOTES BUGS CONTRIBUTING README TODO

	dobin src/redis-cli
	dosbin src/redis-benchmark src/redis-server src/redis-check-aof src/redis-check-dump
	fperms 0750 /usr/sbin/redis-benchmark

	if use prefix; then
	        diropts -m0750
	else
	        diropts -m0750 -o redis -g redis
	fi
	keepdir ${REDIS_DATAPATH} ${REDIS_LOGPATH}
}
