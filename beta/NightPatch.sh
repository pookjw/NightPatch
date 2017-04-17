#!/bin/sh
VERSION=52
BUILD=beta

if [[ "${1}" == help || "${1}" == "-help" || "${1}" == "--help" ]]; then
	echo "NightPatch | Version : ${VERSION} ${BUILD}"
	echo "Enable Night Shift on any old Mac models."
	echo
	echo "./NightPatch.sh : Patch your macOS!"
	echo "./NightPatch.sh -revert : Revert from backup."
	echo "./NightPatch.sh -revert -downlaod : Revert using macOS Combo Update. (works without backup)"
	exit 0
fi

function removeTmp(){
	if [[ -f /tmp/NightPatch.zip ]]; then
		rm /tmp/NightPatch.zip
	fi
	if [[ -d /tmp/NightPatch-master ]]; then
		rm -rf /tmp/NightPatch-master
	fi
	if [[ -d /tmp/NightPatch-tmp ]]; then
		echo "Cleaning..."
		if [[ -d /tmp/NightPatch-tmp/macOSUpdate ]]; then
			hdiutil eject /tmp/NightPatch-tmp/macOSUpdate
			if [[ -d /tmp/NightPatch-tmp/macOSUpdate ]]; then
				rm -rf /tmp/NightPatch-tmp/macOSUpdate
			fi
		fi
		rm -rf /tmp/NightPatch-tmp
	fi
}

function revertAll(){
	if [[ -f /Library/NightPatch/NightPatchBuild ]]; then
		if [[ "$(cat /Library/NightPatch/NightPatchBuild)" == "$(sw_vers -buildVersion)" ]]; then
			if [[ ! "${1}" == "-doNotPrint" && ! "${2}" == "-doNotPrint" ]]; then
				echo "Reverting..."
			fi
			sudo cp /Library/NightPatch/CoreBrightness.bak /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
			sudo rm -rf /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/_CodeSignature
			sudo cp -r /Library/NightPatch/_CodeSignature.bak /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/_CodeSignature
			applyPurple
			sudo codesign -f -s - /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
			applyNoColor
			if [[ "${1}" == "-rebootMessage" && "${2}" == "-rebootMessage" ]]; then
				echo "Done. Please reboot your Mac to complete."
			fi
			if [[ ! "${1}" == "-doNotQuit" && ! "${2}" == "-doNotQuit" ]]; then
				quitTool0
			fi
		else
			echo "This backup is not for this macOS. Seems like you've updated your macOS."
			if [[ ! "${1}" == "-doNotQuit" && ! "${2}" == "-doNotQuit" ]]; then
				quitTool1
			fi
		fi
	else
		echo "No backup."
		if [[ ! "${1}" == "-doNotQuit" && ! "${2}" == "-doNotQuit" ]]; then
			quitTool1
		fi
	fi
}

