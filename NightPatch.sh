#!/bin/sh
# NightPatch

TOOL_VERSION=244
TOOL_BUILD=stable
CATALOG_URL="https://swscan.apple.com/content/catalogs/others/index-10.13-10.12-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog.gz"

function showHelpMessage(){
	echo "NightPatch (Version: ${TOOL_BUILD}-${TOOL_VERSION}): Enable Night Shift on any old Mac models."
	echo "Usage: ./NightPatch.sh [mode] [sub options...]"
	echo
	echo "mode:"
	echo "[empty]			Patch macOS"
	echo "--revert		Revert macOS"
	echo "--fix			Fix corrupted macOS system"
	echo "--version		Show tool version"
	echo
	echo "sub options:"
	echo "--verbose		verbose mode"
	echo "--do-not-patch		don't patch macOS"
	echo "--skipCheckSystem	Skip checking system (macOS version, SIP)"
	echo "--skipCheckHW		Skip checking hardware"
	echo "--use-local-cache		use local cache"
}

function setDefaultSettings(){
	if [[ "${1}" == "--help" || "${2}" == "--help" || "${3}" == "--help" || "${4}" == "--help" || "${5}" == "--help" || "${6}" == "--help" || "${7}" == "--help" || "${8}" == "--help" || "${9}" == "--help" ]]; then
		TOOL_MODE=help
	fi
	if [[ "${1}" == "-help" || "${2}" == "-help" || "${3}" == "-help" || "${4}" == "-help" || "${5}" == "-help" || "${6}" == "-help" || "${7}" == "-help" || "${8}" == "-help" || "${9}" == "-help" ]]; then
		TOOL_MODE=help
	fi
	if [[ "${1}" == "--revert" || "${2}" == "--revert" || "${3}" == "--revert" || "${4}" == "--revert" || "${5}" == "--revert" || "${6}" == "--revert" || "${7}" == "--revert" || "${8}" == "--revert" || "${9}" == "--revert" ]]; then
		TOOL_MODE=revert
	fi
	if [[ "${1}" == "-revert" || "${2}" == "-revert" || "${3}" == "-revert" || "${4}" == "-revert" || "${5}" == "-revert" || "${6}" == "-revert" || "${7}" == "-revert" || "${8}" == "-revert" || "${9}" == "-revert" ]]; then
		if [[ "${1}" == "combo" || "${2}" == "combo" || "${3}" == "combo" || "${4}" == "combo" || "${5}" == "combo" || "${6}" == "combo" || "${7}" == "combo" || "${8}" == "combo" || "${9}" == "combo" ]]; then
			TOOL_MODE=fix
		else
			TOOL_MODE=revert
		fi
	fi
	if [[ "${1}" == "--fix" || "${2}" == "--fix" || "${3}" == "--fix" || "${4}" == "--fix" || "${5}" == "--fix" || "${6}" == "--fix" || "${7}" == "--fix" || "${8}" == "--fix" || "${9}" == "--fix" ]]; then
		TOOL_MODE=fix
	fi
	if [[ "${1}" == "-fix" || "${2}" == "-fix" || "${3}" == "-fix" || "${4}" == "-fix" || "${5}" == "-fix" || "${6}" == "-fix" || "${7}" == "-fix" || "${8}" == "-fix" || "${9}" == "-fix" ]]; then
		TOOL_MODE=fix
	fi
	if [[ "${1}" == "--version" || "${2}" == "--version" || "${3}" == "--version" || "${4}" == "--version" || "${5}" == "--version" || "${6}" == "--version" || "${7}" == "--version" || "${8}" == "--version" || "${9}" == "--version" ]]; then
		TOOL_MODE=version
	fi
	if [[ "${1}" == "--test" || "${2}" == "--test" || "${3}" == "--test" || "${4}" == "--test" || "${5}" == "--test" || "${6}" == "--test" || "${7}" == "--test" || "${8}" == "--test" || "${9}" == "--test" ]]; then
		TOOL_MODE=test
	fi
	if [[ -z "${TOOL_MODE}" ]]; then
		TOOL_MODE=patch
	fi
	if [[ "${1}" == "--verbose" || "${2}" == "--verbose" || "${3}" == "--verbose" || "${4}" == "--verbose" || "${5}" == "--verbose" || "${6}" == "--verbose" || "${7}" == "--verbose" || "${8}" == "--verbose" || "${9}" == "--verbose" ]]; then
		VERBOSE=YES
	fi
	if [[ "${1}" == "-verbose" || "${2}" == "-verbose" || "${3}" == "-verbose" || "${4}" == "-verbose" || "${5}" == "-verbose" || "${6}" == "-verbose" || "${7}" == "-verbose" || "${8}" == "-verbose" || "${9}" == "-verbose" ]]; then
		VERBOSE=YES
	fi
	if [[ -z "${VERBOSE}" ]]; then
		VERBOSE=NO
	fi
	if [[ "${1}" == "--skipCheckSystem" || "${2}" == "--skipCheckSystem" || "${3}" == "--skipCheckSystem" || "${4}" == "--skipCheckSystem" || "${5}" == "--skipCheckSystem" || "${6}" == "--skipCheckSystem" || "${7}" == "--skipCheckSystem" || "${8}" == "--skipCheckSystem" || "${9}" == "--skipCheckSystem" ]]; then
		SKIP_CHECK_SYSTEM=YES
	fi
	if [[ "${1}" == "-skipCheckSystem" || "${2}" == "-skipCheckSystem" || "${3}" == "-skipCheckSystem" || "${4}" == "-skipCheckSystem" || "${5}" == "-skipCheckSystem" || "${6}" == "-skipCheckSystem" || "${7}" == "-skipCheckSystem" || "${8}" == "-skipCheckSystem" || "${9}" == "-skipCheckSystem" ]]; then
		SKIP_CHECK_SYSTEM=YES
	fi
	if [[ -z "${SKIP_CHECK_SYSTEM}" ]]; then
		SKIP_CHECK_SYSTEM=NO
	fi
	if [[ "${1}" == "--do-not-patch" || "${2}" == "--do-not-patch" || "${3}" == "--do-not-patch" || "${4}" == "--do-not-patch" || "${5}" == "--do-not-patch" || "${6}" == "--do-not-patch" || "${7}" == "--do-not-patch" || "${8}" == "--do-not-patch" || "${9}" == "--do-not-patch" ]]; then
		DO_NOT_PATCH=YES
	fi
	if [[ -z "${DO_NOT_PATCH}" ]]; then
		DO_NOT_PATCH=NO
	fi
	if [[ "${1}" == "--skipCheckHW" || "${2}" == "--skipCheckHW" || "${3}" == "--skipCheckHW" || "${4}" == "--skipCheckHW" || "${5}" == "--skipCheckHW" || "${6}" == "--skipCheckHW" || "${7}" == "--skipCheckHW" || "${8}" == "--skipCheckHW" || "${9}" == "--skipCheckHW" ]]; then
		SKIP_CHECK_HW=YES
	fi
	if [[ -z "${SKIP_CHECK_HW}" ]]; then
		SKIP_CHECK_HW=NO
	fi
	if [[ "${1}" == "--use-local-cache" || "${2}" == "--use-local-cache" || "${3}" == "--use-local-cache" || "${4}" == "--use-local-cache" || "${5}" == "--use-local-cache" || "${6}" == "--use-local-cache" || "${7}" == "--use-local-cache" || "${8}" == "--use-local-cache" || "${9}" == "--use-local-cache" ]]; then
		USE_LOCAL_CACHE=YES
	fi
	if [[ -z "${USE_LOCAL_CACHE}" ]]; then
		USE_LOCAL_CACHE=NO
	fi
	SYSTEM_BUILD="$(sw_vers -buildVersion)"
	SYSTEM_VERSION="$(sw_vers -productVersion)"
	MACHINE_MODEL="$(sysctl -n hw.model)"
	#############################################################
	if [[ "$(echo "${SYSTEM_VERSION}" | cut -d"." -f2)" == 13 ]]; then
		if [[ -z "$(echo "${SYSTEM_VERSION}" | cut -d"." -f3)" ]]; then # for 10.13
			PATCH_COUNT=6
		else
			if [ "$(echo "${SYSTEM_VERSION}" | cut -d"." -f3)" -ge 2 ]; then
				PATCH_COUNT=7 # for 10.13.2 or later < 10.14
			else
				PATCH_COUNT=6 # for 10.13.1
			fi
		fi
	elif [ "$(echo "${SYSTEM_VERSION}" | cut -d"." -f2)" -gt 13 ]; then # for 10.14 or later
		PATCH_COUNT=7
	else
		PATCH_COUNT=6 # for 10.12.4 or later < 10.13
	fi
	#############################################################
	if [[ "${VERBOSE}" == YES ]]; then
		showLines "*"
		echo "TOOL_VERSION=${TOOL_VERSION}"
		echo "TOOL_BUILD=${TOOL_BUILD}"
		echo "SYSTEM_BUILD=${SYSTEM_BUILD}"
		echo "SYSTEM_VERSION=${SYSTEM_VERSION}"
		echo "MACHINE_MODEL=${MACHINE_MODEL}"
		echo "PATCH_COUNT=${PATCH_COUNT}"
		echo "TOOL_MODE=${TOOL_MODE}"
		echo "VERBOSE=${VERBOSE}"
		echo "SKIP_CHECK_SYSTEM=${SKIP_CHECK_SYSTEM}"
		echo "SKIP_CHECK_HW=${SKIP_CHECK_HW}"
		echo "USE_LOCAL_CACHE=${USE_LOCAL_CACHE}"
		echo "PWD=${PWD}"
		showLines "*"
	fi
}

