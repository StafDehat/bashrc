#!/bin/bash

ABSPATH=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd && cd $OLDPWD)

ALLGOOD=1

for COMMAND in du bc curl date sed awk; do
  which $COMMAND &>/dev/null
  if [ $? -ne 0 ]; then
    echo "ERROR: '$COMMAND' binary not found in PATH"
    ALLGOOD=0
  fi
done

if [ $ALLGOOD -ne 1 ]; then
  echo "SDK not loaded.  Correct problems and try again."
  return 1
fi

export BASHRC_BASE=$( echo "$ABSPATH" | sed 's/^\(.*\)\/.*$/\1/' )

#. $BASHRC_BASE/bashrc/errors.bash
. $BASHRC_BASE/bashrc/identity.bash
. $BASHRC_BASE/bashrc/image.bash
. $BASHRC_BASE/bashrc/files.bash
. $BASHRC_BASE/bashrc/monitor.bash
