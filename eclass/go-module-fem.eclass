# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: go-module-fem.eclass
# @MAINTAINER:
# Adrian Schollmeyer <adrian.schollmeyer@fem.tu-ilmenau.de>
# @AUTHOR:
# Adrian Schollmeyer <adrian.schollmeyer@fem.tu-ilmenau.de>
# @SUPPORTED_EAPIS: 7 8
# @PROVIDES: go-module
# @BLURB: Eclass automating builds of Go module packages with dependencies vendored by FeM.
# @DESCRIPTION:
# This eclass provides basic settings and functions needed by software written
# in the go programming language which have dependency tarballs hosted on the
# FeM infrastructure.
# If your software uses a dependency tarball hosted at
# https://gitlab.fem-net.de/gentoo/fem-overlay-vendored, it can leverage this
# eclass to ease ebuild writing and reduces boilerplate code.


if [[ ! ${_GO_MODULE_FEM_ECLASS} ]]; then

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI} unsupported."
esac

inherit go-module

# @ECLASS_VARIABLE: GO_FEM_DEP_ARCHIVE_VER
# @REQUIRED
# @PRE_INHERIT
# @DESCRIPTION:
# This variable contains the dependency archive version being used by this
# package.
# In the dependency archive package registry, look for the desired dependency
# archive and use only the part of the version behind the plus character.
# This is usually the ISO formatted date when the archive was published.
#
# For example, the upstream version `1.0.1.2022-07-09` results in the archive
# version `2022-07-09`.

# @ECLASS_VARIABLE: GO_FEM_DEP_ARCHIVE_PV
# @DESCRIPTION:
# Full dep archive package version, generated from PV and
# GO_FEM_DEP_ARCHIVE_VER.
GO_FEM_DEP_ARCHIVE_PV="${PV}+${GO_FEM_DEP_ARCHIVE_VER}"

# @ECLASS_VARIABLE: GO_FEM_DEP_ARCHIVE_P
# @DESCRIPTION:
# Target archive name, generated from `PN` and `GO_FEM_DEP_ARCHIVE_PV`.
GO_FEM_DEP_ARCHIVE_P="${PN}-deps-${GO_FEM_DEP_ARCHIVE_PV}"

# @ECLASS_VARIABLE: GO_FEM_VENDOR_BASEURI
# @PRE_INHERIT
# @DESCRIPTION:
# This variable contains the base URI of the package registry.
# The default is the base URI for the FeM dependency tarball registry.
: "${GO_FEM_VENDOR_BASEURI:=https://gitlab.fem-net.de/api/v4/projects/309/packages/generic}"

# @ECLASS_VARIABLE: GO_FEM_VENDOR_ARCHIVE_NAME
# @PRE_INHERIT
# @DESCRIPTION:
# This variable contains the file name of the dependency archive to download.
# The default follows the convention of `go-module.eclass`.
: "${GO_FEM_VENDOR_ARCHIVE_NAME:=${P}-deps.tar.xz}"

# @ECLASS_VARIABLE: GO_FEM_SRC_URI
# @DESCRIPTION:
# Additional distfiles required by this eclass.
# Must be added to `SRC_URI` in the ebuild.
GO_FEM_SRC_URI="${GO_FEM_VENDOR_BASEURI}/${PN}/${GO_FEM_DEP_ARCHIVE_PV//+/%2B}/${GO_FEM_VENDOR_ARCHIVE_NAME} -> ${GO_FEM_DEP_ARCHIVE_P}.tar.xz"

# @FUNCTION: go-module-fem_src_compile
# @DESCRIPTION:
# This function calls ego build to build the go module
go-module-fem_src_compile() {
	ego build -work
}

# @FUNCTION: go-module-fem_src_install
# @DESCRIPTION:
# This function executes the default install function and installs a binary
# named ${PN} using dobin.
# This should be sufficient for most trivial Go builds.
go-module-fem_src_install() {
	default
	dobin ${PN}
}

_GO_MODULE_FEM_ECLASS=1
fi

EXPORT_FUNCTIONS src_compile src_install
