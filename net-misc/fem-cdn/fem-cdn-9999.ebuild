# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit python subversion

DESCRIPTION="FeM XXC3 Content Distribution Network"
HOMEPAGE="http://wiki.fem.tu-ilmenau.de/public/projekte/29c3/livecd"
ESVN_REPO_URI="http://subversion.fem.tu-ilmenau.de/repository/cccongress/trunk/tools/fem-cdn-mm"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+nginx crtmpserver erlyvideo icecast"

DEPEND=""
RDEPEND="dev-vcs/subversion
	net-analyzer/nrpe[increase_max_packetbuffer,command-args]
	net-analyzer/nagios-plugins-check_multi
	net-analyzer/nagios-plugins[ipv6,nagios-dns,nagios-ntp,nagios-ping,nagios-ssh,ssl,suid]
	net-analyzer/nagios-plugins-extended[hddtemp,nginx,suid,tcptraffic,apache]
	dev-python/paramiko
	dev-python/twisted
	dev-python/twisted-web
	sys-apps/iproute2
	nginx? ( www-servers/nginx[ipv6,ssl,nginx_modules_http_cache_purge,nginx_modules_http_flv,nginx_modules_http_image_filter,nginx_modules_http_mp4,nginx_modules_http_secure_link,nginx_modules_http_slowfs_cache,nginx_modules_http_stub_status,vim-syntax,nginx_modules_http_geoip,nginx_modules_rtmp,nginx_modules_rtmp_hls] dev-lang/v8 net-libs/nodejs )
	crtmpserver? ( media-video/crtmpserver )
	erlyvideo? ( media-video/erlyvideo )
	icecast? ( net-misc/icecast )"

src_install()
{
	newinitd cdn/etc/init.d/fem-cdn.init fem-cdn.init
	newinitd cdn/etc/init.d/fem-cdn.gentoo fem-cdn.gentoo

	insinto /var/www/rmtp
	doins /etc/nginx/stat.xsl

	keepdir /var/www/www
	keepdir /var/www/slides
	keepdir /var/www/hls
	keepdir /var/www/hls_slides_www

}
