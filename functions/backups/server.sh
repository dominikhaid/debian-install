#!/bin/bash
#shopt -s nullglob dotglob
##
# Clone Configs
##
source $SCRIPTPATH/scripts/setIndicator.sh

server() {
	echo "SERVER INSTALL"
}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	server
fi
