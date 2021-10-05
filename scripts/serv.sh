#!/bin/bash
#shopt -s nullglob dotglob

SEARCHPATH=$SCRIPTPATH"/scripts/functions/server"
FUNCTIONS=()
SERV=()

while IFS= read -d $'\0' -r file; do
	source $file
	FUNCTIONS+=($(echo $file | sed -En "s|$SEARCHPATH/(.*)\.sh$|\1|p"))
done < <(find $SEARCHPATH -regex ".*\.\(sh\)" -print0)

if [[ ${1} == "--debug" ]]; then
	for func in ${FUNCTIONS[@]}; do
		eval $func
	done
fi

for func in ${FUNCTIONS[@]}; do
	str=$(echo "Install $func" | tr '[a-z]' '[A-Z]')
	str=$(echo $str | sed "s/\s/_/g")
	eval "$func"="($str  $func)"
	SERV+=("$func[@]")
done

#printf '%s ' ${MAIN[@]}