function runTestMode(){
	# from https://raw.githubusercontent.com/Homebrew/install/master/install
	if [[ ! -d "$("xcode-select" -p)" ]]; then
		CLT_LABEL="$(softwareupdate -l | grep -B 1 -E "Command Line (Developer|Tools)" | awk -F"*" '/^ +\\*/ {print $2}' | sed 's/^ *//' | tail -n1)"
		sudo /usr/sbin/softwareupdate -i ${CLT_LABEL}
		deleteFile "/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"
		sudo /usr/bin/xcode-select --switch /Library/Developer/CommandLineTools
	fi
}

function patchSystem(){
	# code from https://github.com/aonez/NightShiftPatcher
	if [[ -f /Library/NightPatch/NightPatchBuild ]]; then
		if [[ "$(cat /Library/NightPatch/NightPatchBuild)" == "${SYSTEM_BUILD}" ]]; then
			echo "Detected backup, reverting..."
			revertSystem > /dev/null
		fi
	fi
	echo "Creating backup..."
	deleteFile /Library/NightPatch
	sudo mkdir -p /Library/NightPatch
	sudo cp /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness /Library/NightPatch/CoreBrightness.bak
	sudo cp -r /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/_CodeSignature /Library/NightPatch/_CodeSignature.bak
	deleteFile /tmp/NightPatchBuild
	echo "${SYSTEM_BUILD}" >> /tmp/NightPatchBuild
	sudo mv /tmp/NightPatchBuild /Library/NightPatch
	echo "Patching..."
	FIRST_SHA="$(shasum /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness | awk '{ print $1 }')"
	if [[ "${VERBOSE}" == YES ]]; then
		echo "FIRST_SHA=${FIRST_SHA}"
	fi
	CB_OFFSET="0x$(nm /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness | grep _ModelMinVersion | cut -d' ' -f 1 | sed -e 's/^0*//g')"
	if [[ "${VERBOSE}" == YES ]]; then
		echo "CB_OFFSET=${CB_OFFSET}"
		patchCB
	else
		patchCB > /dev/null 2>&1
	fi
	SECOND_SHA="$(shasum /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness | awk '{ print $1 }')"
	if [[ "${VERBOSE}" == YES ]]; then
		echo "SECOND_SHA=${SECOND_SHA}"
	fi
	if [[ "${FIRST_SHA}" == "${SECOND_SHA}" ]]; then
		echo "\033[1;31mERROR : Faild to patch system file.\033[0m"
		quitTool 1
	fi
	codesignCB
	echo "Done. Reboot your macOS."
}

