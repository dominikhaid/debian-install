#!/bin/bash
#shopt -s nullglob dotglob
##
# AppImages
##
source $SCRIPTPATH/scripts/setIndicator.sh

appimages() {
	download() {
		if ! [ -d "$USER_HOME/Applications" ]; then
			mkdir -p $USER_HOME/Applications
		fi

		if ! [ -f "$USER_HOME/Applications/FontBase-2.16.4.AppImage" ]; then
			wget https://releases.fontba.se/linux/FontBase-2.16.4.AppImage -P $USER_HOME/Applications
		fi

		if ! [ -f "$USER_HOME/Applications/webcatalog-35.1.1.AppImage" ]; then
			wget https://github.com/webcatalog/webcatalog-app/releases/download/v35.1.1/webcatalog-35.1.1.AppImage \
				-P $USER_HOME/Applications
		fi

		if ! [ -f "$USER_HOME/Applications/App.Outlet-2.0.2.AppImage" ]; then
			wget https://github.com/app-outlet/app-outlet/releases/download/v2.0.2/App.Outlet-2.0.2.AppImage \
				-P $USER_HOME/Applications
		fi

		if ! command -v AppImageLauncher &>/dev/null; then
			wget https://github.com/TheAssassin/AppImageLauncher/releases/download/v2.2.0/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb \
				-P $USER_HOME/Applications

			apt install -y $USER_HOME/Applications/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb
			rm $USER_HOME/Applications/appimagelauncher_2.2.0-travis995.0f91801.bionic_amd64.deb
		fi

		if ! [ -f "$USER_HOME/Applications/Nextcloud-3.2.4-x86_64.AppImage" ]; then
			wget https://github.com/nextcloud/desktop/releases/download/v3.2.4/Nextcloud-3.2.4-x86_64.AppImage \
				-P $USER_HOME/Applications
		fi

		if ! [ -f "$USER_HOME/Applications/firefox-90.0.r20210721174149-x86_64.AppImage" ]; then
			wget https://github.com/srevinsaju/Firefox-Appimage/releases/download/firefox-v90.0.r20210721174149/firefox-90.0.r20210721174149-x86_64.AppImage \
				-P $USER_HOME/Applications
		fi

		if ! command -v google-chrome &>/dev/null; then
			wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.debwget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
				-P $USER_HOME/Applications

			apt install -y $USER_HOME/Applications/google-chrome-stable_current_amd64.deb
			rm $USER_HOME/Applications/google-chrome-stable_current_amd64.deb
		fi

		chmod +x $USER_HOME/Applications/*
		chown $USER_NAME:$USER_NAME $USER_HOME/Applications/*
	}

	download >$LOGPATH/out/appimage.log 2> \
		$LOGPATH/err/appimage.log &

	setIndicator "DOWNLOAD APPIMAGES" ${WORKINGICONS[2]} $!

}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	appimages
fi
