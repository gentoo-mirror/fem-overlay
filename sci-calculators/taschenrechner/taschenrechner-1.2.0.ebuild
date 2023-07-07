# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Autogenerated by pycargoebuild 0.10

EAPI=8

CRATES="
	atty@0.2.14
	autocfg@1.1.0
	bitflags@1.3.2
	cfg-if@1.0.0
	colored@2.0.0
	dirs-sys@0.3.7
	dirs@4.0.0
	getrandom@0.2.8
	hermit-abi@0.1.19
	itoa@1.0.5
	lazy_static@1.4.0
	libc@0.2.146
	num-bigint@0.4.3
	num-complex@0.4.2
	num-integer@0.1.45
	num-iter@0.1.43
	num-rational@0.4.1
	num-traits@0.2.15
	num@0.4.0
	proc-macro2@1.0.51
	quote@1.0.23
	redox_syscall@0.2.16
	redox_users@0.4.3
	ryu@1.0.12
	serde@1.0.152
	serde_derive@1.0.152
	serde_json@1.0.93
	syn@1.0.107
	terminal_size@0.1.17
	termios@0.3.3
	thiserror-impl@1.0.38
	thiserror@1.0.38
	unicode-ident@1.0.6
	wasi@0.11.0+wasi-snapshot-preview1
	winapi-i686-pc-windows-gnu@0.4.0
	winapi-x86_64-pc-windows-gnu@0.4.0
	winapi@0.3.9
"

inherit cargo

DESCRIPTION="A commandline calculator with interactive ASCII art input and accurate results"
HOMEPAGE="https://gitlab.fem-net.de/mabl/calculator-cli/"
SRC_URI="https://gitlab.fem-net.de/mabl/taschenrechner/-/archive/${PV}/${P}.tar.gz
	${CARGO_CRATE_URIS}
"

LICENSE="GPL-3"
# Dependent crate licenses
LICENSE+="
	MIT MPL-2.0 Unicode-DFS-2016
	|| ( Apache-2.0 Boost-1.0 )
"
SLOT="0"
KEYWORDS="~amd64"

QA_FLAGS_IGNORED="/usr/bin/taschenrechner"

src_install() {
	cargo_src_install
	einstalldocs
	dosym taschenrechner /usr/bin/tare
}