function patchCB(){
	if [[ "${PATCH_COUNT}" == 6 ]]; then
		printf "\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00" | sudo dd count=24 bs=1 seek=${CB_OFFSET} of=/System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness conv=notrunc
	elif [[ "${PATCH_COUNT}" == 7 ]]; then
		printf "\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00\x01\x00\x00\x00" | sudo dd count=28 bs=1 seek=${CB_OFFSET} of=/System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness conv=notrunc
	fi
}

function revertSystem(){
	if [[ -f /Library/NightPatch/NightPatchBuild ]]; then
		if [[ "$(cat /Library/NightPatch/NightPatchBuild)" == "${SYSTEM_BUILD}" ]]; then
			echo "Reverting..."
			deleteFile /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
			deleteFile /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/_CodeSignature
			sudo cp /Library/NightPatch/CoreBrightness.bak /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
			sudo cp -r /Library/NightPatch/_CodeSignature.bak /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/_CodeSignature
			codesignCB
			echo "Done. Reboot your macOS."
		else
			echo "This backup is not for this macOS. Seems like you've updated your macOS."
			echo "If you want to download a original macOS system file from Apple, try this command \033[1;31mwithout $\033[0m. (takes a few minutes)"
			showCommandGuide "--fix"
			quitTool 1
		fi
	else
		echo "\033[1;31mERROR : No backup.\033[0m"
		echo "If you want to download a original macOS system file from Apple, try this command \033[1;31mwithout $\033[0m. (takes a few minutes)"
		echo
		showCommandGuide "--fix"
		quitTool 1
	fi
}

