#!/bin/bash
#shopt -s nullglob dotglob
##
#lua
##
lua() {
	luamain() {
		apt install -y lua5.3

		NPM=$(echo $(find "$USER_HOME/.nvm/versions/node" -maxdepth 1) | sed -En "s/.*\s(.*)/\1/p")
		NPM=$NPM"/bin/npm"

		echo $USER_PASS | sudo -S su $USER_NAME -c "source $USER_HOME/.nvm/nvm.sh \
            && $NPM i -g lua-fmt"
	}

	luamain >$LOGPATH/out/lua.log 2> \
		$LOGPATH/err/lua.log &

	setIndicator "Lua" ${WORKINGICONS[2]} $!

}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	lua
fi
