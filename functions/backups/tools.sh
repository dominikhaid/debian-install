#!/bin/bash
#shopt -s nullglob dotglob
##
# Tools
##

tools() {

	toolsmain() {
		sudo -i -u $USER_NAME <<EOF
    echo $USER_PASS | sudo -S apt install -yq \
    synaptic \
    libreoffice \
    remmina \
    rofi \
    evolution
EOF
	}

	shformat() {
		if ! command -v shfmt &>/dev/null; then
			wget https://github.com/patrickvane/shfmt/releases/download/master/shfmt_linux_amd64 -P $HOME
			mv $HOME/shfmt_linux_amd64 /usr/bin/shfmt
			chmod 755 /usr/bin/shfmt
		fi
	}

	vscodedebug() {

		echo "INSTALL VSCODE DEBUG"
		NPM=$(echo $(find "$USER_HOME/.nvm/versions/node" -maxdepth 1) | sed -En "s/.*\s(.*)/\1/p")
		NPM=$NPM"/bin/npm"

		if ! [ -d "$USER_HOME/dev/vscode-node-debug2" ]; then
			sudo -i -u $USER_NAME <<EOF
	            source $USER_HOME/.nvm/nvm.sh
                git clone https://github.com/microsoft/vscode-node-debug2.git $USER_HOME/dev/vscode-node-debug2 
                cd $USER_HOME/dev/vscode-node-debug2 
                $NPM i 
                $NPM i -g gulp 
                gulp build
EOF
		fi
		echo "END"
	}

	chromedebug() {
		echo "INSTALL CHROME DEBUG"
		NPM=$(echo $(find "$USER_HOME/.nvm/versions/node" -maxdepth 1) | sed -En "s/.*\s(.*)/\1/p")
		NPM=$NPM"/bin/npm"

		if ! [ -d "$USER_HOME/dev/vscode-chrome-debug" ]; then
			sudo -i -u $USER_NAME <<EOF
	            source $USER_HOME/.nvm/nvm.sh
                git clone https://github.com/Microsoft/vscode-chrome-debug $USER_HOME/dev/vscode-chrome-debug 
                cd $USER_HOME/dev/vscode-chrome-debug 
                $NPM install 
                $NPM run build
EOF
		fi
		echo "END"
	}

	npmG() {
		NPM=$(echo $(find "$USER_HOME/.nvm/versions/node" -maxdepth 1) | sed -En "s/.*\s(.*)/\1/p")
		NPM=$NPM"/bin/npm"

		echo $USER_PASS | sudo -S su $USER_NAME -c "source $USER_HOME/.nvm/nvm.sh \
            && $NPM i -g eslint \
            typescript \
            yarn \
            diagnostic-languageserver \
            prettier"

	}

	npmG >$LOGPATH/out/npm_globals.log 2> \
		$LOGPATH/err/npm_globals.log &

	setIndicator "ESLINT TYPESCRIPT PRETTIER" ${WORKINGICONS[4]} $!

	shformat >$LOGPATH/out/shfmt.log 2> \
		$LOGPATH/err/shfmt.log &

	setIndicator "SHFMT" ${WORKINGICONS[2]} $!

	toolsmain >$LOGPATH/out/tools.log 2> \
		$LOGPATH/err/tools.log &

	setIndicator "TOOLS" ${WORKINGICONS[0]} $!

	if [ -f "usr/bin/bat" ]; then
		ln -s batcat /usr/bin/bat
	fi
}

if [ -z $DEV_MAIN_RUN ]; then
	DEV_SINGLE_RUN=1
	source ../../installer/globals/initMain.sh
	runSingle tools
fi
