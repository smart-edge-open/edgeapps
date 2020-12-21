#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (c) 2020 Intel Corporation

ERROR="${PWD}/.error"
EDGEAPPS_HOME="${PWD}"

# Checks whether the application includes a Makefile and if so, runs it. It also
# checks for a 'make test' command and if it finds it, runs this as well
# $1 Path to the application folder
function check_makefile()
{
	local FOLDER_PATH="$1"
	local MAKEFILE_LOCATION

	MAKEFILE_LOCATION=$(find "${FOLDER_PATH}" -name Makefile)

	echo "Testing Makefile"

	set -x
	make clean
	make
	set +x
	if grep -e 'test:' "${MAKEFILE_LOCATION}"; then
		set -x
		make clean
		make test
		set +x
	fi
	make clean
	echo
}

# Checks what coding language the application uses and performs the necessary style checks
# $1 Path to the application folder
function check_coding_style()
{
	local FOLDER_PATH="$1"

	echo "Checking Coding Style"

	find "${FOLDER_PATH}" -type f | while read -r line; do
		local CHECK_FILE_TYPE
		CHECK_FILE_TYPE=$(echo "$line" | cut -d '.' -f 2-)
		if [ "${CHECK_FILE_TYPE}" == "c" ] || [ "${CHECK_FILE_TYPE}" == "c++" ] || [ "${CHECK_FILE_TYPE}" == "h" ]; then
			local KERNEL_VER
			KERNEL_VER=$(uname -r)
			set -x
			/usr/src/kernels/"${KERNEL_VER}"/scripts/checkpatch.pl --no-tree -f "$line"
			set +x
		elif [ "${CHECK_FILE_TYPE}" == "go" ]; then
			local GO_STYLE_CHECK
			GO_STYLE_CHECK=$(gofmt -d "$line")
			if [ "${GO_STYLE_CHECK}" != "" ]; then
				echo "${GO_STYLE_CHECK}"
				echo "Error: gofmt -d $line detected issues"
				touch "${ERROR}"
				echo
			fi
		elif [ "${CHECK_FILE_TYPE}" == "sh" ]; then
			local SHELL_CHECK_RESULT
			SHELL_CHECK_RESULT=$(shellcheck "$line")
			if [ "${SHELL_CHECK_RESULT}" != "" ]; then
				echo "${SHELL_CHECK_RESULT}"
				echo "Error: shellcheck $line detected issues"
				touch "${ERROR}"
				echo
			fi
		elif [ "${CHECK_FILE_TYPE}" == "py" ]; then
			local PYLINT_RC_FILE="${EDGEAPPS_HOME}/pylint.rc"
			if ! test -f "${PYLINT_RC_FILE}"; then
				pylint --generate-rcfile > "${PYLINT_RC_FILE}"
			fi
			local PYLINT_CHECK_RESULT
			PYLINT_CHECK_RESULT=$(pylint --rcfile="${PYLINT_RC_FILE}" "$line")
			if [ "${PYLINT_CHECK_RESULT}" != "" ]; then
				echo "${PYLINT_CHECK_RESULT}"
				echo "Error: pylint --rcfile=${PYLINT_RC_FILE} $line detected issues"
				touch "${ERROR}"
				echo
			fi
		fi
	done

	if find "${FOLDER_PATH}" -type f | cut -d '.' -f 2- | grep -qe 'go' ; then
		cd "${FOLDER_PATH}" || exit
		if ! golangci-lint run; then
			echo "Error: golangci-lint run detected issues"
			touch "${ERROR}"
		fi
	fi
	echo
}

