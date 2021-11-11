#!/bin/bash
#shopt -s nullglob dotglob

if ! [[ -d "./installer" ]]; then
	git clone https://github.com/dominikhaid/bash-installer installer
fi

source ./installer/globals/initMain.sh
initMain