function fixSystem(){
	if [[ ! -d /usr/local/Cellar/xz ]]; then
		showLines "*"
		echo "\033[1;31mERROR : Requires lzma.\033[0m"
		if [[ "${PWD}" == /tmp/NightPatch-master  || "${PWD}" == /private/tmp/NightPatch-master ]]; then
			echo "1. Enter 'cd ~' command."
			echo "2. Install Homebrew. See https://brew.sh"
			echo "3. Enter 'cd ~; brew install xz' command to install lzma."
		else
			echo "1. Install Homebrew. See https://brew.sh"
			echo "2. Enter 'brew install xz' command to install lzma."
		fi
		showLines "*"
		quitTool 1
	fi
	deleteFile /tmp/NightPatch-tmp
	mkdir -p /tmp/NightPatch-tmp
	echo "Downloading pbzx-master... (https://github.com/NiklasRosenstein/pbzx)"
	if [[ "${VERBOSE}" == YES ]]; then
		curl -o /tmp/NightPatch-tmp/pbzx-master.zip https://codeload.github.com/NiklasRosenstein/pbzx/zip/master
		unzip -o /tmp/NightPatch-tmp/pbzx-master.zip -d /tmp/NightPatch-tmp
	else
		curl -# -o /tmp/NightPatch-tmp/pbzx-master.zip https://codeload.github.com/NiklasRosenstein/pbzx/zip/master
		unzip -o /tmp/NightPatch-tmp/pbzx-master.zip -d /tmp/NightPatch-tmp > /dev/null 2>&1
	fi
	cd /tmp/NightPatch-tmp/pbzx-master
	echo "Compiling pbzx..."
	clang -llzma -lxar -I /usr/local/include pbzx.c -o pbzx
	cp pbzx /tmp/NightPatch-tmp
	if [[ ! -f /tmp/NightPatch-tmp/pbzx ]]; then
		echo "\033[1;31mERROR : Failed to compile pbzx.\033[0m"
		quitTool 1
	fi
	if [[ ! "${USE_LOCAL_CACHE}" == YES || ! -f /tmp/update.pkg ]]; then
		CURRENT_ENROLLED_SEED=$(sudo /System/Library/PrivateFrameworks/Seeding.framework/Versions/A/Resources/seedutil current | grep "Currently enrolled in" | cut -d" " -f4)
		if [[ "${VERBOSE}" == YES ]]; then
			sudo /System/Library/PrivateFrameworks/Seeding.framework/Versions/A/Resources/seedutil current
			echo "CURRENT_ENROLLED_SEED=${CURRENT_ENROLLED_SEED}"
			if [[ "${CURRENT_ENROLLED_SEED}" == "(null)" ]]; then
				sudo /System/Library/PrivateFrameworks/Seeding.framework/Versions/A/Resources/seedutil enroll DeveloperSeed
			fi
		else
			if [[ "${CURRENT_ENROLLED_SEED}" == "(null)" ]]; then
				sudo /System/Library/PrivateFrameworks/Seeding.framework/Versions/A/Resources/seedutil enroll DeveloperSeed > /dev/null 2>&1
			fi
		fi
		ASSET_CATALOG_URL=$(sudo /System/Library/PrivateFrameworks/Seeding.framework/Versions/A/Resources/seedutil current | grep CatalogURL | cut -d" " -f2)
		if [[ -z "$ASSET_CATALOG_URL" || "$ASSET_CATALOG_URL" == "(null)" ]]; then
			echo "\033[1;31mERROR : Failed to get catalog url.\033[0m"
			quitTool 1
		fi
		if [[ "${VERBOSE}" == YES ]]; then
			sudo /System/Library/PrivateFrameworks/Seeding.framework/Versions/A/Resources/seedutil current
			echo "ASSET_CATALOG_URL=${ASSET_CATALOG_URL}"
		fi
		for URL in ${ASSET_CATALOG_URL} ${CATALOG_URL}; do
			echo "Downloading catalog..."
			deleteFile /tmp/NightPatch-tmp/assets.sucatalog.gz
			if [[ "${VERBOSE}" == YES ]]; then
				curl -o /tmp/NightPatch-tmp/assets.sucatalog.gz "${URL}"
			else
				curl -# -o /tmp/NightPatch-tmp/assets.sucatalog.gz "${URL}"
			fi
			if [[ ! -f /tmp/NightPatch-tmp/assets.sucatalog.gz ]]; then
				echo "\033[1;31mERROR : Failed to download!\033[0m"
				quitTool 1
			fi
			echo "Parsing catalog..."
			deleteFile /tmp/NightPatch-tmp/assets.sucatalog
			gunzip /tmp/NightPatch-tmp/assets.sucatalog.gz
			PACKAGE_URL_1=$(cat /tmp/NightPatch-tmp/assets.sucatalog | grep macOSUpd${SYSTEM_VERSION}.pkg | cut -d">" -f2 | cut -d"<" -f1)
			for VALUE in ${PACKAGE_URL_1}; do
				PACKAGE_URL_2="${VALUE}"
			done
			if [[ "${VERBOSE}" == YES ]]; then
				echo "PACKAGE_URL_1=${PACKAGE_URL_1}"
				echo "PACKAGE_URL_2=${PACKAGE_URL_2}"
			fi
			if [[ ! -z "${PACKAGE_URL_2}" ]]; then
				break
			fi
		done
		if [[ "${CURRENT_ENROLLED_SEED}" == "(null)" ]]; then
			if [[ "${VERBOSE}" == YES ]]; then
				sudo /System/Library/PrivateFrameworks/Seeding.framework/Versions/A/Resources/seedutil unenroll
				sudo /System/Library/PrivateFrameworks/Seeding.framework/Versions/A/Resources/seedutil current
			else
				sudo /System/Library/PrivateFrameworks/Seeding.framework/Versions/A/Resources/seedutil unenroll > /dev/null 2>&1
			fi
		fi
		if [[ -z "${PACKAGE_URL_2}" ]]; then
			echo "\033[1;31mERROR : macOS $SYSTEM_VERSION is not supported for '--fix' option. Update to latest macOS.\033[0m"
			quitTool 1
		fi 
		deleteFile /tmp/update.pkg
		echo "Downloading update file..."
		if [[ "${VERBOSE}" == YES ]]; then
			curl -o /tmp/update.pkg "${PACKAGE_URL_2}"
		else
			curl -# -o /tmp/update.pkg "${PACKAGE_URL_2}"
		fi
	fi
	echo "Extracting... (1)"
	deleteFile /tmp/NightPatch-tmp/1
	pkgutil --expand /tmp/update.pkg /tmp/NightPatch-tmp/1
	cd /tmp/NightPatch-tmp/1
	if [[ ! -f Payload ]]; then
		echo "\033[1;31mERROR : Failed to extract pkg file.\033[0m"
		quitTool 1
	fi
	mv Payload /tmp/NightPatch-tmp
	mkdir -p /tmp/NightPatch-tmp/2
	cd /tmp/NightPatch-tmp/2
	echo "Extracting... (2)"
	if [[ "${VERBOSE}" == YES ]]; then
		/tmp/NightPatch-tmp/pbzx -n /tmp/NightPatch-tmp/Payload | cpio -i
	else
		/tmp/NightPatch-tmp/pbzx -n /tmp/NightPatch-tmp/Payload | cpio -i > /dev/null 2>&1
	fi
	echo "Creating backup from update..."
	checkRoot
	if [[ ! -f /tmp/NightPatch-tmp/2/System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness ]]; then
		echo "\033[1;31mERROR : CoreBrightness file not found.\033[0m"
		quitTool 1
	fi
	if [[ -d /Library/NightPatch ]]; then
		sudo rm -rf /Library/NightPatch
	fi
	sudo mkdir /Library/NightPatch
	sudo cp /tmp/NightPatch-tmp/2/System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness /Library/NightPatch/CoreBrightness.bak
	sudo cp -r /tmp/NightPatch-tmp/2/System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/_CodeSignature /Library/NightPatch/_CodeSignature.bak
	deleteFile /tmp/NightPatchBuild
	echo "${SYSTEM_BUILD}" >> /tmp/NightPatchBuild
	sudo mv /tmp/NightPatchBuild /Library/NightPatch
	echo "Replacing..."
	revertSystem > /dev/null
	echo "Done. Reboot your macOS."
	echo "Cleaning up..."
}

