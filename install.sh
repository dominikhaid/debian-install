#!/bin/bash
#shopt -s nullglob dotglob
options=($(echo $@ | tr " " "\n"))

CONFIG_ONLY=0

get_options() {
	for o in "${options[@]}"; do
    if [[ $o == '--cfg-only' ]] || [[ $o == '-c' ]]; then
			CONFIG_ONLY=1
		fi
	done
}

get_options

if ! [[ -d "./installer" ]]; then
	git clone https://github.com/dominikhaid/bash-installer installer
fi

source ./installer/globals/initMain.sh
initMain
