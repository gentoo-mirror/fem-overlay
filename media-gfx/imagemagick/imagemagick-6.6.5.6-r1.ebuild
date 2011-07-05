# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/imagemagick/imagemagick-6.6.5.6.ebuild,v 1.9 2011/06/09 06:06:06 radhermit Exp $

EAPI=3
inherit multilib toolchain-funcs versionator

MY_P=ImageMagick-$(replace_version_separator 3 '-')

DESCRIPTION="A collection of tools and libraries for many image formats"
HOMEPAGE="http://www.imagemagick.org/"
SRC_URI="mirror://${PN}/${MY_P}.tar.xz"

LICENSE="imagemagick"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~ppc-aix ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="autotrace bzip2 +corefonts cxx djvu fftw fontconfig fpx graphviz gs hdri
jbig jpeg jpeg2k lcms lqr openexr openmp perl png q32 q8 raw static-libs svg
tiff truetype wmf X xml zlib php-safemode-bin"
IUSE="${IUSE} video_cards_nvidia" # opencl support

RDEPEND=">=sys-devel/libtool-2.2.6b
	autotrace? ( >=media-gfx/autotrace-0.31.1 )
	bzip2? ( app-arch/bzip2 )
	djvu? ( app-text/djvu )
	fftw? ( sci-libs/fftw:3.0 )
	fontconfig? ( media-libs/fontconfig )
	fpx? ( >=media-libs/libfpx-1.3.0-r1 )
	graphviz? ( >=media-gfx/graphviz-2.6 )
	gs? ( app-text/ghostscript-gpl )
	jbig? ( media-libs/jbigkit )
	jpeg? ( virtual/jpeg )
	jpeg2k? ( media-libs/jasper )
	lcms? ( media-libs/lcms:2 )
	lqr? ( >=media-libs/liblqr-0.1.0 )
	openexr? ( media-libs/openexr )
	perl? ( >=dev-lang/perl-5.8.6-r6 )
	png? ( >=media-libs/libpng-1.4 )
	raw? ( media-gfx/ufraw )
	svg? ( >=gnome-base/librsvg-2.9.0 )
	tiff? ( >=media-libs/tiff-3.5.5 )
	truetype? ( media-libs/freetype:2
		corefonts? ( media-fonts/corefonts ) )
	video_cards_nvidia? ( x11-drivers/nvidia-drivers )
	wmf? ( >=media-libs/libwmf-0.2.8 )
	X? (
		x11-libs/libXext
		x11-libs/libXt
		x11-libs/libICE
		x11-libs/libSM
	)
	xml? ( >=dev-libs/libxml2-2.4.10 )
	zlib? ( sys-libs/zlib )
	!dev-perl/perlmagick
	!media-gfx/graphicsmagick[imagemagick]
	php-safemode-bin? ( dev-lang/php )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	>=sys-apps/sed-4
	X? ( x11-proto/xextproto )"

S=${WORKDIR}/${MY_P}

RESTRICT="perl? ( userpriv )"

src_prepare() {
	sed -i \
		-e "/^DOCUMENTATION_RELATIVE_PATH/s:=.*:=${PF}:" \
		configure || die
}

src_configure() {
	local depth=16
	use q8 && depth=8
	use q32 && depth=32

	local openmp=disable
	if use openmp && tc-has-openmp; then
		openmp=enable
	fi

	local myconf
	if use truetype; then
		myconf="$(use_with corefonts windows-font-dir /usr/share/fonts/corefonts)"
	else
		myconf="--without-corefonts"
	fi

	econf \
		--disable-dependency-tracking \
		$(use_enable static-libs static) \
		$(use_enable hdri) \
		$(use_enable video_cards_nvidia opencl) \
		--with-threads \
		--without-included-ltdl \
		--with-ltdl-include="${EPREFIX}/usr/include" \
		--with-ltdl-lib="${EPREFIX}/usr/$(get_libdir)" \
		--with-modules \
		--with-quantum-depth=${depth} \
		$(use_with cxx magick-plus-plus) \
		$(use_with perl) \
		--with-perl-options='INSTALLDIRS=vendor' \
		--with-gs-font-dir="${EPREFIX}/usr/share/fonts/default/ghostscript" \
		$(use_with bzip2 bzlib) \
		$(use_with X x) \
		$(use_with zlib) \
		$(use_with autotrace) \
		$(use_with gs dps) \
		$(use_with djvu) \
		--with-dejavu-font-dir="${EPREFIX}/usr/share/fonts/dejavu" \
		$(use_with fftw) \
		$(use_with fpx) \
		$(use_with fontconfig) \
		$(use_with truetype freetype) \
		$(use_with gs gslib) \
		$(use_with graphviz gvc) \
		$(use_with jbig) \
		$(use_with jpeg) \
		$(use_with jpeg2k jp2) \
		--without-lcms \
		$(use_with lcms lcms2) \
		$(use_with lqr) \
		$(use_with openexr) \
		$(use_with png) \
		$(use_with svg rsvg) \
		$(use_with tiff) \
		${myconf} \
		$(use_with wmf) \
		$(use_with xml) \
		--${openmp}-openmp
}

src_test() {
	if has_version ~${CATEGORY}/${P}; then
		emake -j1 check || die
	else
		ewarn "Skipping tests because installed version doesn't match."
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS.txt ChangeLog NEWS.txt README.txt

	if use perl; then
		find "${ED}" -type f -name perllocal.pod -delete
		find "${ED}" -depth -mindepth 1 -type d -empty -delete
	fi

	# install hardlinks for php safemode
	if use php-safemode-bin; then
		LOCAL_PHP_BIN_DIR="/usr/local/php/bin"
		dodir ${LOCAL_PHP_BIN_DIR} || die
		for UTILITY in composite convert identify; do
			dohard /usr/bin/${UTILITY} ${LOCAL_PHP_BIN_DIR}/${UTILITY}
		done
		chown -R apache:apache ${D}${LOCAL_PHP_BIN_DIR}
	fi
}
