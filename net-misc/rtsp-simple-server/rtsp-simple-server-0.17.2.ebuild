# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GO_FEM_DEP_ARCHIVE_VER=2022-07-09
inherit go-module-fem

SRC_URI="
	https://github.com/aler9/rtsp-simple-server/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${GO_FEM_SRC_URI}"
KEYWORDS="~amd64"

DESCRIPTION="ready-to-use RTSP server and RTSP proxy"
HOMEPAGE="https://github.com/aler9/rtsp-simple-server"
LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	export -n GOCACHE XDG_CACHE_HOME
	env GOBIN="${S}/bin" ego install ./...
}

src_install() {
	einstalldocs
	doinitd "${FILESDIR}/init.d/rtsp-simple-server"
	insinto /etc
	doins rtsp-simple-server.yml
	dobin bin/*
}

src_test() {
	emake test-internal
}