function codesignCB(){
	if [[ "${VERBOSE}" == YES ]]; then
		if [[ -f /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness.tbd ]]; then
			echo "Detected CoreBrightness.tbd, removing..."
		fi
		deleteFile /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness.tbd
		sudo codesign -f -s - /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
	else
		deleteFile /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness.tbd
		sudo codesign -f -s - /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness > /dev/null 2>&1
	fi
	sudo chmod +x /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
}

function deleteFile(){
	if [[ ! -z "${1}" ]]; then
		if [[ -d "${1}" ]]; then
			if [[ "${2}" == -n ]]; then
				rm -rf "${1}"
			else
				sudo rm -rf "${1}"
			fi
		fi
		if [[ -f "${1}" ]]; then
			if [[ "${2}" == -n ]]; then
				rm "${1}"
			else
				sudo rm "${1}"
			fi
		fi
	fi
}

function showLines(){
	PRINTED_COUNTS=0
	COLS=`tput cols`
	if [ "${COLS}" -ge 1 ]; then
		while [[ ! ${PRINTED_COUNTS} == $COLS ]]; do
			printf "${1}"
			PRINTED_COUNTS=$((${PRINTED_COUNTS}+1))
		done
		echo
	fi
}

function checkHardware(){
	# compatibility list from https://pikeralpha.wordpress.com/2017/11/06/supported-mac-models-for-night-shift-in-high-sierra-10-13-2/
	###############
	# MacBookPro9,x
	# iMacPro1,x
	# iMac13,x
	# Macmini6,x
	# MacBookAir5,x
	# MacPro6,x
	# MacBook8,x
	###############
	if [[ ! -z "$(echo "${MACHINE_MODEL}" | grep "MacBookPro")" ]]; then
		if [[ "$(echo "${MACHINE_MODEL}" | cut -d"o" -f4 | cut -d"," -f1)" -ge 9 ]]; then
			HW_ERROR=YES
		fi
	elif [[ ! -z "$(echo "${MACHINE_MODEL}" | grep "iMacPro")" ]]; then
		HW_ERROR=YES
	elif [[ ! -z "$(echo "${MACHINE_MODEL}" | grep "iMac")" ]]; then
		if [[ "$(echo "${MACHINE_MODEL}" | cut -d"c" -f2 | cut -d"," -f1)" -ge 13 ]]; then
			HW_ERROR=YES
		fi
	elif [[ ! -z "$(echo "${MACHINE_MODEL}" | grep "Macmini")" ]]; then
		if [[ "$(echo "${MACHINE_MODEL}" | cut -d"i" -f3 | cut -d"," -f1)" -ge 6 ]]; then
			HW_ERROR=YES
		fi
	elif [[ ! -z "$(echo "${MACHINE_MODEL}" | grep "MacBookAir")" ]]; then
		if [[ "$(echo "${MACHINE_MODEL}" | cut -d"r" -f2 | cut -d"," -f1)" -ge 5 ]]; then
			HW_ERROR=YES
		fi
	elif [[ ! -z "$(echo "${MACHINE_MODEL}" | grep "MacPro")" ]]; then
		if [[ "$(echo "${MACHINE_MODEL}" | cut -d"o" -f2 | cut -d"," -f1)" -ge 6 ]]; then
			HW_ERROR=YES
		fi
	elif [[ ! -z "$(echo "${MACHINE_MODEL}" | grep "MacBook")" ]]; then
		if [[ "$(echo "${MACHINE_MODEL}" | cut -d"k" -f2 | cut -d"," -f1)" -ge 8 ]]; then
			HW_ERROR=YES
		fi
	fi
	if [[ "${HW_ERROR}" == YES ]]; then
		echo "\033[1;31mERROR : Your macOS already supports Night Shift by default.\033[0m (Detected hardware : ${MACHINE_MODEL}) If you want to ignore this warning, try this command \033[1;31mwithout $\033[0m."
		showCommandGuide "--skipCheckHW"
		quitTool 1
	fi
}

