#!/bin/bash
#shopt -s nullglob dotglob
##
#Java
##
source $SCRIPTPATH/scripts/setIndicator.sh

java() {
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
		NPM=$(echo $(find "$USER_HOME/.nvm/versions/node" -maxdepth 1) | sed -En "s/.*\s(.*)/\1/p")
		NPM=$NPM"/bin/npm"

		sudo -i -u $USER_NAME <<EOF
        source $USER_HOME/.nvm/nvm.sh
         if ! [ -d $USER_HOME/dev/java-debug ]; then
          git clone https://github.com/microsoft/java-debug $USER_HOME/dev/java-debug 
          cd $USER_HOME/dev/java-debug 
          LANG=C ./mvnw clean install
         fi

         if ! [ -d $USER_HOME/dev/vscode-java-test ]; then
          git clone https://github.com/microsoft/vscode-java-test $USER_HOME/dev/vscode-java-test
          cd $USER_HOME/dev/vscode-java-test 
          $NPM install 
          $NPM run build-plugin 
         fi

         if ! [ -d $USER_HOME/dev/eclipse.jdt.ls ]; then
          git clone https://github.com/eclipse/eclipse.jdt.ls.git $USER_HOME/dev/eclipse.jdt.ls
          cd $USER_HOME/dev/eclipse.jdt.ls
          ./mvnw clean install -DskipTests
         fi

         if ! [ -d $USER_HOME/dev/vscode-java-decompiler ]; then
          git clone https://github.com/dgileadi/vscode-java-decompiler.git $USER_HOME/dev/vscode-java-decompiler
          cd $USER_HOME/dev/vscode-java-decompiler
          $NPM i
         fi

         if ! [ -d $USER_HOME/dev/virtualenvs/debugpy ]; then
          python3 -m venv $USER_HOME/dev/virtualenvs/debugpy 
          $USER_HOME/dev/virtualenvs/debugpy/bin/python3 -m pip install debugpy 
         fi

EOF
	}

	if ! [ -d "/etc/profile.d" ]; then mkdir -p /etc/profile.d; fi
	if ! [ -f "/etc/profile.d/java.sh" ]; then
		echo JAVA_HOME="$USER_HOME/.sdkman/candidates/java/current" | tee /etc/profile.d/java.sh
	fi

	javatools() {
		sudo -i -u $USER_NAME <<EOF
          source $USER_HOME/.sdkman/bin/sdkman-init.sh 
          if ! [ -d $USER_HOME/.sdkman/candidates/gradle ]; then sdk install gradle 7.1.1;fi
          if ! [ -d $USER_HOME/.sdkman/candidates/springboot ]; then sdk install springboot;fi
          if ! command -v java &>/dev/null; then sdk install java;fi
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

if [[ ${1} == "--debug" ]]; then
	USER_PASS=$3
	USER_NAME=$2
	USER_HOME=/home/$2
	java
fi
