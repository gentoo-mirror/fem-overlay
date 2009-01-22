# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-kernel/xen-sources/xen-sources-2.6.21.ebuild,v 1.3 2008/08/31 17:44:43 rbu Exp $

ETYPE="sources"
UNIPATCH_STRICTORDER="1"
K_WANT_GENPATCHES="base"
K_GENPATCHES_VER="6"
inherit kernel-2
detect_version

DESCRIPTION="Full sources for a dom0/domU Linux kernel to run under Xen"
HOMEPAGE="http://xen.org/"
IUSE="accessfs"

KEYWORDS="~x86 ~amd64"

XENPATCHES_VER="2"
XENPATCHES="xen-patches-${PV}-${XENPATCHES_VER}.tar.bz2"
XENPATCHES_URI="mirror://gentoo/${XENPATCHES}"

SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${XENPATCHES_URI}"

UNIPATCH_LIST="${DISTDIR}/${XENPATCHES}"

if use accessfs; then
  UNIPATCH_LIST="${UNIPATCH_LIST} ${FILESDIR}/accessfs-2.6.21-0.20.patch"
fi

DEPEND="${DEPEND} >=sys-devel/binutils-2.17"
