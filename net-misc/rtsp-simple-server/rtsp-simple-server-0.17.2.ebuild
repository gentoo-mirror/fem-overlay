# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit go-module

EGO_SUM=(
	"github.com/alecthomas/template v0.0.0-20190718012654-fb15b899a751"
	"github.com/alecthomas/template v0.0.0-20190718012654-fb15b899a751/go.mod"
	"github.com/alecthomas/units v0.0.0-20190924025748-f65c72e2690d"
	"github.com/alecthomas/units v0.0.0-20190924025748-f65c72e2690d/go.mod"
	"github.com/aler9/gortsplib v0.0.0-20210811100517-d05a92be5f04"
	"github.com/aler9/gortsplib v0.0.0-20210811100517-d05a92be5f04/go.mod"
	"github.com/aler9/rtmp v0.0.0-20210403095203-3be4a5535927"
	"github.com/aler9/rtmp v0.0.0-20210403095203-3be4a5535927/go.mod"
	"github.com/asticode/go-astikit v0.20.0"
	"github.com/asticode/go-astikit v0.20.0/go.mod"
	"github.com/asticode/go-astits v1.9.0"
	"github.com/asticode/go-astits v1.9.0/go.mod"
	"github.com/davecgh/go-spew v1.1.0/go.mod"
	"github.com/davecgh/go-spew v1.1.1"
	"github.com/davecgh/go-spew v1.1.1/go.mod"
	"github.com/fsnotify/fsnotify v1.4.9"
	"github.com/fsnotify/fsnotify v1.4.9/go.mod"
	"github.com/gin-contrib/sse v0.1.0"
	"github.com/gin-contrib/sse v0.1.0/go.mod"
	"github.com/gin-gonic/gin v1.7.2"
	"github.com/gin-gonic/gin v1.7.2/go.mod"
	"github.com/go-playground/assert/v2 v2.0.1"
	"github.com/go-playground/assert/v2 v2.0.1/go.mod"
	"github.com/go-playground/locales v0.13.0"
	"github.com/go-playground/locales v0.13.0/go.mod"
	"github.com/go-playground/universal-translator v0.17.0"
	"github.com/go-playground/universal-translator v0.17.0/go.mod"
	"github.com/go-playground/validator/v10 v10.4.1"
	"github.com/go-playground/validator/v10 v10.4.1/go.mod"
	"github.com/golang/protobuf v1.3.3"
	"github.com/golang/protobuf v1.3.3/go.mod"
	"github.com/google/gofuzz v1.0.0/go.mod"
	"github.com/gookit/color v1.4.2"
	"github.com/gookit/color v1.4.2/go.mod"
	"github.com/icza/bitio v1.0.0"
	"github.com/icza/bitio v1.0.0/go.mod"
	"github.com/icza/mighty v0.0.0-20180919140131-cfd07d671de6"
	"github.com/icza/mighty v0.0.0-20180919140131-cfd07d671de6/go.mod"
	"github.com/json-iterator/go v1.1.9"
	"github.com/json-iterator/go v1.1.9/go.mod"
	"github.com/kballard/go-shellquote v0.0.0-20180428030007-95032a82bc51"
	"github.com/kballard/go-shellquote v0.0.0-20180428030007-95032a82bc51/go.mod"
	"github.com/leodido/go-urn v1.2.0"
	"github.com/leodido/go-urn v1.2.0/go.mod"
	"github.com/mattn/go-isatty v0.0.12"
	"github.com/mattn/go-isatty v0.0.12/go.mod"
	"github.com/modern-go/concurrent v0.0.0-20180228061459-e0a39a4cb421"
	"github.com/modern-go/concurrent v0.0.0-20180228061459-e0a39a4cb421/go.mod"
	"github.com/modern-go/reflect2 v0.0.0-20180701023420-4b7aa43c6742"
	"github.com/modern-go/reflect2 v0.0.0-20180701023420-4b7aa43c6742/go.mod"
	"github.com/pion/randutil v0.1.0"
	"github.com/pion/randutil v0.1.0/go.mod"
	"github.com/pion/rtcp v1.2.4"
	"github.com/pion/rtcp v1.2.4/go.mod"
	"github.com/pion/rtp v1.6.1/go.mod"
	"github.com/pion/rtp v1.6.2"
	"github.com/pion/rtp v1.6.2/go.mod"
	"github.com/pion/sdp/v3 v3.0.2"
	"github.com/pion/sdp/v3 v3.0.2/go.mod"
	"github.com/pkg/profile v1.4.0/go.mod"
	"github.com/pmezard/go-difflib v1.0.0"
	"github.com/pmezard/go-difflib v1.0.0/go.mod"
	"github.com/stretchr/objx v0.1.0/go.mod"
	"github.com/stretchr/testify v1.3.0/go.mod"
	"github.com/stretchr/testify v1.4.0/go.mod"
	"github.com/stretchr/testify v1.6.1"
	"github.com/stretchr/testify v1.6.1/go.mod"
	"github.com/ugorji/go v1.1.7"
	"github.com/ugorji/go v1.1.7/go.mod"
	"github.com/ugorji/go/codec v1.1.7"
	"github.com/ugorji/go/codec v1.1.7/go.mod"
	"github.com/xo/terminfo v0.0.0-20210125001918-ca9a967f8778"
	"github.com/xo/terminfo v0.0.0-20210125001918-ca9a967f8778/go.mod"
	"golang.org/x/crypto v0.0.0-20190308221718-c2843e01d9a2/go.mod"
	"golang.org/x/crypto v0.0.0-20200622213623-75b288015ac9/go.mod"
	"golang.org/x/crypto v0.0.0-20201221181555-eec23a3978ad"
	"golang.org/x/crypto v0.0.0-20201221181555-eec23a3978ad/go.mod"
	"golang.org/x/net v0.0.0-20190404232315-eb5bcb51f2a3/go.mod"
	"golang.org/x/net v0.0.0-20210610132358-84b48f89b13b"
	"golang.org/x/net v0.0.0-20210610132358-84b48f89b13b/go.mod"
	"golang.org/x/sys v0.0.0-20190215142949-d0b11bdaac8a/go.mod"
	"golang.org/x/sys v0.0.0-20190412213103-97732733099d/go.mod"
	"golang.org/x/sys v0.0.0-20191005200804-aed5e4c7ecf9/go.mod"
	"golang.org/x/sys v0.0.0-20191026070338-33540a1f6037/go.mod"
	"golang.org/x/sys v0.0.0-20200116001909-b77594299b42/go.mod"
	"golang.org/x/sys v0.0.0-20201119102817-f84b799fce68/go.mod"
	"golang.org/x/sys v0.0.0-20210330210617-4fbd30eecc44/go.mod"
	"golang.org/x/sys v0.0.0-20210423082822-04245dca01da"
	"golang.org/x/sys v0.0.0-20210423082822-04245dca01da/go.mod"
	"golang.org/x/term v0.0.0-20201117132131-f5c789dd3221/go.mod"
	"golang.org/x/term v0.0.0-20201126162022-7de9c90e9dd1/go.mod"
	"golang.org/x/text v0.3.0/go.mod"
	"golang.org/x/text v0.3.2/go.mod"
	"golang.org/x/text v0.3.6/go.mod"
	"golang.org/x/tools v0.0.0-20180917221912-90fa682c2a6e/go.mod"
	"gopkg.in/alecthomas/kingpin.v2 v2.2.6"
	"gopkg.in/alecthomas/kingpin.v2 v2.2.6/go.mod"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405"
	"gopkg.in/check.v1 v0.0.0-20161208181325-20d25e280405/go.mod"
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

src_test() {
	emake test-internal
}
