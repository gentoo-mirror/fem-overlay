# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v3
# $Header: $

EAPI=4
inherit cmake-utils
inherit subversion

DESCRIPTION="C++ RTMP Server"
HOMEPAGE="http://www.rtmpd.com/"
ESVN_REPO_URI="https://svn.rtmpd.com/crtmpserver/branches/1.0"
ESVN_PROJECT="crtmpserver"
ESVN_USER="anonymous"
ESVN_PASS='""'
ESVN_OPTIONS="${ESVN_OPTIONS} --non-interactive --trust-server-cert "
LICENSE="GPLv3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""
TMP_SVN_VER=$(/usr/bin/svn info --username="anonymous" --password="" --non-interactive --trust-server-cert --force https://svn.rtmpd.com/crtmpserver/trunk/sources | grep ^Revision | cut -d ' ' -f 2 | tr -d '\n')

MAKEOPTS=-j1
CMAKE_USE_DIR="${WORKDIR}/${PF}/builders/cmake"
CMAKE_BUILD_TYPE="Release"
MYCMAKEARGS="-DCRTMPSERVER_INSTALL_PREFIX=${EPREFIX}${PREFIX:-/usr} -DTEMP_FRAMEWORK_VER=0.${TMP_SVN_VER}"

#/var/tmp/portage/media-video/crtmpserver-0.9999/work/trunk/builders/cmake/CMakeLists.txt
#/var/tmp/portage/media-video/crtmpserver-0.9999/work/crtmpserver-0.9999/builders/cmake/




