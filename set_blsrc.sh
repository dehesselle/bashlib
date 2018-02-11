# purpose:
# Set BL_SRC for bashlib to find its sources. This is only required if you
# do not setup this up from within your script.
#
# remarks:
# - for maximum compatiblity, use replacement for readlink
# - check bash and version requirement

function bl_fs_readlink_f
{
#  source: http://stackoverflow.com/questions/1055671/

   local file=$1

   cd $(dirname $file)
   file=$(basename $file)

   while [ -L "$file" ]; do
      file=$(readlink $file)
      cd $(dirname $file)
      file=$(basename $file)
   done

   local dir=$(pwd -P)

   echo $dir/$file
}

if   [ -z $BASH ]; then
   echo "error: not running 'bash'"
elif [ ! -z $POSIXLY_CORRECT ]; then
#  '$POSIXLY_CORRECT' can happen if bash executes scripts that have
#  the '#!/bin/sh' shebang, e.g. on systems where bash is the only available
#  shell
   echo "error: posix-only mode detected"
elif [ ${BASH_VERSINFO[0]} -lt 4 ]; then
   echo "error: bash 4.x required"
elif
   export BL_SRC=$(dirname $(bl_fs_readlink_f ${BASH_SOURCE[0]}))
fi