function checkSystem(){
	if [[ "$(echo "${SYSTEM_VERSION}" | cut -d"." -f2)" -lt 12 ]]; then
		MACOS_ERROR=YES
	elif [[ "$(echo "${SYSTEM_VERSION}" | cut -d"." -f2)" == 12 ]]; then
		if [[ "$(echo "${SYSTEM_VERSION}" | cut -d"." -f3)" -lt 4 ]]; then
			MACOS_ERROR=YES
		fi
	fi
	if [[ "${MACOS_ERROR}" == YES ]]; then
		echo "\033[1;31mERROR : Requires macOS 10.12.4 or higher.\033[0m (Detected version : ${SYSTEM_VERSION})"
		quitTool 1
	fi
	if [[ "$(csrutil status | grep "System Integrity Protection status: disabled." | wc -l)" == "       0" && "$(csrutil status | grep "Filesystem Protections: disabled" | wc -l)" == "       0" ]]; then
		echo "\033[1;31mERROR : Turn off System Integrity Protection before doing this.\033[0m"
		echo "See http://apple.stackexchange.com/a/209530"
		quitTool 1
	fi
	if [[ ! -d "$("xcode-select" -p)" ]]; then
		echo "\033[1;31mERROR : Requires Command Line Tool.\033[0m Enter 'xcode-select --install' command to install this."
		quitTool 1
	fi
}

