# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="Group for dev-go/prometheus-graphite-relay"
ACCT_USER_ID=-1
ACCT_USER_GROUPS=( prometheus-graphite-relay )

acct-user_add_deps
