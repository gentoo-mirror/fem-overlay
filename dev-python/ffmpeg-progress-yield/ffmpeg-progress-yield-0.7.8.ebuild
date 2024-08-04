# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..12} )

inherit distutils-r1

DESCRIPTION="Run an ffmpeg command with progress"
HOMEPAGE="
	https://pypi.org/project/ffmpeg-progress-yield/
	https://github.com/slhck/ffmpeg-progress-yield
"
SRC_URI="https://github.com/slhck/ffmpeg-progress-yield/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=dev-python/tqdm-4.38.0[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.4.3[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		${RDEPEND}
		media-video/ffmpeg
	)
"

distutils_enable_tests pytest

python_test() {
	epytest "test/test.py"
}
