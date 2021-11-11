#!/bin/bash
#shopt -s nullglob dotglob
##
# Node
##

source $SCRIPTPATH/scripts/setIndicator.sh

node() {

	nvm() {

		echo "INSTALL NVM"
		sudo -i -u $USER_NAME <<EOF
	    if ! [ -d $USER_HOME/.nvm ]; then
		    echo $USER_PASS | sudo -S su $USER_NAME -c "curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash"
            echo $USER_PASS | sudo -S su $USER_NAME -c "source $USER_HOME/.nvm/nvm.sh \
            && nvm install --lts"
        fi
EOF

		echo "END"
	}

	nvm >$LOGPATH/out/nvm.log 2> \
		$LOGPATH/err/nvm.log &

	setIndicator "NVM & NODE" ${WORKINGICONS[2]} $!

}

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	node
fi
