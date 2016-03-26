#!/usr/bin/env bash

BL_SRC=$(dirname $0)/../src

. $BL_SRC/bl_dep
source $BL_SRC/bl_ini

# provoke "file not found" error

if [ -f $BL_INI_FILE ]; then
   echo "ini file exists >$BL_INI_FILE<"
else
   echo "ini file not found >$BL_INI_FILE<"
fi

touch $BL_INI_FILE

bl_ini_read $BL_INI_FILE

if [ -f $BL_INI_FILE ]; then
   echo "ini file exists >$BL_INI_FILE<"
else
   echo "ini file not found >$BL_INI_FILE<"
fi

chmod 000 $BL_INI_FILE
bl_ini_read $BL_INI_FILE

chmod 644 $BL_INI_FILE

bl_ini_read /tmp/doesnotexist

rm $BL_INI_FILE

NON_EXISTENT=$(bl_ini_get doesnot.exist)
WRONG_SYNTAX=$(bl_ini_get wrongsyntax)

echo "========== last 10 lines from logfile >$BL_LOG_FILE<"
tail -n 10 $BL_LOG_FILE
