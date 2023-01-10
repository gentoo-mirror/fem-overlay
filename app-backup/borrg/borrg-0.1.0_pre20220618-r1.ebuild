# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Auto-Generated by cargo-ebuild 0.5.2

EAPI=8

CRATES="
	aho-corasick-0.7.18
	atty-0.2.14
	autocfg-1.1.0
	bitflags-1.3.2
	cfg-if-1.0.0
	chrono-0.4.19
	clap-3.1.6
	clap_derive-3.1.4
	console-0.15.0
	dirs-4.0.0
	dirs-sys-0.3.6
	encode_unicode-0.3.6
	env_logger-0.9.0
	getrandom-0.2.5
	hashbrown-0.11.2
	heck-0.4.0
	hermit-abi-0.1.19
	humantime-2.1.0
	indexmap-1.8.0
	indicatif-0.17.0-rc.10
	itoa-1.0.1
	lazy_static-1.4.0
	libc-0.2.119
	log-0.4.14
	memchr-2.4.1
	num-integer-0.1.44
	num-traits-0.2.14
	number_prefix-0.4.0
	once_cell-1.10.0
	os_str_bytes-6.0.0
	proc-macro-error-1.0.4
	proc-macro-error-attr-1.0.4
	proc-macro2-1.0.36
	quote-1.0.15
	redox_syscall-0.2.11
	redox_users-0.4.0
	regex-1.5.5
	regex-syntax-0.6.25
	ryu-1.0.9
	serde-1.0.136
	serde_json-1.0.79
	strsim-0.10.0
	syn-1.0.86
	termcolor-1.1.3
	terminal_size-0.1.17
	textwrap-0.15.0
	time-0.1.44
	toml-0.5.8
	unicode-width-0.1.9
	unicode-xid-0.2.2
	version_check-0.9.4
	wasi-0.10.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-util-0.1.5
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo

BORRG_COMMIT="2b85f68ad9c438b1804286935eec50a4ce6ccccf"

DESCRIPTION="Wrapper for borgbackup"
HOMEPAGE="https://github.com/SebastianSpeitel/borrg"
SRC_URI="
	https://github.com/SebastianSpeitel/borrg/archive/${BORRG_COMMIT}.tar.gz -> ${P}.gh.tar.gz
	$(cargo_crate_uris)
"

LICENSE="Apache-2.0 Apache-2.0-with-LLVM-exceptions Boost-1.0 MIT Unlicense"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	<app-backup/borgbackup-2
"

S="${WORKDIR}/${PN}-${BORRG_COMMIT}"

DOCS=( "readme.md" )

# Rust doesn't respect CFLAGS
QA_FLAGS_IGNORED="*"

src_install() {
	cargo_src_install
	einstalldocs
}
