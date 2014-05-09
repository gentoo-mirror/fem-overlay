# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
PYTHON_COMPAT=( python2_7 )
MY_P="${P/_p/p}"
MY_PV="${MY_P/check_mk-/}"
S="${WORKDIR}/${MY_P}"

inherit eutils python-r1 toolchain-funcs

DESCRIPTION="General purpose Nagios/Icinga plugin for retrieving data"
HOMEPAGE="http://mathias-kettner.de/check_mk.html"
SRC_URI="http://mathias-kettner.de/download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="agent-only logwatch smart mysql postgres oracle apache_status livestatus livecheck wato xinetd zypper nfsexports"

REQUIRED_USE="
	livestatus? ( !agent-only )
	livecheck? ( livestatus )
	wato? ( !agent-only )"

RDEPEND="${DEPEND}
	xinetd? ( sys-apps/xinetd )
	!agent-only? ( || ( net-analyzer/nagios-core net-analyzer/icinga ) )
	!agent-only? ( www-servers/apache www-apache/mod_python )"

doit() {
	echo "$@"
	$@ || die "compile failed!"
}

src_compile() {
	einfo ${S}
	DESTDIR=${S} ./setup.sh --yes

	# compile waitmax
	cd "${S}/usr/share/check_mk/agents"
	doit $(tc-getCC) ${CFLAGS} waitmax.c -o waitmax
}

