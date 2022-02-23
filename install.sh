#!/bin/bash
#shopt -s nullglob dotglob
options=($(echo $@ | tr " " "\n"))

CONFIG_ONLY=0
DISABLE_GIT_CONF=0

get_options() {
	for o in "${options[@]}"; do
    if [[ $o == '--cfg-only' ]] || [[ $o == '-c' ]]; then
			CONFIG_ONLY=1
		fi
	done
}

get_options

disable_git_config() {
if [[ -f  "/home/$SUDO_USER/.gitconfig" ]]; then
  mv /home/$SUDO_USER/.gitconfig /home/$SUDO_USER/gitconfig.bak
  DISABLE_GIT_CONF=1
fi;
if [[ $DISABLE_GIT_CONFIG == 1 ]]; then
  mv /home/$SUDO_USER/gitconfig.bak /home/$SUDO_USER/.gitconfig
fi;
}

disable_git_config

if ! [[ -d "./installer" ]]; then
	git clone https://github.com/dominikhaid/bash-installer installer
fi

source ./installer/globals/initMain.sh
initMain
disable_git_config
