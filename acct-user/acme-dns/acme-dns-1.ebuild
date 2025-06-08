# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="user for net-dns/acme-dns"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( acme-dns )

acct-user_add_deps
