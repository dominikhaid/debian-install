#!/bin/bash
#shopt -s nullglob dotglob
##
#Java
##


java() {

  DEV_PATH=$(echo "$USER_HOME/dev/java/source")

	javamain() {
		apt install -y python3-venv
		apt install -y maven

		sudo -i -u $USER_NAME <<EOF
	        source $USER_HOME/.nvm/nvm.sh

              if ! [ -d $USER_HOME/.sdkman ]; then
               curl -s "https://get.sdkman.io" | bash
              fi
EOF

		NPM=$(echo $(find "$USER_HOME/.nvm/versions/node" -maxdepth 1) | sed -En "s/.*\s(.*)/\1/p")
		NPM=$NPM"/bin/npm"

		echo $USER_PASS | sudo -S su $USER_NAME -c "source $USER_HOME/.nvm/nvm.sh \
            && $NPM i -g prettier-plugin-java"

	}

	javadebug() {
		sudo -i -u $USER_NAME <<EOF
        source $USER_HOME/.nvm/nvm.sh

         if ! [ -d $DEV_PATH/java-debug ]; then
          git clone https://github.com/microsoft/java-debug $DEV_PATH/java-debug 
         fi

         if ! [ -d $DEV_PATH/vscode-java-test ]; then
          git clone https://github.com/microsoft/vscode-java-test $DEV_PATH/vscode-java-test
         fi

         if ! [ -d $DEV_PATH/vscode-java-decompiler ]; then
          git clone https://github.com/dgileadi/vscode-java-decompiler.git $DEV_PATH/vscode-java-decompiler
         fi
EOF
	}

	javatools() {
		sudo -i -u $USER_NAME <<EOF
          source $USER_HOME/.sdkman/bin/sdkman-init.sh 
          if ! [ -d $USER_HOME/.sdkman/candidates/gradle ]; then sdk install gradle 7.2;fi
          if ! [ -d $USER_HOME/.sdkman/candidates/springboot ]; then sdk install springboot;fi
          if ! [ -d $USER_HOME/.sdkman/candidates/11.0.2-open ];then sdk install java 11.0.2-open;fi
EOF
	}

	javamain >$LOGPATH/out/java.log 2> \
		$LOGPATH/err/java.log &

	setIndicator "SDKMAN" ${WORKINGICONS[2]} $!

	javadebug >$LOGPATH/out/javadebug.log 2> \
		$LOGPATH/err/javadebug.log &

	setIndicator "DEBUGGERS (building from source)" ${WORKINGICONS[1]} $!

	javatools >$LOGPATH/out/sdk.log 2> \
		$LOGPATH/err/sdk.log &

	setIndicator "JAVA / GRADLE / SPRINGBOOT" ${WORKINGICONS[2]} $!
}



if [ -z $DEV_MAIN_RUN ]; then
    DEV_SINGLE_RUN=1
    source ../../installer/globals/initMain.sh
    runSingle java
fi

