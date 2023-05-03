# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
PYTHON_COMPAT=( python3_{10..11} )

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/voc/voctomix.git"
fi

inherit ${SCM} python-single-r1

DESCRIPTION="Full-HD Software Live-Video-Mixer in python"
HOMEPAGE="https://github.com/voc/voctomix"
if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
else # Release
	SRC_URI="https://github.com/voc/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT"
SLOT="0"

if [ "${PV#9999}" = "${PV}" ] ; then
	KEYWORDS="~amd64"
fi

IUSE="examples gui"

DEPEND=""
RDEPEND="
	${PYTHON_DEPS}
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	media-libs/gst-plugins-good:1.0
	media-libs/gst-plugins-bad:1.0
	media-libs/gst-plugins-ugly:1.0
	media-plugins/gst-plugins-jpeg:1.0
	$(python_gen_cond_dep 'dev-python/pygobject:3[${PYTHON_USEDEP}]' )
	examples? (
		media-plugins/gst-plugins-libav:1.0
	)
	gui? (
		media-libs/gst-plugins-base:1.0[alsa]
		dev-python/pygobject[cairo]
	)
"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

src_install() {
	# install voctocore
	dodir /usr/share/voctocore/
	cp -R "${S}/voctocore/lib" "${D}/usr/share/voctocore/" || die "Install failed!"

	insinto /usr/share/voctocore/
	doins voctocore/README.md
	doins voctocore/default-config.ini

	exeinto /usr/share/voctocore/
	doexe voctocore/voctocore.py
	dosym ../../usr/share/voctocore/voctocore.py /usr/bin/voctocore

	# install voctogui
	if use gui ; then
		dodir /usr/share/voctogui/
		cp -R "${S}/voctogui/lib" "${D}/usr/share/voctogui/" || die "Install failed!"
		cp -R "${S}/voctogui/ui" "${D}/usr/share/voctogui/" || die "Install failed!"

		insinto /usr/share/voctogui/
		doins voctogui/README.md
		doins voctogui/default-config.ini

		exeinto /usr/share/voctogui/
		doexe voctogui/voctogui.py
		dosym ../../usr/share/voctogui/voctogui.py /usr/bin/voctogui
	fi

	# install documentation
	dodoc README.md
	if use examples ; then
		dodoc -r example-scripts
	fi

	# create config dir
	dodir /etc/voctomix/
}
