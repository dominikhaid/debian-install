#!/bin/bash
#shopt -s nullglob dotglob
##
# Tools
##
source $SCRIPTPATH/scripts/setIndicator.sh

tools() {

	toolsmain() {
		sudo -i -u $USER_NAME <<EOF
    echo $USER_PASS | sudo -S apt install -yq \
    flatpak \
    snapd \
    filezilla \
    kitty \
    ripgrep \
    fonts-firacode \
    zsh \
    vim \
    remmina \
    rofi \
    fzf \
    tree \
    fd-find \
    vifm \
    gimp \
    inkscape \
    imagemagick \
    cowsay \
    bat \
    fortune \
    pasystray \
    nitrogen \
    exuberant-ctags

EOF
	}

	vscode() {
		if ! command -v code &>/dev/null; then
			sudo -i -u $USER_NAME <<EOF
			wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
			echo $USER_PASS | sudo -S install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
			echo $USER_PASS | sudo -S sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
			
            echo $USER_PASS | sudo -S rm -f packages.microsoft.gpg
            echo $USER_PASS | sudo -S apt update
            echo $USER_PASS | sudo -S apt upgrade -y
            echo $USER_PASS | sudo -S apt install -y code code-insiders
EOF
		fi
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

	vscode >$LOGPATH/out/vscode.log 2> \
		$LOGPATH/err/vscode.log &

	setIndicator "VSCODE" ${WORKINGICONS[2]} $!

	vscodedebug >$LOGPATH/out/codedebug.log 2> \
		$LOGPATH/err/codedebug.log &

	setIndicator "VSCODE DEBUG2" ${WORKINGICONS[4]} $!

	chromedebug >$LOGPATH/out/chromedebug.log 2> \
		$LOGPATH/err/chromedebug.log &

	setIndicator "CHROME DEBUG" ${WORKINGICONS[4]} $!

	if [ -f "usr/bin/bat" ]; then
		ln -s batcat /usr/bin/bat
	fi
}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	tools
fi
