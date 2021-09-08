#!/bin/bash
#shopt -s nullglob dotglob
##
# lightdm
##
source $SCRIPTPATH/scripts/setIndicator.sh

lightdm() {
	lightmain() {
		if ! command -v light-locker &>/dev/null; then
			apt install -y lightdm
		fi

		if ! command -v web-greeter &>/dev/null; then
			apt install -y python3-pyqt5.qtwebengine python3-gi
			pip3 install whither

			echo $USER_PASS | sudo -S su $USER_NAME -c "cd $USER_HOME && git clone https://github.com/Antergos/web-greeter.git $USER_HOME/dev/web-greeter"
			cd $USER_HOME/dev/web-greeter && make install
		fi
	}

	lightmain >$LOGPATH/out/lightdm.log 2> \
		$LOGPATH/err/lightdm.log &

	setIndicator "SETUP LIGHTDM" ${WORKINGICONS[0]} $!

	# TODO setup web-greeter
	#sed -i 's/\[Seat\:\*\]/[Seat:*]\ngreeter-session=web-greeter/g' /etc/lightdm/lightdm.conf
}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	lightdm
fi