# Checks that the licence header has been included in the file
# $1 Path to the the file to be checked
# $2 Path to the application folder
# $3 Path to the edgeapps repository
function check_licence_header()
{
	local FILE_PATH="$1"
	local APPLICATION_FOLDER="$2"
	local EDGEAPPS_REPO="$3"

	local HEADER_CHECK_CONDITION1="SPDX-License-Identifier:"
	local HEADER_CHECK_CONDITION2="Apache-2.0"
	local HEADER_CHECK_CONDITION3="Copyright"

	local HEADER_CHECK1
	local HEADER_CHECK2
	local HEADER_CHECK3
	local HEADER_CHECK_RESULT
	local CHECK_FILE_TYPE
	local CHECK_FILE_DOCKER_MAKE
	local CHECK_FILE_PATCH
	local CHECK_FILE_RESULT

	HEADER_CHECK1=$(grep -e "${HEADER_CHECK_CONDITION1}" -c "${FILE_PATH}")
	HEADER_CHECK2=$(grep -e "${HEADER_CHECK_CONDITION2}" -c "${FILE_PATH}")
	HEADER_CHECK3=$(grep -e "${HEADER_CHECK_CONDITION3}" -c "${FILE_PATH}")
	HEADER_CHECK_RESULT=$((HEADER_CHECK1 + HEADER_CHECK2 + HEADER_CHECK3))

	CHECK_FILE_TYPE=$(echo "${FILE_PATH}" | cut -d '.' -f 3 | grep -e 'go' -e 'c' -e 'c++' -e 'h' -e 'yaml' -e 'yml' -e 'sh' -e 'py' -e 'txt' -e 'md')
	CHECK_FILE_DOCKER_MAKE=$(echo "${FILE_PATH}" | grep -e 'Dockerfile' -e 'Makefile')
	CHECK_FILE_PATCH=$(echo "${FILE_PATH}" | cut -d '.' -f 3 | grep -e 'patch')
	CHECK_FILE_RESULT="False"
	if [ -n "${CHECK_FILE_TYPE}" ] && [ -z "${CHECK_FILE_PATCH}" ]; then
		CHECK_FILE_RESULT="True"
	elif [ -n "${CHECK_FILE_DOCKER_MAKE}" ]; then
		CHECK_FILE_RESULT="True"
	fi

	if [ "${HEADER_CHECK_RESULT}" -lt "3" ] && [ "${CHECK_FILE_RESULT}" == "True" ]; then
		local FILE_NAME
		FILE_NAME=$(echo "${FILE_PATH}" | cut -d '.' -f 2-)
		echo "Error: File ${EDGEAPPS_REPO}${APPLICATION_FOLDER}${FILE_NAME} has incorrect licence header"
		touch "${ERROR}"
	fi
}

# Top level build function
function run_ci_build()
{
	local EDGEAPPS_REPO="$PWD"
	local LAST_DIRECTORY_CHECKED=""

	git config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
	git fetch

	for file in $(git diff origin/master --name-only); do
		local PATH_TO_FILE
		PATH_TO_FILE=$(echo "$file" | cut -d '/' -f -2)
		if ! test -d "${PATH_TO_FILE}"; then
			echo "====Checking $file===="

			check_coding_style "${EDGEAPPS_REPO}/$file"

			echo "Checking Licence Headers"
			check_licence_header "./$file" "${EDGEAPPS_REPO}"
			echo
		else
			# Directory found
			if [ "${LAST_DIRECTORY_CHECKED}" == "${PATH_TO_FILE}" ]; then
				continue
			fi

			echo "====Checking $PATH_TO_FILE===="

			cd "${PATH_TO_FILE}" || exit

			# Check 1: search for Makefile
			if find . -type f | grep -e 'Makefile'; then
				check_makefile "${EDGEAPPS_REPO}/${PATH_TO_FILE}"
			fi

			# Check 2: Coding style check
			check_coding_style "${EDGEAPPS_REPO}/${PATH_TO_FILE}"

			# Check 3: licence header check
			echo "Checking Licence Headers"
			find . -type f | while read -r line; do
				check_licence_header "$line" "/${PATH_TO_FILE}" "${EDGEAPPS_REPO}"
			done

			LAST_DIRECTORY_CHECKED="${PATH_TO_FILE}"
			cd "${EDGEAPPS_REPO}" || exit
			echo
		fi
	done
}

# Call build function
run_ci_build

if test -f "${ERROR}"; then
	rm -rf "${ERROR}"
	exit 1
fi
