# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: nginx-module.eclass
# @MAINTAINER:
# Jonas Licht <jonas.licht@gmail.com>
# @AUTHOR:
# Jonas Licht <jonas.licht@gmail.com>
# @BLURB: Provide a set of functions to build nginx dynamic modules.
# @DESCRIPTION:
# Eclass to make dynamic nginx modules.
# As these modules are hardly build against one nginx version we use version cut to indicate the nginx version too.
# The first three parts of the version must represent the nginx version,
# the remaining part displays the module version.
#
# To build a nginx module the whole nginx source code is needed,
# therfore we set the SRC_URI to the nginx source archive.
# The module archive must be added with SRC_URI+=

case ${EAPI:-0} in
	7) ;;
	*) die "This eclass only supports EAPI 7" ;;
esac

# @ECLASS-VARIABLE:	NGX_PV
# @DESCRIPTION:
# Uses version cut of the first three parts of the version to determine the proposed nginx version.
# This version is used for SRC_URI, BDPEND and compiling process.
NGX_PV=$(ver_cut 1-3)

# @ECLASS-VARIABLE: MODULE_PV
# @DESCRIPTION:
# Uses version cut to get the version of the module.
# Variable can uses for SRC_URI.
MODULE_PV=$(ver_cut 4-)

BDPEND="=www-servers/nginx-${NGX_PV}:="
SRC_URI="https://nginx.org/download/nginx-${NGX_PV}.tar.gz
	"

S="${WORKDIR}/nginx-${NGX_PV}"

EXPORT_FUNCTIONS src_configure src_compile src_install

# @FUNCTION: nginx-module_src_configure
# @USAGE: [additional-args]
# @DESCRIPTION:
# Parses the configure from the original nginx binary by exicution 'nginx -V' and adds the package as dynamic module.
nginx-module_src_configure() {
	if [ `grep -c "\.[[:space:]]auto/module" ${WORKDIR}/${PN}-${MODULE_PV}/config` -eq 0 ]; then
		die "module uses old unsupported static config file syntax: https://www.nginx.com/resources/wiki/extending/converting/"
	fi

	#grep nginx configure from nginx -V add drop all other external modules
	NGX_ORIGIN_CONFIGURE=`nginx -V 2>&1 | grep "configure arguments:" | cut -d: -f2 | sed "s/--add-module=\([^\s]\)*\s/ /"`
	./configure ${NGX_ORIGIN_CONFIGURE} --add-dynamic-module="../${PN}-${MODULE_PV}" "$@" || die "configure failed"
}

# @FUNCTION: nginx-module_src_compile
# @USAGE: [additional-args]
# @DESCRIPTION:
# Runs 'make modules' to only build our package module.
nginx-module_src_compile() {
	emake modules "$@"
}

# @FUNCTION: nginx-module_src_install
# @DESCRIPTION:
# Parses the module config file to get the so file name and install the shared object file to '/usr/$(get_libdir)/nginx/modules'
nginx-module_src_install() {
	NGX_MODULE_NAME=`grep ${WORKDIR}/${PN}-${MODULE_PV}/config -e "ngx_addon_name" | cut -d= -f2`
	exeinto /usr/$(get_libdir)/nginx/modules
	doexe ${S}/objs/${NGX_MODULE_NAME}.so
}
