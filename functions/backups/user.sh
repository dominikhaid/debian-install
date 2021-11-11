#!/bin/bash
#shopt -s nullglob dotglob
##
#USER
##
user() {
	usermain() {
		setIndicator "Add user to sudo group" ${WORKINGICONS[0]}
		/sbin/usermod -aG sudo $USER_NAME
	}

	usermain >$LOGPATH/out/user.log 2> \
		$LOGPATH/err/user.log

}



if [ -z $DEV_MAIN_RUN ]; then
    DEV_SINGLE_RUN=1
    source ../../installer/globals/initMain.sh
    runSingle user
fi

