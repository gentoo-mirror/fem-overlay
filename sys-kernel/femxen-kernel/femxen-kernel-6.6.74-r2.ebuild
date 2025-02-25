# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit kernel-build

MY_P=linux-${PV%.*}
GENPATCHES_P=genpatches-${PV%.*}-$(( ${PV##*.} + 9 ))
# https://koji.fedoraproject.org/koji/packageinfo?packageID=8
CONFIG_VER=6.6.74
GENTOO_CONFIG_VER=g15

DESCRIPTION="Linux kernel built with Gentoo patches"
HOMEPAGE="https://www.kernel.org/"
SRC_URI+="
	https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.base.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.extras.tar.xz
	https://github.com/projg2/gentoo-kernel-config/archive/${GENTOO_CONFIG_VER}.tar.gz
		-> gentoo-kernel-config-${GENTOO_CONFIG_VER}.tar.gz
	https://gitlab.fem-net.de/gentoo/kernel-configs/-/raw/master/kernel-xen-domu-x86_64.config.${CONFIG_VER}
"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
KEYWORDS="~amd64"
IUSE="debug hardened"

BDEPEND="
	debug? ( dev-util/pahole )
"

QA_FLAGS_IGNORED="
	usr/src/linux-.*/scripts/gcc-plugins/.*.so
	usr/src/linux-.*/vmlinux
"

src_prepare() {
	local PATCHES=(
		# meh, genpatches have no directory
		"${WORKDIR}"/*.patch
	)
	default

	local biendian=false

	# prepare the default config
	case ${ARCH} in
		amd64)
			cp "${DISTDIR}/kernel-xen-domu-x86_64.config.${CONFIG_VER}" .config || die
			;;
		*)
			die "Unsupported arch ${ARCH}"
			;;
	esac
	local myversion="-femxen"
	use hardened && myversion+="-hardened"
	echo "CONFIG_LOCALVERSION=\"${myversion}\"" > "${T}"/version.config || die
	local dist_conf_path="${WORKDIR}/gentoo-kernel-config-${GENTOO_CONFIG_VER}"

	local merge_configs=(
		"${T}"/version.config
		"${dist_conf_path}"/base.config
	)
	use debug || merge_configs+=(
		"${dist_conf_path}"/no-debug.config
	)
	if use hardened; then
		merge_configs+=( "${dist_conf_path}"/hardened-base.config )

		tc-is-gcc && merge_configs+=( "${dist_conf_path}"/hardened-gcc-plugins.config )

		if [[ -f "${dist_conf_path}/hardened-${ARCH}.config" ]]; then
			merge_configs+=( "${dist_conf_path}/hardened-${ARCH}.config" )
		fi
	fi

	kernel-build_merge_configs "${merge_configs[@]}"
}
