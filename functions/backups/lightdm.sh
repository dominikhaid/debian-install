#!/bin/bash
#shopt -s nullglob dotglob
##
# lightdm
##


lightdm() {
	lightmain() {
		apt install -y lightdm light-locker slick-greeter lightdm-settings

		sudo -i -u $USER_NAME <<EOF
		if ! command -v reTheme &>/dev/null; then
			echo $USER_PASS | sudo -S su $USER_NAME -c "cd $USER_HOME && git clone https://github.com/Paul-Houser/slickgreeter-pywal $USER_HOME/dev/slickgreeter-pywal"
            echo $USER_PASS | sudo -S su $USER_NAME chown -r $USER_NAME:$USER_NAME $USER_HOME/dev/slickgreeter-pywal
            cd $USER_HOME/dev/slickgreeter-pywal
			chmod +x install.sh
			./install.sh
			/usr/local/bin/reTheme $(cat $HOME/.cache/wal/wal)
		fi
EOF
	}

	lightmain >$LOGPATH/out/lightdm.log 2> \
		$LOGPATH/err/lightdm.log &

	setIndicator "SETUP LIGHTDM" ${WORKINGICONS[0]} $!

	# TODO setup web-greeter
	sed -i 's/^greeter-session=.*//g' /etc/lightdm/lightdm.conf
	sed -i 's/^\[Seat\:\*\]/[Seat:*]\ngreeter-session=slick-greeter/g' /etc/lightdm/lightdm.conf

	if [ -z $(cat /etc/lightdm/lightdm.conf | grep 'user-session=qtile') ]; then
		sed -i 's/^\[Seat\:\*\]/[Seat:*]\nuser-session=qtile/g' /etc/lightdm/lightdm.conf
	fi

#	$SCRIPTPATH/scripts/functions/backups/displaymanager.sh
}



if [ -z $DEV_MAIN_RUN ]; then
    DEV_SINGLE_RUN=1
    source ../../installer/globals/initMain.sh
    runSingle lightdm
fi

