#!/bin/bash
#shopt -s nullglob dotglob
##
#Ruby
##
ruby() {
	if ! command -v ruby &>/dev/null; then
		apt-get install -y ruby ruby-dev
	fi
}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	ruby
fi
