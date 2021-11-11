#!/bin/bash
#shopt -s nullglob dotglob
##
# Node
##



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



if [ -z $DEV_MAIN_RUN ]; then
    DEV_SINGLE_RUN=1
    source ../../installer/globals/initMain.sh
    runSingle node
fi