function checkRoot(){
	ROOT_COUNT=0
	if [[ ! -f /System/test ]]; then
		while [[ ! ${ROOT_COUNT} == 15 ]]; do
			sudo touch /System/test
			if [[ -f /System/test ]]; then
				sudo rm /System/test
				break
			else
				ROOT_COUNT=$((${ROOT_COUNT}+3))
				echo "\033[1;31mERROR : Can't write a file to root.\033[0m"
				if [[ "${ROOT_COUNT}" == 15 ]]; then
					echo "\033[1;31mERROR : Failed to login.\033[0m (${ROOT_COUNT}/15)"
					quitTool 1
				else
					echo "\033[1;31mEnter your login password CORRECTLY!!!\033[0m (${ROOT_COUNT}/15)"
				fi
			fi
		done
	else
		while [[ ! ${ROOT_COUNT} == 15 ]]; do
			sudo rm /System/test
			if [[ ! -f /System/test ]]; then
				break
			else
				ROOT_COUNT=$((${ROOT_COUNT}+3))
				echo "\033[1;31mERROR : Can't write a file to root.\033[0m"
				if [[ "${ROOT_COUNT}" == 15 ]]; then
					echo "\033[1;31mERROR : Failed to login.\033[0m (${ROOT_COUNT}/15)"
					quitTool 1
				else
					echo "\033[1;31mEnter your login password CORRECTLY!!!\033[0m (${ROOT_COUNT}/15)"
				fi
			fi
		done
	fi
}

