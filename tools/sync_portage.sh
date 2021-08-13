#!/bin/bash
set -e

mkdir -p /etc/portage/repos.conf

repo_conf=$(cat <<EOF
[DEFAULT]
main-repo = gentoo

[gentoo]
location = /var/db/repos/gentoo
sync-type = rsync
sync-uri = rsync://gentoo-portage.fem.tu-ilmenau.de/gentoo-portage
auto-sync = yes
sync-rsync-verify-jobs = 0
sync-rsync-verify-metamanifest = no
EOF
)
echo "${repo_conf}" > /etc/portage/repos.conf/gentoo.conf

mkdir -p tmp/repos
ln -sf $(pwd)/tmp/repos /var/db/repos/gentoo

emerge --sync --quiet