src_install() {
	local mydaemon=

	if has_version net-analyzer/nagios-core; then
		mydaemon=nagios
	else
		mydaemon=icinga
	fi

	if ! use agent-only; then
		# Apache configuration
		insinto /etc/apache2/modules.d
		doins etc/apache2/conf.d/zzz_check_mk.conf
		if [ ${mydaemon} == "icinga" ]; then
			sed -i -e 's/AuthName ".*"/AuthName "Icinga Access"/' "${D}"/etc/apache2/modules.d/zzz_check_mk.conf
			sed -i -e 's#AuthUserFile .*#AuthUserFile /etc/icinga/htpasswd.users#' "${D}"/etc/apache2/modules.d/zzz_check_mk.conf
		else
			sed -i -e 's/AuthName ".*"/AuthName "Nagios Access"/' "${D}"/etc/apache2/modules.d/zzz_check_mk.conf
			sed -i -e 's#AuthUserFile .*#AuthUserFile /etc/nagios/htpasswd.users#' "${D}"/etc/apache2/modules.d/zzz_check_mk.conf
		fi

		if use wato; then
			# sudoers configuration
			cat - > "${T}"/check_mk << EOF
# Needed for WATO - the Check_MK Web Administration Tool
Defaults:apache !requiretty
apache ALL = (root) NOPASSWD: /usr/bin/check_mk --automation *
EOF
			insinto /etc/sudoers.d
			doins "${T}"/check_mk
		fi

		# check_mk configuration
		insinto /etc/check_mk
		doins etc/check_mk/main.mk
		doins etc/check_mk/main.mk-${MY_PV}
		doins etc/check_mk/multisite.mk
		doins etc/check_mk/multisite.mk-${MY_PV}
		insinto /etc/check_mk/conf.d
		doins etc/check_mk/conf.d/README
		dodir /etc/check_mk/conf.d/wato
		touch "${D}"/etc/check_mk/conf.d/distributed_wato.mk
		dodir /etc/check_mk/multisite.d
		dodir /etc/check_mk/multisite.d/wato
		touch "${D}"/etc/check_mk/multisite.d/sites.mk

		dodir /etc/${mydaemon}
		touch "${D}"/etc/${mydaemon}/auth.serials

		# Nagios / Icinga check_mk templates
		dodir /etc/${mydaemon}/check_mk.d
		dosym /usr/share/check_mk/check_mk_templates.cfg /etc/${mydaemon}/check_mk.d/check_mk_templates.cfg

		dobin usr/bin/check_mk
		dosym /usr/bin/check_mk /usr/bin/cmk
		dobin usr/bin/unixcat
		dobin usr/bin/mkp

		keepdir /usr/share/check_mk
		cp -R "${S}"/usr/share/check_mk/* "${D}"/usr/share/check_mk/ || die "copying files failed!"
		dodir /usr/share/check_mk/livestatus

		keepdir /var/lib/check_mk/autochecks
		keepdir /var/lib/check_mk/cache
		keepdir /var/lib/check_mk/counters
		keepdir /var/lib/check_mk/logwatch
		keepdir /var/lib/check_mk/packages
		insinto /var/lib/check_mk/packages
		doins var/lib/check_mk/packages/check_mk
		keepdir /var/lib/check_mk/precompiled
		keepdir /var/lib/check_mk/snmpwalks
		keepdir /var/lib/check_mk/tmp
		keepdir /var/lib/check_mk/wato
		keepdir /var/lib/check_mk/web

		# Update check_mk defaults
		sed -i -e "s#^\(check_manpages_dir\s*=\).*#\1 '/usr/share/doc/${PF}/checks'#" "${D}"/usr/share/check_mk/modules/defaults
		sed -i -e "s#^\(nagios_objects_file\s*=\).*#\1 '/etc/${mydaemon}/check_mk.d/check_mk_objects.cfg'#" "${D}"/usr/share/check_mk/modules/defaults
		sed -i -e "s#^\(nagios_command_pipe_path\s*=\).*#\1 '/var/lib/${mydaemon}/rw/${mydaemon}.cmd'#" "${D}"/usr/share/check_mk/modules/defaults
		sed -i -e "s#^\(check_result_path\s*=\).*#\1 '/var/lib/${mydaemon}/spool/checkresults'#" "${D}"/usr/share/check_mk/modules/defaults
		sed -i -e "s#^\(nagios_status_file\s*=\).*#\1 '/var/lib/${mydaemon}/status.dat'#" "${D}"/usr/share/check_mk/modules/defaults
		sed -i -e "s#^\(nagios_conf_dir\s*=\).*#\1 '/etc/${mydaemon}/check_mk.d'#" "${D}"/usr/share/check_mk/modules/defaults
		sed -i -e "s#^\(nagios_user\s*=\).*#\1 '${mydaemon}'#" "${D}"/usr/share/check_mk/modules/defaults
		sed -i -e "s#^\(www_group\s*=\).*#\1 '${mydaemon}'#" "${D}"/usr/share/check_mk/modules/defaults
		sed -i -e "s#^\(nagios_config_file\s*=\).*#\1 '/etc/${mydaemon}/${mydaemon}.cfg'#" "${D}"/usr/share/check_mk/modules/defaults
		sed -i -e "s#^\(nagios_startscript\s*=\).*#\1 '/etc/init.d/${mydaemon}'#" "${D}"/usr/share/check_mk/modules/defaults
		sed -i -e "s#^\(nagios_binary\s*=\).*#\1 '/usr/sbin/${mydaemon}'#" "${D}"/usr/share/check_mk/modules/defaults
		sed -i -e "s#^\(apache_config_dir\s*=\).*#\1 '/etc/apache/modules.d'#" "${D}"/usr/share/check_mk/modules/defaults
		sed -i -e "s#^\(htpasswd_file\s*=\).*#\1 '/etc/${mydaemon}/htpasswd.users'#" "${D}"/usr/share/check_mk/modules/defaults
		if [ ${mydaemon} == "icinga" ]; then
			sed -i -e "s#^\(nagios_auth_name\s*=\).*#\1 'Icinga Access'#" "${D}"/usr/share/check_mk/modules/defaults
		else
			sed -i -e "s#^\(nagios_auth_name\s*=\).*#\1 'Nagios Access'#" "${D}"/usr/share/check_mk/modules/defaults
		fi
		sed -i -e "s#^\(livestatus_unix_socket\s*=\).*#\1 '/var/lib/${mydaemon}/rw/live'#" "${D}"/usr/share/check_mk/modules/defaults
		sed -i -e "s#^\(doc_dir\s*=\).*#\1 '/usr/share/doc/${PF}'#" "${D}"/usr/share/check_mk/modules/defaults
		cp "${D}"/usr/share/check_mk/modules/defaults "${D}"/usr/share/check_mk/web/htdocs/defaults.py

		# Change permissions
		fowners -R ${mydaemon}:${mydaemon} /etc/${mydaemon}/auth.serials || die
		fperms -R 0660 /etc/${mydaemon}/auth.serials || die
		fowners -R ${mydaemon}:${mydaemon} /etc/${mydaemon}/check_mk.d || die
		fperms -R 0775 /etc/${mydaemon}/check_mk.d || die
		fowners -R root:apache /etc/check_mk/conf.d/wato || die
		fperms -R 0775 /etc/check_mk/conf.d/wato || die
		fowners root:apache /etc/check_mk/conf.d/distributed_wato.mk || die
		fperms 0664 /etc/check_mk/conf.d/distributed_wato.mk || die
		fowners -R root:apache /etc/check_mk/multisite.d/wato || die
		fperms -R 0775 /etc/check_mk/multisite.d/wato || die
		fowners root:apache /etc/check_mk/multisite.d/sites.mk || die
		fperms 0664 /etc/check_mk/multisite.d/sites.mk || die
		fowners root:${mydaemon} /var/lib/check_mk/cache || die
		fperms 0775 /var/lib/check_mk/counters || die
		fowners root:${mydaemon} /var/lib/check_mk/counters || die
		fperms 0775 /var/lib/check_mk/logwatch || die
		fowners root:${mydaemon} /var/lib/check_mk/logwatch || die
		fperms 0775 /var/lib/check_mk/cache || die
		fowners -R root:apache /var/lib/check_mk/tmp || die
		fperms -R 0775 /var/lib/check_mk/tmp || die
		fowners -R root:apache /var/lib/check_mk/web || die
		fperms -R 0775 /var/lib/check_mk/web || die
		fowners -R root:apache /var/lib/check_mk/wato || die
		fperms -R 0775 /var/lib/check_mk/wato || die
	fi

	# Install agent related files
	newbin usr/share/check_mk/agents/check_mk_agent.linux check_mk_agent
	dobin usr/share/check_mk/agents/waitmax

	if use xinetd; then
		insinto /etc/xinetd.d
		newins usr/share/check_mk/agents/xinetd.conf check_mk
	fi

	keepdir /usr/lib/check_mk_agent/local
	keepdir /usr/lib/check_mk_agent/plugins

	# Install Livestatus
	if use livestatus; then
		if ! use livecheck; then
			cat - > "${T}"/livestatus.cfg << EOF
define module{
	module_name		mk-livestatus
	module_type		neb
	path			/usr/lib/check_mk/livestatus.o
	args			/var/lib/${mydaemon}/rw/live
	}
EOF
		else
			cat - > "${T}"/livestatus.cfg << EOF
define module{
	module_name		mk-livestatus
	module_type		neb
	path			/usr/lib/check_mk/livestatus.o
	args			/var/lib/${mydaemon}/rw/live livecheck=/usr/lib/check_mk/livecheck
	}
EOF
		fi
		insinto /etc/${mydaemon}/modules
		doins "${T}"/livestatus.cfg

		insinto /usr/lib/check_mk
		doins usr/lib/check_mk/livestatus.o
		fperms 0755 /usr/lib/check_mk/livestatus.o || die

		dobin usr/bin/unixcat

		# Install livecheck
		if use livecheck; then
			insinto /usr/lib/check_mk
			doins usr/lib/check_mk/livecheck
			fowners root:${mydaemon} /usr/lib/check_mk/livecheck || die
			fperms 4750 /usr/lib/check_mk/livecheck || die
		fi
	fi

	# Documentation
	if ! use agent-only; then
		dodoc -r usr/share/doc/check_mk/*
		docompress -x /usr/share/doc/${PF}/checks/
	else
		dodoc usr/share/doc/check_mk/AUTHORS usr/share/doc/check_mk/COPYING usr/share/doc/check_mk/ChangeLog
	fi

	# Install the check_mk_agent logwatch plugin
	if use logwatch; then
		insinto /etc/check_mk
		doins usr/share/check_mk/agents/logwatch.cfg
		exeinto /usr/lib/check_mk_agent/plugins
		doexe usr/share/check_mk/agents/plugins/mk_logwatch
	fi

	# Install the check_mk_agent smart plugin
	if use smart; then
		exeinto /usr/lib/check_mk_agent/plugins
		doexe usr/share/check_mk/agents/plugins/smart
	fi

	# Install the check_mk_agent mysql plugin
	if use mysql; then
		exeinto /usr/lib/check_mk_agent/plugins
		doexe usr/share/check_mk/agents/plugins/mk_mysql
	fi

	# Install the check_mk_agent postgres plugin
	if use postgres; then
		exeinto /usr/lib/check_mk_agent/plugins
		doexe usr/share/check_mk/agents/plugins/mk_postgres
	fi

	# Install the check_mk_agent apache_status plugin
	if use apache_status; then
		exeinto /usr/lib/check_mk_agent/plugins
		doexe usr/share/check_mk/agents/plugins/apache_status
	fi

	# Install the check_mk_agent zypper plugin
	if use zypper; then
		exeinto /usr/lib/check_mk_agent/plugins
		doexe usr/share/check_mk/agents/plugins/mk_zypper
	fi

	# Install the check_mk_agent oracle plugin
	if use oracle; then
		exeinto /usr/lib/check_mk_agent/plugins
		doexe usr/share/check_mk/agents/plugins/mk_oracle
	fi

	# Install the check_mk_agent nfsexports plugin
	if use nfsexports; then
		exeinto /usr/lib/check_mk_agent/plugins
		doexe usr/share/check_mk/agents/plugins/nfsexports
	fi
}

pkg_postinst() {
	local mydaemon=

	if has_version net-analyzer/nagios-core; then
		mydaemon=nagios
	else
		mydaemon=icinga
	fi

	if ! use agent-only; then
		elog "IMPORTANT: Please add the following line to your"
		elog "/etc/${mydaemon}/${mydaemon}.cfg, so that"
		elog "${mydaemon} can load your check_mk configuration."
		elog
		elog "  cfg_dir=/etc/${mydaemon}/check_mk.d"
		elog
	fi
	if use wato; then
		elog "INFO: Your webserver needs write access to"
		elog "/etc/${mydaemon}/htpasswd.users!"
		elog "otherwise wato will not function correctly!"
		elog
		elog "chown ${mydaemon}: /etc/${mydaemon}/htpasswd.users"
		elog "chmod 660 /etc/${mydaemon}/htpasswd.users"
		elog
	fi
}
