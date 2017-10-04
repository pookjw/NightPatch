#!/bin/sh
# NightPatch

TOOL_VERSION=200
TOOL_BUILD=beta

function showHelpMessage(){
	echo "NightPatch (Version: ${TOOL_VERSION})"
	echo "Usage: ./NightPatch.sh [mode] [sub options...]"
	echo
	echo "mode:"
	echo "[empty]			Patch macOS"
	echo "--revert		Revert macOS"
	echo "--fix			Fix corrupted macOS System"
	echo
	echo "sub options:"
	echo "--verbose		verbose mode"
	echo "--skipCheckSystem	Skip checking system (macOS version, SIP)"
}

function setDefaultSettings(){
	if [[ "${1}" == "--help" || "${2}" == "--help" || "${3}" == "--help" || "${4}" == "--help" || "${5}" == "--help" || "${6}" == "--help" || "${7}" == "--help" || "${8}" == "--help" || "${9}" == "--help" ]]; then
		showHelpMessage
	fi
	if [[ "${1}" == "-help" || "${2}" == "-help" || "${3}" == "-help" || "${4}" == "-help" || "${5}" == "-help" || "${6}" == "-help" || "${7}" == "-help" || "${8}" == "-help" || "${9}" == "-help" ]]; then
		showHelpMessage
	fi
	if [[ "${1}" == "--revert" || "${2}" == "--revert" || "${3}" == "--revert" || "${4}" == "--revert" || "${5}" == "--revert" || "${6}" == "--revert" || "${7}" == "--revert" || "${8}" == "--revert" || "${9}" == "--revert" ]]; then
		TOOL_MODE=revert
	fi
	if [[ "${1}" == "-revert" || "${2}" == "-revert" || "${3}" == "-revert" || "${4}" == "-revert" || "${5}" == "-revert" || "${6}" == "-revert" || "${7}" == "-revert" || "${8}" == "-revert" || "${9}" == "-revert" ]]; then
		TOOL_MODE=revert
	fi
	if [[ "${1}" == "--fix" || "${2}" == "--fix" || "${3}" == "--fix" || "${4}" == "--fix" || "${5}" == "--fix" || "${6}" == "--fix" || "${7}" == "--fix" || "${8}" == "--fix" || "${9}" == "--fix" ]]; then
		TOOL_MODE=fix
	fi
	if [[ "${1}" == "-fix" || "${2}" == "-fix" || "${3}" == "-fix" || "${4}" == "-fix" || "${5}" == "-fix" || "${6}" == "-fix" || "${7}" == "-fix" || "${8}" == "-fix" || "${9}" == "-fix" ]]; then
		TOOL_MODE=fix
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
	if [[ "${1}" == "--skipCheckSystem" || "${2}" == "--skipCheckSystem" || "${3}" == "--skipCheckSystem" || "${4}" == "--skipCheckSystem" || "${5}" == "--skipCheckSystem" || "${6}" == "--skipCheckSystem" || "${7}" == "--skipCheckSystem" || "${8}" == "--skipCheckSystem" || "${9}" == "--skipCheckSystem" ]]; then
		SKIP_CHECK_SYSTEM=YES
	fi
	if [[ "${1}" == "-skipCheckSystem" || "${2}" == "-skipCheckSystem" || "${3}" == "-skipCheckSystem" || "${4}" == "-skipCheckSystem" || "${5}" == "-skipCheckSystem" || "${6}" == "-skipCheckSystem" || "${7}" == "-skipCheckSystem" || "${8}" == "-skipCheckSystem" || "${9}" == "-skipCheckSystem" ]]; then
		SKIP_CHECK_SYSTEM=YES
	fi
	if [[ "${VERBOSE}" == YES ]]; then
		showLines "*"
		echo "TOOL_MODE=${TOOL_MODE}"
		echo "VERBOSE=${VERBOSE}"
		echo "SKIP_CHECK_SYSTEM=${SKIP_CHECK_SYSTEM}"
		showLines "*"
	fi
	SYSTEM_BUILD="$(sw_vers -buildVersion)"
	SYSTEM_VERSION="$(sw_vers -productVersion)"
}

function patchSystem(){
	:
}

function revertSystem(){
	if [[ -f /Library/NightPatch/NightPatchBuild ]]; then
		if [[ "$(cat /Library/NightPatch/NightPatchBuild)" == "${SYSTEM_BUILD}" ]]; then
			deleteFile /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
			deleteFile /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/_CodeSignature
			sudo cp /Library/NightPatch/CoreBrightness.bak /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
			sudo cp -r /Library/NightPatch/_CodeSignature.bak /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/_CodeSignature
			codesignCB
		else
			echo "This backup is not for this macOS. Seems like you've updated your macOS."
			echo "If you want to download a original macOS system file from Apple, try this command \033[1;31mwithout $\033[0m. (takes a few minutes)"
			showCommandGuide "--fix"
		fi
	else
		echo "\033[1;31mERROR : No backup.\033[0m"
		echo "If you want to download a original macOS system file from Apple, try this command \033[1;31mwithout $\033[0m. (takes a few minutes)"
		echo
		showCommandGuide "--fix"
	fi
}

