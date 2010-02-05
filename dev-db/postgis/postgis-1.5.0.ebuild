# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/postgis/postgis-1.4.0.ebuild,v 1.2 2009/09/20 22:21:12 patrick Exp $

EAPI="1"

inherit eutils versionator

DESCRIPTION="Geographic Objects for PostgreSQL"
HOMEPAGE="http://postgis.refractions.net"
SRC_URI="http://postgis.refractions.net/download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="doc"

RDEPEND="=virtual/postgresql-server-8.4
	>=sci-libs/geos-3.1.1
	>=sci-libs/proj-4.6.0"

DEPEND="${RDEPEND}
	doc? ( app-text/docbook-xsl-stylesheets )"

RESTRICT="test"

pkg_setup(){
	if [ ! -z "${PGUSER}" ]; then
		eval unset PGUSER
	fi
	if [ ! -z "${PGDATABASE}" ]; then
		eval unset PGDATABASE
	fi
	local tmp
	tmp="$(portageq match / ${CATEGORY}/${PN} | cut -d'.' -f2)"
	if [ "${tmp}" != "$(get_version_component_range 2)" ]; then
		elog "You must soft upgrade your existing postgis enabled databases"
		elog "by adding their names in the ${ROOT}conf.d/postgis_dbs file"
		elog "then using 'emerge --config postgis'."
		require_soft_upgrade="1"
		ebeep 2
	fi
}

src_compile(){
	local myconf
	if use doc; then
		myconf="${myconf} --with-xsl=$(ls "${ROOT}"usr/share/sgml/docbook/* | \
			grep xsl\- | cut -d':' -f1)"
	fi

	econf --enable-autoconf \
		--datadir=/usr/share/postgresql-8.4/contrib/ \
		--libdir=/usr/$(get_libdir)/postgresql-8.4/ \
		--with-docdir=/usr/share/doc/${PF}/html/ \
		${myconf} ||\
			die "Error: econf failed"

	emake -j1 || die "Error: emake failed"

	cd topology/
	emake -j1 || die "Unable to build topology sql file"

	if use doc ; then
		cd "${S}"
		emake -j1 docs || die "Unable to build documentation"
	fi
}

src_install(){
	dodir /usr/$(get_libdir)/postgresql-8.4 /usr/share/postgresql-8.4/contrib/
	emake DESTDIR="${D}" install || die "emake install failed"
	cd "${S}/topology/"
	emake DESTDIR="${D}" install || die "emake install topology failed"

	cd "${S}"
	dodoc CREDITS TODO loader/README.* doc/*txt

	docinto topology
	dodoc topology/{TODO,README}
	dobin ./utils/postgis_restore.pl

	cd "${S}"
	if use doc; then
		emake DESTDIR="${D}" docs-install || die "emake install docs failed"
	fi

	echo "template_gis" > postgis_dbs
	doconfd postgis_dbs

	if [ ! -z "${require_soft_upgrade}" ]; then
		grep "'C'" -B 4 "${D}"usr/share/postgresql-8.4/contrib/lwpostgis.sql | \
			grep -v "'sql'" > \
				"${D}"usr/share/postgresql-8.4/contrib/load_before_upgrade.sql
	fi
}

pkg_postinst() {
	elog "To create new (upgrade) spatial databases add their names in the"
	elog "${ROOT}conf.d/postgis_dbs file, then use 'emerge --config postgis'."
}

pkg_config(){
	einfo "Create or upgrade a spatial templates and databases."
	einfo "Please add your databases names into ${ROOT}conf.d/postgis_dbs"
	einfo "(templates name have to be prefixed with 'template')."
	for i in $(cat "${ROOT}etc/conf.d/postgis_dbs"); do
		source "${ROOT}"etc/conf.d/postgresql-8.4
		PGDATABASE=${i}
		eval set PGDATABASE=${i}
		myuser="${PGUSER:-postgres}"
		mydb="${PGDATABASE:-template_gis}"
		eval set PGUSER=${myuser}

		is_template=false
		if [ "${mydb:0:8}" == "template" ];then
			is_template=true
			mytype="template database"
		else
			mytype="database"
		fi

		einfo
		einfo "Using the user ${myuser} and the ${mydb} ${mytype}."

		logfile=$(mktemp "${ROOT}tmp/error.log.XXXXXX")
		safe_exit(){
			eerror "Removing created ${mydb} ${mytype}"
			dropdb -q -U "${myuser}" "${mydb}" ||\
				(eerror "${1}"
				die "Removing old db failed, you must do it manually")
			eerror "Please read ${logfile} for more information."
			die "${1}"
		}

	# if there is not a table or a template existing with the same name, create.
		if [ -z "$(psql -U ${myuser} -l | grep "${mydb}")" ]; then
			createdb -O ${myuser} -U ${myuser} ${mydb} ||\
				die "Unable to create the ${mydb} ${mytype} as ${myuser}"
			createlang -U ${myuser} plpgsql ${mydb}
			if [ "$?" == 2 ]; then
				safe_exit "Unable to createlang plpgsql ${mydb}."
			fi
			(psql -q -U ${myuser} ${mydb} -f \
				"${ROOT}"usr/share/postgresql-8.4/contrib/lwpostgis.sql &&
			psql -q -U ${myuser} ${mydb} -f \
				"${ROOT}"usr/share/postgresql-8.4/contrib/spatial_ref_sys.sql) 2>\
					"${logfile}"
			if [ "$(grep -c ERROR "${logfile}")" \> 0 ]; then
				safe_exit "Unable to load sql files."
			fi
			if ${is_template}; then
				psql -q -U ${myuser} ${mydb} -c \
					"UPDATE pg_database SET datistemplate = TRUE
					WHERE datname = '${mydb}';
			GRANT ALL ON table spatial_ref_sys, geometry_columns TO PUBLIC;" \
				|| die "Unable to create ${mydb}"
			psql -q -U ${myuser} ${mydb} -c \
				"VACUUM FREEZE;" || die "Unable to set VACUUM FREEZE option"
			fi
		else
			if [ -e "${ROOT}"usr/share/postgresql-8.4/contrib/load_before_upgrade.sql ];
			then
				einfo "Updating the dynamic library references"
				psql -q -f \
					"${ROOT}"usr/share/postgresql-8.4/contrib/load_before_upgrade.sql\
						2> "${logfile}"
				if [ "$(grep -c ERROR "${logfile}")" \> 0 ]; then
					safe_exit "Unable to update references."
				fi
			fi
			if [ -e "${ROOT}"usr/share/postgresql-8.4/contrib/lwpostgis_upgrade.sql ];
			then
				einfo "Running soft upgrade"
				psql -q -U ${myuser} ${mydb} -f \
					"${ROOT}"usr/share/postgresql-8.4/contrib/lwpostgis_upgrade.sql 2>\
						"${logfile}"
				if [ "$(grep -c ERROR "${logfile}")" \> 0 ]; then
					safe_exit "Unable to run soft upgrade."
				fi
			fi
		fi
		if ${is_template}; then
			einfo "You can now create a spatial database using :"
			einfo "'createdb -T ${mydb} test'"
		fi
	done
}
