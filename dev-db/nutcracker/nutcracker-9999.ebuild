# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/redis/redis-2.4.8.ebuild,v 1.1 2012/03/02 08:57:11 djc Exp $

EAPI="4"

inherit eutils flag-o-matic git-2

DESCRIPTION="twemproxy (pronounced two-em-proxy), aka nutcracker is a fast and 
lightweight proxy for memcached and redis protocol. It was primarily built to 
reduce the connection count on the backend caching servers."

HOMEPAGE="https://github.com/twitter/twemproxy"
EGIT_REPO_URI="https://github.com/twitter/twemproxy"
# EGIT_MASTER="unstable"
# EGIT_BRANCH="master"
LICENSE="Apache-2"
KEYWORDS="~amd64 ~x86 ~x86-macos ~x86-solaris"
IUSE=""
SLOT="0"

RDEPEND=""
DEPEND="
	${RDEPEND}"

src_configure() {
	autoreconf -fvi
	econf
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	newconfd "${FILESDIR}/nutcracker.confd" nutcracker
	newinitd "${FILESDIR}/nutcracker.initd" nutcracker
	emake DESTDIR="${D}" install

	insinto /etc/nutcracker
	newins "${WORKDIR}/${PF}/conf/nutcracker.yml" nutcracker.yml

}
