#!/bin/bash
#shopt -s nullglob dotglob
##
#ZSH
##


zsh() {

	zshmain() {
		if ! command -v starship &>/dev/null; then
			cd $USER_HOME
			sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes
		fi

		if ! command -v zsh &>/dev/null; then
			apt install -y zsh
		fi
	}

	zshplug() {
		sudo -i -u $USER_NAME <<EOF
       	cd $USER_HOME
        if ! command -v antigen &>/dev/null; then
         curl -L git.io/antigen > antigen.zsh
        fi
     
        if ! [ -d $USER_HOME/dev/zsh-autocomplete ]; then
            git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $USER_HOME/dev/zsh-autocomplete
        fi
     
        if ! [ -d $USER_HOME/.oh-my-zsh ]; then
         curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh | bash
        fi
EOF
	}

	zshmain >$LOGPATH/out/zsh.log 2> \
		$LOGPATH/err/zsh.log &

	setIndicator "ZSH & STARSHIP" ${WORKINGICONS[2]} $!

	zshplug >$LOGPATH/out/zshplug.log 2> \
		$LOGPATH/err/zshplug.log &

	setIndicator "ZSH PLUGINS" ${WORKINGICONS[1]} $!

	if [ -f "$SCRIPTPATH/debian-config/user-config/.bashrc" ]; then
		mv -f $SCRIPTPATH/debian-config/user-config/.bashrc $USER_HOME/.bashrc
	fi

	if [ -f "$SCRIPTPATH/debian-config/user-config/.zshrc" ]; then
		mv -f $SCRIPTPATH/debian-config/user-config/.zshrc $USER_HOME/.zshrc
	fi
}



if [ -z $DEV_MAIN_RUN ]; then
    DEV_SINGLE_RUN=1
    source ../../installer/globals/initMain.sh
    runSingle zsh
fi

