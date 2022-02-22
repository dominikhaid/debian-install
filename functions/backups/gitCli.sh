#!/bin/bash
#shopt -s nullglob dotglob
##
#Nvim
##


gitCli() {
	gitmain() {
		if ! command -v gh &>/dev/null; then
			curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
			echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list >/dev/null
			apt update
			apt install gh git-flow
		fi
	}

	gitmain >$LOGPATH/out/gitCli.log 2> \
		$LOGPATH/err/gitCli.log &

	setIndicator "GIT CLI" ${WORKINGICONS[1]} $!

	if ! [ -d "$USER_HOME/dev/backups" ]; then mkdir -p $USER_HOME/dev/backups; fi
	echo "0 5 * * 1 tar -zcf $(echo $USER_HOME)/dev/backups/nvim.tgz $(echo $USER_HOME)/.local/share/nvim" >>/var/spool/cron/crontabs/root

}



if [ -z $DEV_MAIN_RUN ]; then
    DEV_SINGLE_RUN=1
    source ../../installer/globals/initMain.sh
    runSingle gitCli
fi

