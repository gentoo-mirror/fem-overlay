# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
DISTUTILS_OPTIONAL=1
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1 meson

DESCRIPTION="Perceptual video quality assessment based on multi-method fusion."
HOMEPAGE="https://github.com/Netflix/vmaf/"
SRC_URI="https://github.com/Netflix/vmaf/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="vmaf-LICENSE"
SLOT="0"
KEYWORDS="~amd64"
IUSE="python"

BDEPEND="
	dev-util/ninja
	dev-lang/nasm
"
DEPEND=""
RDEPEND="${DEPEND}
	python? (
		${PYTHON_DEPS}
		>=dev-python/dill-0.3.1[${PYTHON_USEDEP}]
		>=dev-python/numpy-1.18.2[${PYTHON_USEDEP}]
		>=dev-python/scipy-1.4.1[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-3.2.1[${PYTHON_USEDEP}]
		>=dev-python/pandas-1.0.3[${PYTHON_USEDEP}]
		>=sci-libs/scikit-learn-0.22.2[${PYTHON_USEDEP}]
		>=sci-libs/scikit-image-0.16.2[${PYTHON_USEDEP}]
		>=dev-python/h5py-2.6.0[${PYTHON_USEDEP}]
	)
"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

EMESON_SOURCE="${S}/libvmaf/"

src_configure() {
	default
	meson_src_configure
	if use python; then
		python_setup
	fi
}

src_compile() {
	pushd "third_party/libsvm" || die
		emake lib || die
	popd

	meson_src_compile

	if use python; then
		pushd "python" || die
			distutils-r1_python_compile
		popd
	fi
}

src_install() {
	meson_src_install

	if use python; then
		pushd "python" || die
			distutils-r1_python_install
		popd
	fi
}
