#!/bin/sh

function removeTmp(){
	if [[ -f /tmp/NightPatch.zip ]]; then
		rm /tmp/NightPatch.zip
	fi
	if [[ -d /tmp/NightPatch-master ]]; then
		rm -rf /tmp/NightPatch-master
	fi
}

function revertAll(){
	if [[ -f ~/NightPatchBuild ]]; then
		if [[ "$(cat ~/NightPatchBuild)" == "$(sw_vers -buildVersion)" ]]; then
			if [[ ! "${1}" == "-doNotPrint" && ! "${2}" == "-doNotPrint" ]]; then
				echo "Reverting..."
			fi
			sudo cp ~/CoreBrightness.bak /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
			sudo rm -rf /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/_CodeSignature
			sudo cp -r ~/_CodeSignature.bak /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/_CodeSignature
			applyPurple
			sudo codesign -f -s - /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
			applyNoColor
			if [[ ! "${1}" == "-doNotQuit" && ! "${2}" == "-doNotQuit" ]]; then
				quitTool0
			fi
		else
			echo "This backup is not for this macOS. Seems like you've updated your macOS."
			quitTool1
		fi
	else
		echo "No backup."
		quitTool1
	fi
}

function checkSHA(){
	if [[ -f "sha/sha-$(sw_vers -buildVersion)_${1}.txt" ]]; then
		if [[ -z "$(cat "sha/sha-$(sw_vers -buildVersion)_${1}.txt")" || ! "$(cat "sha/sha-$(sw_vers -buildVersion)_${1}.txt")" == "$(shasum /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness | awk '{ print $1 }')" ]]; then
			echo "SHA not matching. Patch was failed. (${1}-$(shasum /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness | awk '{ print $1 }'))"
			revertAll
			quitTool1
		fi
	else
		echo "sha not found."
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
	removeTmp
	exit 0
}

function quitTool1(){
	removeTmp
	exit 1
}

if [[ "${1}" == "-revert" ]]; then
	revertAll
fi

if [[ ! "${1}" == "-skipAllWarnings" && ! "${2}" == "-skipAllWarnings" ]]; then
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
		applyNoColor
		quitTool1
	fi
	if [[ ! -f "patch/patch-$(sw_vers -buildVersion)" ]]; then
		echo "patch/patch-$(sw_vers -buildVersion) is missing. (seems like not supported macOS)"
		applyNoColor
		quitTool1
	fi
	if [[ ! "$(csrutil status)" == "System Integrity Protection status: disabled." ]]; then
		applyRed
		echo "ERROR : Turn off System Integrity Protection before doing this."
		applyNoColor
		quitTool1
	fi
	applyNoColor
fi
echo "NightPatch.sh by @pookjw. Version : 33"
echo "**WARNING : NightPatch is currently in BETA. I don't guarantee of any problems."
applyLightCyan
read -s -n 1 -p "Press any key to continue..."
applyNoColor
sudo touch /System/test
if [[ ! -f /System/test ]]; then
	echo "ERROR : Can't write a file to root."
	quitTool1
fi
sudo rm /System/test
if [[ -f ~/NightPatchBuild ]]; then
	if [[ "$(cat ~/NightPatchBuild)" == "$(sw_vers -buildVersion)" ]]; then
		echo "Detected backup. Reverting..."
		revertAll -doNotQuit -doNotPrint
		echo "Patching again..."
	fi
fi
if [[ -f ~/CoreBrightness.bak ]]; then
	rm ~/CoreBrightness.bak
fi
if [[ -d ~/_CodeSignature.bak ]]; then
	rm -rf ~/_CodeSignature.bak
fi
if [[ -f ~/NightPatchBuild ]]; then
	rm ~/NightPatchBuild
fi
if [[ -f /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness-patch ]]; then
	sudo rm /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness-patch
fi
applyRed
cp /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness ~/CoreBrightness.bak
cp -r /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/_CodeSignature ~/_CodeSignature.bak
echo $(sw_vers -buildVersion) >> ~/NightPatchBuild
applyPurple
sudo codesign -f -s - /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
applyRed
checkSHA original
sudo bspatch /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness-patch patch/patch-$(sw_vers -buildVersion)
sudo rm /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
sudo mv /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness-patch /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
sudo chmod +x /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
applyPurple
sudo codesign -f -s - /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
applyRed
checkSHA patched
applyNoColor
if [[ "${1}" == "-test" || "${2}" == "-test" ]]; then
	echo "Original CoreBrightness : $(shasum ~/CoreBrightness.bak)"
	echo "Patched CoreBrightness : $(shasum /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness)"
	revertAll
fi
echo "Patch was done. Please reboot your Mac to complete."
quitTool0