function revertUsingCombo(){
	if [[ -d "combo/$(sw_vers -buildVersion)" ]]; then
		if [[ ! -f "combo/$(sw_vers -buildVersion)/update.dmg" ]]; then
			if [[ ! -f "combo/$(sw_vers -buildVersion)/url.txt" ]]; then
				applyRed
				echo "ERROR : combo/$(sw_vers -buildVersion)/url.txt not found."
				quitTool1
			fi
			if [[ -z "$(cat "combo/$(sw_vers -buildVersion)/url.txt")" ]]; then
				applyRed
				echo "ERROR : combo/$(sw_vers -buildVersion)/url.txt is wrong."
				quitTool1
			fi
			echo "Downloading update..."
			curl -o "combo/$(sw_vers -buildVersion)/update.dmg" "$(cat "combo/$(sw_vers -buildVersion)/url.txt")"
			if [[ ! -f "combo/$(sw_vers -buildVersion)/update.dmg" ]]; then
				applyRed
				echo "ERROR : Failed to download file."
				quitTool1
			fi
			echo "Done."
		fi
		if [[ -d /tmp/NightPatch-tmp ]]; then
			rm -rf /tmp/NightPatch-tmp
		fi
		mkdir /tmp/NightPatch-tmp
		if [[ ! -f /tmp/NightPatch-tmp/pbzx ]]; then
			compilePBZX
			COMPILE_PBZX=YES
		fi
		if [[ ! -f /tmp/NightPatch-tmp/pbzx ]]; then
			applyRed
			echo "ERROR : Failed to compile pbzx."
			quitTool1
		fi
		if [[ "${COMPILE_PBZX}" == YES ]]; then
			echo "Done."
		fi
		if [[ -d /tmp/NightPatch-tmp/macOSUpdate ]]; then
			hdiutil eject /tmp/NightPatch-tmp/macOSUpdate
			if [[ -d /tmp/NightPatch-tmp/macOSUpdate ]]; then
				rm -rf /tmp/NightPatch-tmp/macOSUpdate
			fi
		fi
		hdiutil attach "combo/$(sw_vers -buildVersion)/update.dmg" -mountpoint /tmp/NightPatch-tmp/macOSUpdate
		echo "Extracting... (1)"
		pkgutil --expand /tmp/NightPatch-tmp/macOSUpdate/* /tmp/NightPatch-tmp/1
		cd /tmp/NightPatch-tmp/1/macOSUpdCombo*
		if [[ ! -f Payload ]]; then
			applyRed
			echo "ERROR : Failed to extract pkg file."
			quitTool1
		fi
		mv Payload /tmp/NightPatch-tmp
		if [[ -d /tmp/NightPatch-tmp/2 ]]; then
			rm -rf /tmp/NightPatch-tmp/2
		fi
		mkdir /tmp/NightPatch-tmp/2
		cd /tmp/NightPatch-tmp/2
		echo "Extracting... (2)"
		/tmp/NightPatch-tmp/pbzx -n /tmp/NightPatch-tmp/Payload | cpio -i
		echo "Creating backup from update..."
		if [[ ! -f /tmp/NightPatch-tmp/2/System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness ]]; then
			applyRed
			echo "ERROR : CoreBrightness file not found."
			quitTool1
		fi
		if [[ -d /Library/NightPatch ]]; then
			sudo rm -rf /Library/NightPatch
		fi
		sudo mkdir /Library/NightPatch
		sudo cp /tmp/NightPatch-tmp/2/System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness /Library/NightPatch/CoreBrightness.bak
		sudo cp -r /tmp/NightPatch-tmp/2/System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/_CodeSignature /Library/NightPatch/_CodeSignature.bak
		echo $(sw_vers -buildVersion) >> /tmp/NightPatchBuild
		sudo mv /tmp/NightPatchBuild /Library/NightPatch
		echo "Done. Reverting from backup..."
	else
		applyRed
		echo "ERROR : Your macOS is not supported. ($(sw_vers -buildVersion))"
		quitTool1
	fi
}

# See https://github.com/NiklasRosenstein/pbzx
function compilePBZX(){
	CURRENT_DIR="$(pwd)"
	echo "Downloading pbzx-master... (https://github.com/NiklasRosenstein/pbzx)"
	curl -o /tmp/NightPatch-tmp/pbzx-master.zip https://codeload.github.com/NiklasRosenstein/pbzx/zip/master
	unzip /tmp/NightPatch-tmp/pbzx-master.zip -d /tmp/NightPatch-tmp
	cd /tmp/NightPatch-tmp/pbzx-master
	echo "Compiling pbzx..."
	clang -llzma -lxar -I /usr/local/include pbzx.c -o pbzx
	cp pbzx /tmp/NightPatch-tmp
	cd "${CURRENT_DIR}"
}

function moveOldBackup(){
	applyPurple
	# Version 1~38
	if [[ -d ~/_CodeSignature.bak ]]; then
		if [[ ! -d ~/Library/NightPatch ]]; then
			mkdir ~/Library/NightPatch
		fi
		if [[ -d ~/Library/NightPatch/_CodeSignature.bak ]]; then
			rm -rf ~/Library/NightPatch/_CodeSignature.bak
		fi
		echo "Move : ~/_CodeSignature.bak >> ~/Library/NightPatch"
		mv ~/_CodeSignature.bak ~/Library/NightPatch
	fi
	if [[ -f ~/CoreBrightness.bak ]]; then
		if [[ ! -d ~/Library/NightPatch ]]; then
			mkdir ~/Library/NightPatch
		fi
		if [[ -f ~/Library/NightPatch/CoreBrightness.bak ]]; then
			rm ~/Library/NightPatch/CoreBrightness.bak
		fi
		echo "Move : ~/CoreBrightness.bak >> ~/Library/NightPatch"
		mv ~/CoreBrightness.bak ~/Library/NightPatch
	fi
	if [[ -f ~/NightPatchBuild ]]; then
		if [[ ! -d ~/Library/NightPatch ]]; then
			mkdir ~/Library/NightPatch
		fi
		if [[ -f ~/Library/NightPatch/NightPatchBuild ]]; then
			rm ~/Library/NightPatch/NightPatchBuild
		fi
		echo "Move : ~/NightPatchBuild >> ~/Library/NightPatch"
		mv ~/NightPatchBuild ~/Library/NightPatch
	fi

	# Version 39~40
	if [[ -d ~/Library/NightPatch/_CodeSignature.bak ]]; then
		if [[ ! -d /Library/NightPatch ]]; then
			sudo mkdir /Library/NightPatch
		fi
		if [[ -d /Library/NightPatch/_CodeSignature.bak ]]; then
			sudo rm -rf /Library/NightPatch/_CodeSignature.bak
		fi
		echo "Move : ~/Library/NightPatch/_CodeSignature.bak >> /Library/NightPatch"
		sudo mv ~/Library/NightPatch/_CodeSignature.bak /Library/NightPatch
	fi
	if [[ -f ~/Library/NightPatch/CoreBrightness.bak ]]; then
		if [[ ! -d /Library/NightPatch ]]; then
			sudo mkdir /Library/NightPatch
		fi
		if [[ -f /Library/NightPatch/CoreBrightness.bak ]]; then
			sudo rm /Library/NightPatch/CoreBrightness.bak
		fi
		echo "Move : ~/Library/NightPatch/CoreBrightness.bak >> /Library/NightPatch"
		sudo mv ~/Library/NightPatch/CoreBrightness.bak /Library/NightPatch/CoreBrightness.bak
	fi
	if [[ -f ~/Library/NightPatch/NightPatchBuild ]]; then
		if [[ ! -d /Library/NightPatch ]]; then
			sudo mkdir /Library/NightPatch
		fi
		if [[ -f /Library/NightPatch/NightPatchBuild ]]; then
			sudo rm /Library/NightPatch/NightPatchBuild
		fi
		echo "Move : ~/Library/NightPatch/NightPatchBuild >> /Library/NightPatch"
		sudo mv ~/Library/NightPatch/NightPatchBuild /Library/NightPatch/NightPatchBuild
	fi
	if [[ -d ~/Library/NightPatch ]]; then
		sudo rm -rf ~/Library/NightPatch
	fi
	applyNoColor
}

function checkSHA(){
	if [[ -f "sha/sha-$(sw_vers -buildVersion)_${1}.txt" ]]; then
		if [[ ! "$(cat "sha/sha-$(sw_vers -buildVersion)_${1}.txt")" == "$(shasum /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness | awk '{ print $1 }')" ]]; then
			echo "ERROR : SHA not matching. Patch was failed. (${1}-$(shasum /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness | awk '{ print $1 }'))"
			revertAll -doNotQuit
			quitTool1
		fi
	else
		echo "SHA file not found."
	fi
}

function applyRed(){
	echo "\033[1;31m"
}

function applyLightCyan(){
	echo "\033[1;36m"
}

function applyPurple(){
	echo "\033[1;35m"
}

function applyNoColor(){
	echo "\033[0m"
}

function quitTool0(){
	applyNoColor
	removeTmp
	exit 0
}

function quitTool1(){
	applyNoColor
	removeTmp
	exit 1
}

applyRed
if [[ "$(sw_vers -productVersion | cut -d"." -f2)" -lt 12 ]]; then
	MACOS_ERROR=YES
elif [[ "$(sw_vers -productVersion | cut -d"." -f2)" == 12 ]]; then
	if [[ "$(sw_vers -productVersion | cut -d"." -f3)" -lt 4 ]]; then
		MACOS_ERROR=YES
	fi
fi
if [[ "${MACOS_ERROR}" == YES ]]; then
	echo "Requires macOS 10.12.4 or higher. (Detected version : $(sw_vers -productVersion))"
	quitTool1
fi
if [[ ! "$(csrutil status)" == "System Integrity Protection status: disabled." ]]; then
	echo "ERROR : Turn off System Integrity Protection before doing this."
	quitTool1
fi
moveOldBackup
if [[ "${1}" == "-moveOldBackup" ]]; then
	quitTool0
fi
if [[ "${1}" == "-revert" ]]; then
	if [[ "${2}" == "-download" ]]; then
		revertUsingCombo
	fi
	revertAll -rebootMessage
fi
applyRed
if [[ ! -d patch ]]; then
	echo "patch folder is missing. Try again."
	quitTool1
fi
if [[ ! -f "patch/$(sw_vers -buildVersion).patch" ]]; then
	echo "patch/$(sw_vers -buildVersion).patch is missing. (seems like not supported macOS)"
	quitTool1
fi
applyNoColor
echo "NightPatch.sh by @pookjw. Version : ${VERSION}"
if [[ "${BUILD}" == beta ]]; then
	echo "**WARNING : This is beta version. I don't guarantee of any problems."
	applyLightCyan
	read -s -n 1 -p "Press any key to continue..."
	applyNoColor
fi
sudo touch /System/test
if [[ ! -f /System/test ]]; then
	applyRed
	echo "ERROR : Can't write a file to root."
	quitTool1
fi
sudo rm /System/test
if [[ -f /Library/NightPatch/NightPatchBuild ]]; then
	if [[ "$(cat /Library/NightPatch/NightPatchBuild)" == "$(sw_vers -buildVersion)" ]]; then
		echo "Detected backup. Reverting..."
		revertAll -doNotQuit -doNotPrint
		echo "Patching again..."
	fi
fi
if [[ -d /Library/NightPatch ]]; then
	sudo rm -rf /Library/NightPatch
fi
sudo mkdir /Library/NightPatch
if [[ -f /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness-patch ]]; then
	sudo rm /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness-patch
fi
applyRed
sudo cp /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness /Library/NightPatch/CoreBrightness.bak
sudo cp -r /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/_CodeSignature /Library/NightPatch/_CodeSignature.bak
echo $(sw_vers -buildVersion) >> /tmp/NightPatchBuild
sudo mv /tmp/NightPatchBuild /Library/NightPatch
applyPurple
sudo codesign -f -s - /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
applyRed
if [[ ! "${1}" == "-skipCheckSHA" && ! "${2}" == "-skipCheckSHA" && ! "${3}" == "-skipCheckSHA" ]]; then
	checkSHA original
fi
sudo bspatch /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness-patch patch/$(sw_vers -buildVersion).patch
sudo rm /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
sudo mv /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness-patch /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
sudo chmod +x /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
applyPurple
sudo codesign -f -s - /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
applyRed
if [[ ! "${1}" == "-skipCheckSHA" && ! "${2}" == "-skipCheckSHA" && ! "${3}" == "-skipCheckSHA" ]]; then
	checkSHA patched
fi
applyNoColor
if [[ "${1}" == "-test" || "${2}" == "-test" || "${3}" == "-test" ]]; then
	echo "Original CoreBrightness : $(shasum /Library/NightPatch/CoreBrightness.bak)"
	echo "Patched CoreBrightness : $(shasum /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness)"
	revertAll
fi
echo "Patch was done. Please reboot your Mac to complete."
quitTool0
