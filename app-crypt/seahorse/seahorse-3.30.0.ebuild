# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Source: https://bugs.gentoo.org/655304#c11

EAPI=6

inherit gnome2 gnome-meson vala
if [[ ${PV} = 9999 ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://gitlab.gnome.org/GNOME/${PN}.git"
	inherit git-r3
else
	TAG_COMMIT="7e0535880a2010df356d9c468c68cdcb77b45431"

	SRC_URI="https://gitlab.gnome.org/GNOME/${PN}/-/archive/${PV/\.0/}/${P}.zip"
	S="${WORKDIR}/${P/\.0/}-${TAG_COMMIT}"
fi

DESCRIPTION="A GNOME application for managing encryption keys"
HOMEPAGE="https://wiki.gnome.org/Apps/Seahorse"

LICENSE="GPL-2+ FDL-1.1+"
SLOT="0"
IUSE="debug ldap zeroconf"
if [[ ${PV} = 9999 ]]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
fi

COMMON_DEPEND="
	>=app-crypt/gcr-3.11.91:=[vala]
	>=dev-libs/glib-2.44:2
	>=x11-libs/gtk+-3.22:3
	>=app-crypt/libsecret-0.16[vala]
	>=net-libs/libsoup-2.33.92:2.4
	x11-misc/shared-mime-info

	net-misc/openssh
	>=app-crypt/gpgme-1.7.0
	>=app-crypt/gnupg-2.0.12

	ldap? ( net-nds/openldap:= )
	zeroconf? ( >=net-dns/avahi-0.6:= )
"
DEPEND="${COMMON_DEPEND}
	$(vala_depend)
	app-text/yelp-tools
	dev-util/gdbus-codegen
	>=dev-util/intltool-0.35
	dev-util/itstool
	sys-devel/gettext
	virtual/pkgconfig
"
# Need seahorse-plugins git snapshot
RDEPEND="${COMMON_DEPEND}
	!<app-crypt/seahorse-plugins-2.91.0_pre20110114
"

PATCHES=(
	# Fix compiling LDAP support
	"${FILESDIR}"/ifdef_consistency.patch
)

src_prepare() {
	vala_src_prepare
	gnome-meson_src_prepare
}

src_configure() {
	gnome-meson_src_configure \
		--buildtype $(usex debug debug plain) \
		-Dpgp-support=true \
		-Dcheck-compatible-gpg=true \
		-Dpkcs11-support=true \
		-Dkeyservers-support=true \
		-Dhkp-support=true \
		$(meson_use ldap ldap-support) \
		$(meson_use zeroconf key-sharing)
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
