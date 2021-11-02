#!/bin/bash
#shopt -s nullglob dotglob
##
# lightdm
##
source $SCRIPTPATH/scripts/setIndicator.sh

lightdm() {
	lightmain() {
		if ! command -v light-locker &>/dev/null; then
			apt install -y lightdm light-locker slick-greeter lightdm-settings
		fi

		if ! command -v reTheme &>/dev/null; then
			echo $USER_PASS | sudo -S su $USER_NAME -c "cd $USER_HOME && git clone https://github.com/Paul-Houser/slickgreeter-pywal $USER_HOME/dev/slickgreeter-pywal"
			cd $USER_HOME/dev/slickgreeter-pywal
			chmod +x install.sh
			./install.sh
			reTheme $(cat $HOME/.cache/wal/wal)
		fi
	}

	lightmain >$LOGPATH/out/lightdm.log 2> \
		$LOGPATH/err/lightdm.log &

	setIndicator "SETUP LIGHTDM" ${WORKINGICONS[0]} $!

	# TODO setup web-greeter
	if [ -z $(cat /etc/lightdm/lightdm.conf | grep 'greeter-session=slick-greeter') ]; then
		sed -i 's/^\[Seat\:\*\]/[Seat:*]\ngreeter-session=slick-greeter/g' /etc/lightdm/lightdm.conf
	fi

	if [ -z $(cat /etc/lightdm/lightdm.conf | grep 'user-session=qtile') ]; then
		sed -i 's/^\[Seat\:\*\]/[Seat:*]\nuser-session=qtile/g' /etc/lightdm/lightdm.conf
	fi

	$SCRIPTPATH/scripts/functions/backup/displaymanager.sh
}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	lightdm
fi
