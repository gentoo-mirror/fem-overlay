# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL=1

inherit distutils-r1

DESCRIPTION="Perceptual video quality assessment based on multi-method fusion."
HOMEPAGE="https://github.com/Netflix/vmaf/"
SRC_URI="https://github.com/Netflix/vmaf/archive/v${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="examples tools python"

DEPEND=""
RDEPEND="${DEPEND}
	python? (
		${PYTHON_DEPS}
		>=dev-python/numpy-1.12.0[${PYTHON_USEDEP}]
		>=sci-libs/scipy-0.17.1[${PYTHON_USEDEP}]
		>=dev-python/matplotlib-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/pandas-0.19.2[${PYTHON_USEDEP}]
		>=sci-libs/scikits_learn-0.13.0[${PYTHON_USEDEP}]
		>=sci-libs/scikits_learn-0.18.1[${PYTHON_USEDEP}]
		>=dev-python/h5py-2.6.0[${PYTHON_USEDEP}]
	)
"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# python-r1 requires this to know that we are building in the python subdir
BUILD_DIR=${S}/python

#pkg_setup() {
#	enewgroup vmaf
#}

src_prepare() {
	eapply_user
#	find "${S}/python" \( -name ffmpeg2vmaf.py -o -name run_vmaf.py -o -name run_psnr \) \
#		-exec sed \
#			-e '/#!\/usr\/bin\/env /s/python$/python2/' \
#			-i {} + || die "failed to fix python version"
#
#	if use ffmpeg ; then
#		echo "FFMPEG_PATH='/usr/bin/ffmpeg'" > "${S}/python/externals.py"
#	fi

	# replace makefile with the one available for Linux
	rm ptools/Makefile
	ln -s Makefile.Linux ptools/Makefile

	# fix stupid makefile syntax errors
	sed -i ptools/Makefile.Linux -e 's; :;:;g'

	# fix install destination
	sed -i wrapper/Makefile -e "s;= /usr/local;= ${EPREFIX}/usr;g" \
		-e 's;mkdir -p $(DESTDIR)$(INSTALL_PREFIX)/share;mkdir -p $(DESTDIR)$(INSTALL_PREFIX)/share/vmaf;' \
		-e 's;cp -r ../model $(DESTDIR)$(INSTALL_PREFIX)/share/;cp -r ../model $(DESTDIR)$(INSTALL_PREFIX)/share/vmaf/;'

#	if use python; then
#		pushd python >/dev/null || die
#		distutils-r1_src_prepare
#		popd >/dev/null || die
#	fi
}

src_compile() {
	emake -C libsvm lib
	emake -C ptools libptools.so
	emake -C wrapper

	if use examples; then
		emake -C ptools
	fi

	if use tools; then
		emake -C libsvm
		emake -C feature
	fi

#	if use python; then
#		pushd python >/dev/null || die
#		distutils-r1_src_compile
#		popd >/dev/null || die
#	fi
}

#src_install() {
#	default_src_install
#
#	if use python; then
#		pushd python >/dev/null || die
#		distutils-r1_src_install
#		popd >/dev/null || die
#	fi
#
#	if use tools; then
#		dobin feature/moment
#		dobin feature/psnr
#		dobin feature/ssim
#		dobin feature/ms_ssim
#		dobin feature/vmaf
#	fi
# #-> not yet ready
######### OLD ##################
#	dolib.so libsvm/libsvm.so.2

#	dodir /usr/share/vmaf
#	dodir /usr/share/vmaf/libsvm/
#	cp -R "${S}/libsvm/python/" "${D}/usr/share/vmaf/libsvm/" || die "Install failed!"
#	cp -R "${S}/python/" "${D}/usr/share/vmaf" || die "Install failed!"
#	cp -R "${S}/workspace" "${D}/usr/share/vmaf" || die "Install failed!"
#	cp -R "${S}/feature/" "${D}/usr/share/vmaf" || die "Install failed!"
#	cp -R "${S}/resource/" "${D}/usr/share/vmaf" || die "Install failed!"
#	chmod -R g+w "${D}/usr/share/vmaf/workspace"
#	chown -R :vmaf "${D}/usr/share/vmaf"

#	if use ffmpeg ; then
#		dosym ../../share/vmaf/python/ffmpeg2vmaf.py "${D}/usr/local/bin/ffmpeg2vmaf"
#	fi
#	dosym ../../share/vmaf/python/run_vmaf.py "${D}/usr/local/bin/run_vmaf"
#	dosym ../../share/vmaf/python/run_psnr.py "${D}/usr/local/bin/run_psnr"

#	einstalldocs
#}
