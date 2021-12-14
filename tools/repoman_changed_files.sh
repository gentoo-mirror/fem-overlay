#!/bin/bash

cd "$(dirname "${0}")/.."

: ${COMPARE_TO:=origin/master}

die() {
	echo "*** ERR *** $*"
	exit 1
}

dirs="$(git diff ${COMPARE_TO} --name-only | xargs dirname | grep -v "\." | uniq | grep -E "^[^/]*/[^/]*$" | uniq | xargs)"
exit_code=0
failed_packages=()

echo "Checking packages:"
for d in ${dirs}; do
	pushd ${d} >/dev/null || continue
	echo " * ${d}"
	output="$(repoman full -dx)"
	if [[ "$?" != "0" ]]; then
		failed_packages+=( $d )
		echo "*** FAILED PACKAGE: ${d} ***"
		echo "${output}"
		echo "****************************"
		exit_code=1
	fi
	popd >/dev/null
done

echo "Failed packages:"
for p in "${failed_packages[@]}"; do
	echo " * ${p}"
done

exit ${exit_code}