function fixSystem(){
	if [[ ! -d "$("xcode-select" -p)" ]]; then
		echo "\033[1;31mERROR : Requires Command Line Tool.\033[0m Enter 'xcode-select --install' command to install this."
		quitTool 1
	fi
	if [[ ! -d /usr/local/Cellar/xz ]]; then
		showLines "*"
		echo "\033[1;31mERROR : Requires lzma.\033[0m"
		if [[ "$(pwd)" == /tmp/NightPatch-master ]]; then
			echo "1. Enter 'cd ~' command."
			echo "2. Install Homebrew. See https://brew.sh"
			echo "3. Enter 'brew install xz' command to install lzma."
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
	if [[ "${verbose}" == YES ]]; then
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
	COUNT=1
	while(true); do
		if [[ "${COUNT}" == 3 ]]; then
			echo "ERROR: Failed to unpack update file."
			quitTool 1
		fi
		if [[ ! -f /tmp/NightPatch-tmp/update.pkg ]]; then
			ASSET_CATALOG_URL=$(sudo /System/Library/PrivateFrameworks/Seeding.framework/Versions/A/Resources/seedutil current | grep CatalogURL | cut -d" " -f2)
			if [[ "${VERBOSE}" == YES ]]; then
				echo "ASSET_CATALOG_URL=${ASSET_CATALOG_URL}"
			fi
			curl -o /tmp/NightPatch-tmp/assets.sucatalog.gz "${ASSET_CATALOG_URL}"
			if [[ ! -f /tmp/NightPatch-tmp/assets.sucatalog.gz ]]; then
				echo "ERROR: Failed to download!"
				quitTool 1
			fi
			gunzip /tmp/NightPatch-tmp/assets.sucatalog.gz
			PACKAGE_URL=$(cat /tmp/NightPatch-tmp/assets.sucatalog.gz | grep macOSUpd${SYSTEM_VERSION}.pkg | cut -d">" -f2 | cut -d"<" -f1)
			if [[ "${VERBOSE}" == YES ]]; then
				echo "PACKAGE_URL=${PACKAGE_URL}"
			fi
			deleteFile /tmp/NightPatch-tmp/update.pkg
			curl -o /tmp/NightPatch-tmp/update.pkg "${PACKAGE_URL}"
		fi
		echo "Extracting... (1)"
		pkgutil --expand /tmp/update.pkg /tmp/NightPatch-tmp/1
		cd /tmp/NightPatch-tmp/1
		if [[ ! -f Payload ]]; then
			echo "\033[1;31mERROR : Failed to extract pkg file. Re-downloading...\033[0m"
			rm /tmp/update.pkg
			COUNT=$((${COUNT}+1))
		else
			break
		fi
	done
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
	if [[ -f /tmp/NightPatchBuild ]]; then
		sudo rm /tmp/NightPatchBuild
	fi
	echo "${SYSTEM_BUILD}" >> /tmp/NightPatchBuild
	sudo mv /tmp/NightPatchBuild /Library/NightPatch
	echo "Reverting from backup..."
	revertSystem
}

function codesignCB(){
	if [[ "${VERBOSE}" == YES ]]; then
		sudo codesign -f -s - /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
	else
		sudo codesign -f -s - /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness > /dev/null 2>&1
	fi
	sudo chmod +x /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
}

function deleteFile(){
	if [[ ! -z "${1}" ]]; then
		if [[ -d "${1}" ]]; then
			rm -rf "${1}"
		fi
		if [[ -f "${1}" ]]; then
			rm "${1}"
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
	if [[ "$(pwd)" == /tmp/NightPatch-master ]]; then
		if [[ "${BUILD}" == beta ]]; then
			echo "\033[1;31m$\033[0m cd /tmp; curl -s -o NightPatch.zip https://codeload.github.com/pookjw/NightPatch/zip/master; unzip -o -qq NightPatch.zip; cd NightPatch-master; chmod +x NightPatch-beta.sh; ./NightPatch-beta.sh ${1}"
		else
			echo "\033[1;31m$\033[0m cd /tmp; curl -s -o NightPatch.zip https://codeload.github.com/pookjw/NightPatch/zip/master; unzip -o -qq NightPatch.zip; cd NightPatch-master; chmod +x NightPatch.sh; ./NightPatch.sh ${1}"
		fi
	else
		if [[ "${TOOL_BUILD}" == beta ]]; then
			echo "\033[1;31m$\033[0m ./NightPatch-beta.sh ${1}"
		else
			echo "\033[1;31m$\033[0m ./NightPatch.sh ${1}"
		fi
	fi
}

function quitTool(){
	deleteFile /tmp/NightPatch-tmp
	deleteFile /tmp/NightPatch.zip
	deleteFile /tmp/NightPatch-master
	exit "${1}"
}

setDefaultSettings "${1}" "${2}" "${3}" "${4}" "${5}" "${6}" "${7}" "${8}" "${9}"
checkRoot
if [[ "${TOOL_MODE}" == patch ]]; then
	patchSystem
elif [[ "${TOOL_MODE}" == revert ]]; then
	revertSystem
elif [[ "${TOOL_MODE}" == fix ]]; then
	fixSystem
fi
