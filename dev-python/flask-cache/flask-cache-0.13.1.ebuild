# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Adds cache support to your Flask application"
MY_PN="Flask-Cache"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"
HOMEPAGE="http://pythonhosted.org/Flask-Cache/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="memcached redis"

RDEPEND="
	memcached? (
		net-misc/memcached
		dev-python/pylibmc[${PYTHON_USEDEP}]
	)
	redis? (
		dev-db/redis
		dev-python/werkzeug[${PYTHON_USEDEP}]
	)"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"
