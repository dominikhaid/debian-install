#!/bin/bash
#shopt -s nullglob dotglob

PRE=()
while IFS= read -d $'\0' -r file; do
    source $file
done < <(find $SCRIPTPATH/scripts/functions/pre -regex ".*\.\(sh\)" -print0)
   
user=('USER SETUP' user)   
configs=('UPDATING CONFIG' configs)   
system=('INSTALL BASE SYSTEM' system)   
libs=('INSTALL LIBS' libs)   
    
PRE+=(
    user[@]
    system[@]
    libs[@]
    configs[@]
)
