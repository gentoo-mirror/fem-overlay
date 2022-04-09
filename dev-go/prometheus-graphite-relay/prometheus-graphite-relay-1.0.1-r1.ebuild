# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit go-module

EGO_SUM=(
	"github.com/beorn7/perks v0.0.0-20180321164747-3a771d992973 h1:xJ4a3vCFaGF/jqvzLMYoU8P317H5OQ+Via4RmuPwCS0="
	"github.com/beorn7/perks v0.0.0-20180321164747-3a771d992973/go.mod h1:Dwedo/Wpr24TaqPxmxbtue+5NUziq4I4S80YR8gNf3Q="
	"github.com/golang/protobuf v1.2.0 h1:P3YflyNX/ehuJFLhxviNdFxQPkGK5cDcApsge1SqnvM="
	"github.com/golang/protobuf v1.2.0/go.mod h1:6lQm79b+lXiMfvg/cZm0SGofjICqVBUtrP5yJMmIC1U="
	"github.com/kylelemons/godebug v1.1.0 h1:RPNrshWIDI6G2gRW9EHilWtl7Z6Sb1BR0xunSBf0SNc="
	"github.com/kylelemons/godebug v1.1.0/go.mod h1:9/0rRGxNHcop5bhtWyNeEfOS8JIWk580+fNqagV/RAw="
	"github.com/matttproud/golang_protobuf_extensions v1.0.1 h1:4hp9jkHxhMHkqkrB3Ix0jegS5sx/RkqARlsWZ6pIwiU="
	"github.com/matttproud/golang_protobuf_extensions v1.0.1/go.mod h1:D8He9yQNgCq6Z5Ld7szi9bcBfOoFv/3dc6xSMkL2PC0="
	"github.com/naoina/go-stringutil v0.1.0 h1:rCUeRUHjBjGTSHl0VC00jUPLz8/F9dDzYI70Hzifhks="
	"github.com/naoina/go-stringutil v0.1.0/go.mod h1:XJ2SJL9jCtBh+P9q5btrd/Ylo8XwT/h1USek5+NqSA0="
	"github.com/naoina/toml v0.1.1 h1:PT/lllxVVN0gzzSqSlHEmP8MJB4MY2U7STGxiouV4X8="
	"github.com/naoina/toml v0.1.1/go.mod h1:NBIhNtsFMo3G2szEBne+bO4gS192HuIYRqfvOWb4i1E="
	"github.com/prometheus/client_golang v0.9.2 h1:awm861/B8OKDd2I/6o1dy3ra4BamzKhYOiGItCeZ740="
	"github.com/prometheus/client_golang v0.9.2/go.mod h1:OsXs2jCmiKlQ1lTBmv21f2mNfw4xf/QclQDMrYNZzcM="
	"github.com/prometheus/client_model v0.0.0-20180712105110-5c3871d89910 h1:idejC8f05m9MGOsuEi1ATq9shN03HrxNkD/luQvxCv8="
	"github.com/prometheus/client_model v0.0.0-20180712105110-5c3871d89910/go.mod h1:MbSGuTsp3dbXC40dX6PRTWyKYBIrTGTE9sqQNg2J8bo="
	"github.com/prometheus/common v0.0.0-20181126121408-4724e9255275 h1:PnBWHBf+6L0jOqq0gIVUe6Yk0/QMZ640k6NvkxcBf+8="
	"github.com/prometheus/common v0.0.0-20181126121408-4724e9255275/go.mod h1:daVV7qP5qjZbuso7PdcryaAu0sAZbrN9i7WWcTMWvro="
	"github.com/prometheus/procfs v0.0.0-20181204211112-1dc9a6cbc91a h1:9a8MnZMP0X2nLJdBg+pBmGgkJlSaKC2KaQmTCk1XDtE="
	"github.com/prometheus/procfs v0.0.0-20181204211112-1dc9a6cbc91a/go.mod h1:c3At6R/oaqEKCNdg8wHV1ftS6bRYblBhIjjI8uT2IGk="
	"golang.org/x/net v0.0.0-20181201002055-351d144fa1fc h1:a3CU5tJYVj92DY2LaA1kUkrsqD5/3mLDhx2NcNqyW+0="
	"golang.org/x/net v0.0.0-20181201002055-351d144fa1fc/go.mod h1:mL1N/T3taQHkDXs73rZJwtUhF3w3ftmwwsq0BUmARs4="
	"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f h1:Bl/8QSvNqXvPGPGXa2z5xUTmV7VDcZyvRZ+QQXkXTZQ="
	"golang.org/x/sync v0.0.0-20181108010431-42b317875d0f/go.mod h1:RxMgew5VJxzue5/jJTE5uejpjVlOe/izrB70Jof72aM="
)

go-module_set_globals

DESCRIPTION="Utility to push metrics scraped from prometheus into graphite."
HOMEPAGE="https://gitlab.fem-net.de/monitoring/prometheus-graphite-relay"
SRC_URI="
	https://gitlab.fem-net.de/monitoring/prometheus-graphite-relay/-/archive/v${PV}/prometheus-graphite-relay-v${PV}.tar.bz2
	${EGO_SUM_SRC_URI}
"

LICENSE="ISC MIT BSD Apache-2.0"
SLOT="0"

if [[ ${PV} != *9999 ]]; then
	KEYWORDS="~amd64 ~x86"
fi

IUSE=""

DEPEND=""
RDEPEND="
	acct-user/prometheus-graphite-relay
	acct-group/prometheus-graphite-relay
"
BDEPEND="dev-lang/go"

S="${WORKDIR}/${PN}-v${PV}"

src_compile() {
	ego build -v -work -x
}

src_install() {
	default
	exeinto /usr/bin/
	doexe ${PN}

	insinto /etc/
	newins dist/relay.toml ${PN}.toml

	newinitd dist/relay.initd ${PN}
}