function showCommandGuide(){
	if [[ "${PWD}" == /tmp/NightPatch-master  || "${PWD}" == /private/tmp/NightPatch-master ]]; then
		if [[ "${TOOL_BUILD}" == beta ]]; then
			echo "\033[1;31m$\033[0m cd /tmp; curl -s -o NightPatch.zip https://codeload.github.com/pookjw/NightPatch/zip/master; unzip -o -qq NightPatch.zip; cd NightPatch-master; chmod +x NightPatch-beta.sh; sudo ./NightPatch-beta.sh ${1}"
		else
			echo "\033[1;31m$\033[0m cd /tmp; curl -s -o NightPatch.zip https://codeload.github.com/pookjw/NightPatch/zip/master; unzip -o -qq NightPatch.zip; cd NightPatch-master; chmod +x NightPatch.sh; sudo ./NightPatch.sh ${1}"
		fi
	else
		if [[ "${TOOL_BUILD}" == beta ]]; then
			echo "\033[1;31m$\033[0m sudo ./NightPatch-beta.sh ${1}"
		else
			echo "\033[1;31m$\033[0m sudo ./NightPatch.sh ${1}"
		fi
	fi
}

function quitTool(){
	if [[ "${VERBOSE}" == YES ]]; then
		echo "Exit code: ${1}"
	fi
	if [[ "${2}" == "--do-not-clean" ]]; then
		if [[ "${VERBOSE}" == YES ]]; then
			echo "--do-not-clean was defined as YES."
		fi
	else
		deleteFile /tmp/NightPatch-tmp -n
		deleteFile /tmp/NightPatch.zip -n
		deleteFile /tmp/NightPatch-master -n
	fi
	exit "${1}"
}

#########################################################################

setDefaultSettings "${1}" "${2}" "${3}" "${4}" "${5}" "${6}" "${7}" "${8}" "${9}"

if [[ "${TOOL_MODE}" == help ]]; then
	showHelpMessage
	quitTool 0 --do-not-clean
elif [[ "${TOOL_MODE}" == version ]]; then
	echo "${TOOL_BUILD}-${TOOL_VERSION}"
	quitTool 0 --do-not-clean
fi

if [[ ! "${SKIP_CHECK_HW}" == YES ]]; then
	checkHardware
fi
if [[ ! "${SKIP_CHECK_SYSTEM}" == YES ]]; then
	checkSystem
fi
checkRoot

if [[ "${TOOL_MODE}" == patch ]]; then
	if [[ "${DO_NOT_PATCH}" == YES ]]; then
		echo "DO_NOT_PATCH=YES"
	else
		patchSystem
	fi
	quitTool 0
elif [[ "${TOOL_MODE}" == revert ]]; then
	revertSystem
	quitTool 0
elif [[ "${TOOL_MODE}" == fix ]]; then
	fixSystem
	quitTool 0
elif [[ "${TOOL_MODE}" == test ]]; then
	runTestMode
	quitTool 0
fi
