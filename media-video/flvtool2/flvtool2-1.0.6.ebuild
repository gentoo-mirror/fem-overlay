# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit gems

DESCRIPTION="a flash video and metadata manipulation tool (FLV)"
HOMEPAGE="http://www.inlet-media.de/flvtool2"
SRC_URI="http://gems.rubyforge.org/gems/${P}.gem"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-lang/ruby"
DEPEND="${RDEPEND}
	dev-ruby/rubygems"
