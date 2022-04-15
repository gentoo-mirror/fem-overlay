# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="GOMOR"
inherit perl-module

DESCRIPTION="Frame crafting made easy"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Class-Gomor
	dev-perl/Net-Frame
"
DEPEND="${RDEPEND}"
BDEPEND="dev-perl/Module-Build"
