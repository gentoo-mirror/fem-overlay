# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit go-module

EGO_SUM=(
	"github.com/alecthomas/template v0.0.0-20190718012654-fb15b899a751"
	"github.com/alecthomas/template v0.0.0-20190718012654-fb15b899a751/go.mod"
	"github.com/alecthomas/units v0.0.0-20190924025748-f65c72e2690d"
	"github.com/alecthomas/units v0.0.0-20190924025748-f65c72e2690d/go.mod"
	"github.com/aler9/gortsplib v0.0.0-20201125201250-8305ca75f0f3"
	"github.com/aler9/gortsplib v0.0.0-20201125201250-8305ca75f0f3/go.mod"
	"github.com/davecgh/go-spew v1.1.0"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/fsnotify/fsnotify v1.4.9"
	"github.com/fsnotify/fsnotify v1.4.9/go.mod"
	"github.com/kballard/go-shellquote v0.0.0-20180428030007-95032a82bc51"
	"github.com/kballard/go-shellquote v0.0.0-20180428030007-95032a82bc51/go.mod"
	"github.com/notedit/rtmp v0.0.2"
	"github.com/notedit/rtmp v0.0.2/go.mod"
	"github.com/pion/randutil v0.1.0"
	"github.com/pion/randutil v0.1.0/go.mod"
	"github.com/pion/rtcp v1.2.4"
	"github.com/pion/rtcp v1.2.4/go.mod"
	"github.com/pion/rtp v1.6.1"
	"github.com/pion/rtp v1.6.1/go.mod"
	"github.com/pion/sdp/v3 v3.0.2"
	"github.com/pion/sdp/v3 v3.0.2/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.4.0"
	"github.com/stretchr/testify v1.4.0/go.mod"
	"github.com/stretchr/testify v1.6.1"
	"github.com/stretchr/testify v1.6.1/go.mod"
	"golang.org/x/sys v0.0.0-20191005200804-aed5e4c7ecf9"
	"golang.org/x/sys v0.0.0-20191005200804-aed5e4c7ecf9/go.mod"
	"gopkg.in/alecthomas/kingpin.v2 v2.2.6"
	"gopkg.in/alecthomas/kingpin.v2 v2.2.6/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
	"gopkg.in/yaml.v2 v2.2.2"
	"gopkg.in/yaml.v2 v2.2.2/go.mod"
	"gopkg.in/yaml.v2 v2.2.8"
	"gopkg.in/yaml.v2 v2.2.8/go.mod"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c"
	"gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c/go.mod"
)
go-module_set_globals

SRC_URI="
	https://github.com/aler9/rtsp-simple-server/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${EGO_SUM_SRC_URI}"
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
	env GOBIN="${S}/bin" go install ./... || die
}

src_install() {
	einstalldocs
	doinitd "${FILESDIR}/init.d/rtsp-simple-server"
	insinto /etc
	doins rtsp-simple-server.yml
	dobin bin/*
}
