#!/bin/bash
#shopt -s nullglob dotglob

/**
/* USER_PASS, USER_NAME, FUNCTION
*/
paramCheck() {

if ! [[ $USER == "root" ]]; then 
 echo "Script must be run as root!"
 exit
fi

if ! [ -z $1 ]; then echo "USER_PASS not set" && exit; fi

if ! [ -z $2 ]; then echo "USER_NAME not set" && exit; fi

if ! [ -z $3 ]; then echo "FUNCTION not set" && exit; fi

	USER_PASS=$1
	USER_NAME=$2
	USER_HOME=/home/$2

if ! [ -z $SCRIPTPATH ]; then
## echo Funtion gets called directly
$SCRIPTPATH = ../../../
fi

if ! [[ -d "$SCRIPTPATH/logs" ]]; then
	mkdir -p "$SCRIPTPATH/logs/err"
	mkdir -p "$SCRIPTPATH/logs/out"
fi

if ! [[ -z "$LOGPATH" ]]; then
	LOGPATH="$SCRIPTPATH/logs"
fi

TEST_USER=$(cat /etc/passwd | gawk -F: '{ print $1 }' | gawk -e 'match($0, /'$USER_NAME'/) {print substr( $1, RSTART, RLENGTH )}')

if [[ "$TEST_USER" == "" ]]; then
	echo "
        No user: $USER_NAME 
        please add the user with /sbin/useradd USERNAME
        and run the script again!"
	exit
fi

source $SCRIPTPATH/scripts/setIndicator.sh

	$3
}