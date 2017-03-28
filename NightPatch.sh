#!/bin/sh

function revertAll(){
	if [[ "$(cat ~/NSPatchBuild)" == "$(sw_vers -buildVersion)" ]]; then
		sudo cp ~/CoreBrightness.bak /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
		sudo rm -rf /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/_CodeSignature
		sudo cp -r ~/_CodeSignature.bak /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/_CodeSignature
		exit 0
	else
		echo "This backup is not for this macOS. Seems like you've updated your macOS."
		exit 1
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

if [[ "${1}" == "-revert" ]]; then
	revertAll
fi

MACOS_BUILD="$(sw_vers -buildVersion)"

if [[ ! "${1}" == "-skipAllWarnings" || "${2}" == "-skipAllWarnings" ]]; then
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
		exit 1
	fi
	if [[ ! -f "patch/patch-$(sw_vers -buildVersion)" ]]; then
		echo "patch/patch-$(sw_vers -buildVersion) is missing."
		applyNoColor
		exit 1
	fi
	if [[ ! "$(csrutil status)" == "System Integrity Protection status: disabled." ]]; then
		applyRed
		echo "ERROR : Turn off System Integrity Protection before doing this."
		applyNoColor
		exit 1
	fi
	if [[ ! -f "/Applications/Xcode.app/Contents/version.plist" ]]; then
		echo "ERROR : Please install Xcode from App Store."
		applyNoColor
		exit 1 
	else
		if [[ "$(defaults read /Applications/Xcode.app/Contents/version.plist CFBundleShortVersionString | cut -d"." -f1)" -lt 8 ]]; then
			XCODE_ERROR=YES
		elif [[ "$(defaults read /Applications/Xcode.app/Contents/version.plist CFBundleShortVersionString | cut -d"." -f1)" == 8 && "$(defaults read /Applications/Xcode.app/Contents/version.plist CFBundleShortVersionString | cut -d"." -f2)" -lt 3 ]]; then
			XCODE_ERROR=YES
		fi
		if [[ "${XCODE_ERROR}" == YES ]]; then
			echo "ERROR : Requires Xcode 8.3 or higher. Please Update from App Store."
			applyNoColor
			exit 1
		fi
	fi
	applyNoColor
fi
echo "NightPatch.sh by @pookjw. Version : 4"
echo "\n**WARNING : NSPatch is currently in BETA. I don't guarantee of any problems."
echo "If you got a problem, enter './CBPatch.sh -revert' command to revert files."
applyLightCyan
read -s -n 1 -p "Press any key to continue..."
applyNoColor
sudo touch /System/test
if [[ ! -f /System/test ]]; then
	echo "ERROR : Can't write a file to root."
	exit 1
fi
sudo rm -rf /System/test
if [[ -f ~/CoreBrightness ]]; then
	rm ~/CoreBrightness
fi
if [[ -f ~/CoreBrightness.bak ]]; then
	rm ~/CoreBrightness.bak
fi
if [[ -d ~/_CodeSignature.bak ]]; then
	rm -rf ~/_CodeSignature.bak
fi
if [[ -f ~/NSPatchBuild ]]; then
	rm ~/NSPatchBuild
fi
applyRed
cp /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness ~/CoreBrightness.bak
cp -r /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/_CodeSignature ~/_CodeSignature.bak
bspatch /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness ~/CoreBrightness patch/patch-$(sw_vers -buildVersion)
sudo cp ~/CoreBrightness /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
rm ~/CoreBrightness
chmod +x /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
applyPurple
sudo codesign -f -s - /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness
echo $(sw_vers -buildVersion) >> ~/NSPatchBuild
applyNoColor
if [[ "${1}" == "-test" || "${2}" == "-test" ]]; then
	echo "Original CoreBrightness : $(shasum ~/CoreBrightness.bak)"
	echo "Patched CoreBrightness : $(shasum /System/Library/PrivateFrameworks/CoreBrightness.framework/Versions/A/CoreBrightness)"
	revertAll
	exit 0
fi
echo "Patch was done. Please reboot your Mac to complete."
exit 0
