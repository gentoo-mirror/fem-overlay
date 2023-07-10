# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GO_FEM_DEP_ARCHIVE_VER=2023-07-10
inherit go-module-fem

DESCRIPTION="Command-line XML beautifier and content extractor"
HOMEPAGE="https://github.com/sibprogrammer/xq"
SRC_URI="
	https://github.com/sibprogrammer/xq/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	${GO_FEM_SRC_URI}
"

LICENSE="BSD MIT Apache-2.0 MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
