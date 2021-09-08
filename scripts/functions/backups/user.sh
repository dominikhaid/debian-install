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

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	user
fi
