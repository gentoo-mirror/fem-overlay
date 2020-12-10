# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

DESCRIPTION="Perceptual video quality assessment based on multi-method fusion."
HOMEPAGE="https://github.com/Netflix/vmaf/"
SRC_URI="https://github.com/Netflix/vmaf/archive/v${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+ffmpeg"

DEPEND=""
RDEPEND="
	>=dev-python/numpy-1.12.0
	>=dev-python/scipy-0.17.1
	>=dev-python/matplotlib-2.0.0
	>=dev-python/pandas-0.19.2
	>=sci-libs/scikit-learn-0.18.1
	>=dev-python/h5py-2.6.0
"
pkg_setup() {
	enewgroup vmaf
}

src_prepare() {
	eapply_user
	find "${S}/python" \( -name ffmpeg2vmaf.py -o -name run_vmaf.py -o -name run_psnr \) \
		-exec sed \
			-e '/#!\/usr\/bin\/env /s/python$/python2/' \
			-i {} + || die "failed to fix python version"

	if use ffmpeg ; then
		echo "FFMPEG_PATH='/usr/bin/ffmpeg'" > "${S}/python/externals.py"
	fi
}

src_install() {
	dobin feature/moment
	dobin feature/psnr
	dobin feature/ssim
	dobin feature/ms_ssim
	dobin feature/vmaf

	dolib.so libsvm/libsvm.so.2

	dodir /usr/share/vmaf
	dodir /usr/share/vmaf/libsvm/
	cp -R "${S}/libsvm/python/" "${D}/usr/share/vmaf/libsvm/" || die "Install failed!"
	cp -R "${S}/python/" "${D}/usr/share/vmaf" || die "Install failed!"
	cp -R "${S}/workspace" "${D}/usr/share/vmaf" || die "Install failed!"
	cp -R "${S}/feature/" "${D}/usr/share/vmaf" || die "Install failed!"
	cp -R "${S}/resource/" "${D}/usr/share/vmaf" || die "Install failed!"
	chmod -R g+w "${D}/usr/share/vmaf/workspace"
	chown -R :vmaf "${D}/usr/share/vmaf"

	if use ffmpeg ; then
		dosym ../../share/vmaf/python/ffmpeg2vmaf.py /usr/local/bin/ffmpeg2vmaf
	fi
	dosym ../../share/vmaf/python/run_vmaf.py /usr/local/bin/run_vmaf
	dosym ../../share/vmaf/python/run_psnr.py /usr/local/bin/run_psnr

	einstalldocs
}
