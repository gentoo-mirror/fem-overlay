#!/bin/bash

cd "$(dirname "${0}")/.."

: ${COMPARE_TO:=origin/master}
: ${MANIFEST_ONLY_DIFF:=true}
: ${DISTDIR:=/var/cache/distfiles}

die() {
	echo "*** ERR *** $*"
	exit 1
}

banner() {
	echo "#####################################################"
	echo "### $?"
	echo "#####################################################"
}

changed_dirs="$(git diff ${COMPARE_TO} --name-only | grep -E "ebuild$" | xargs dirname | grep -v "\." | uniq)"
exit_code=0
failed_packages=()
ignored_packages=()

mkdir -p "${DISTDIR}" || die "Failed to create DISTDIR ${DISTDIR}"
pushd "${DISTDIR}" || die "Failed to enter DISTDIR ${DISTDIR}"
dist_dir="$(pwd)" || die "pwd failed in DISTDIR ${DISTDIR}"
popd
chown $(whoami):portage "${dist_dir}" || die "Failed to chown DISTDIR ${DISTDIR}"
chmod 775 "${dist_dir}" || die "Failed to chmod DISTDIR ${DISTDIR}"

echo "Creating category list"
categories=""
for cat in $(cat /var/db/repos/gentoo/profiles/categories); do
	if [[ -d "./${cat}" ]]; then
		categories="${categories} ${cat}"
	fi
done

for cat in $(cat profiles/categories); do
	if [[ -d "./${cat}" ]]; then
		categories="${categories} ${cat}"
	fi
done

banner "Checking packages:"
base_dir="$(pwd)"
for c in ${categories}; do
	cd "${base_dir}/${c}" || continue
	for d in *; do
		cd "${base_dir}/${c}/${d}" || continue
		
		echo "${changed_dirs}" | grep "${c}/${d}" >/dev/null
		if [[ "$?" != "0" ]] && ${MANIFEST_ONLY_DIFF}; then
			continue
		fi

		atom="${c}/${d}::fem-overlay"
		banner " * ${atom}... "
		if grep pkg_nofetch *.ebuild >/dev/null; then
			echo "Ignoring ${atom} due to pkg_nofetch!"
			ignored_packages+=( "${atom}" )
			continue
		fi

		echo "Regenerating manifest"
		output="$(pkgdev manifest -qfd ${dist_dir})"
		if [[ "$?" != "0" ]]; then
			failed_packages+=( "${atom}" )
			echo ""
			echo "*** FAILED PACKAGE: ${atom} ***"
			echo "${output}"
			echo "********************************************************"
			echo ""
			exit_code=1
		fi
	done
done

banner "MANIFEST CHECK SUMMARY"

echo "Failed packages:"
for p in "${failed_packages[@]}"; do
	echo " * ${p}"
done
echo "Ignored packages:"
for p in "${ignored_packages[@]}"; do
	echo " * ${p}"
done

exit ${exit_code}
