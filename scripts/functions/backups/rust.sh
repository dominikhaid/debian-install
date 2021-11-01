#!/bin/bash
#shopt -s nullglob dotglob
##

#Rust
##
source $SCRIPTPATH/scripts/setIndicator.sh

rust() {

	rmain() {
		sudo -i -u $USER_NAME <<EOF
        	if ! command -v rustc &>/dev/null; then
                cd $USER_HOME && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	        fi

EOF
	}

	rtools() {

		apt install -y libxcb-xfixes0-dev libxcb-shape0-dev

		sudo -i -u $USER_NAME <<EOF
	        if ! command -v sd &>/dev/null; then
                 $USER_HOME/.cargo/bin/cargo install sd
	        fi
EOF

		sudo -i -u $USER_NAME <<EOF
	        if ! command -v broot &>/dev/null; then
                $USER_HOME/.cargo/bin/cargo install broot
	        fi
EOF

		sudo -i -u $USER_NAME <<EOF
	        if ! command -v procs &>/dev/null; then
                $USER_HOME/.cargo/bin/cargo install procs
	        fi
EOF
		# TODO br will never be found in zsh
		sudo -i -u $USER_NAME <<EOF
	        if ! command -v br &>/dev/null; then
                broot --install
	        fi
EOF
	}

	rmain >$LOGPATH/out/rust.log 2> \
		$LOGPATH/err/rust.log &

	setIndicator "RUST" ${WORKINGICONS[2]} $!

	rtools >$LOGPATH/out/rtools.log 2> \
		$LOGPATH/err/rtools.log &

	setIndicator "RUST TOOLS (might take a while)" ${WORKINGICONS[3]} $!

	if ! [ -L "/usr/bin/rust-analyzer" ]; then
		ln -s $USER_HOME/.local/share/nvim/lspinstall/rust/rust-analyzer /usr/bin/rust-analyzer
	fi
}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	rust
fi
