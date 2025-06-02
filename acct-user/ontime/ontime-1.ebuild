# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Daemon user for app-misc/ontime"
ACCT_USER_ID=-1
ACCT_USER_HOME=/var/lib/ontime
ACCT_USER_GROUPS=( ontime )

acct-user_add_deps
