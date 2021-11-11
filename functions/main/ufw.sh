#!/bin/bash
#shopt -s nullglob dotglob
##
#UFW
##


ufw() {

apt install -y ufw

	ufwmain() {
		sudo -i -u $USER_NAME <<EOF
    echo $USER_PASS | sudo -S ufw enable
    echo $USER_PASS | sudo -S ufw allow 22
    echo $USER_PASS | sudo -S ufw allow 80
    echo $USER_PASS | sudo -S ufw allow 80
    echo $USER_PASS | sudo -S ufw allow 443
    echo $USER_PASS | sudo -S ufw allow 5900
    echo $USER_PASS | sudo -S ufw allow 5901
EOF
	}

	ufwmain >$LOGPATH/out/ufw.log 2> \
		$LOGPATH/err/ufw.log &

	setIndicator "UFW" ${WORKINGICONS[0]} $!

}



if [ -z $DEV_MAIN_RUN ]; then
    DEV_SINGLE_RUN=1
    source ../../installer/globals/initMain.sh
    runSingle ufw
fi

