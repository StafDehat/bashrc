#!/bin/bash

ABSPATH=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd && cd $OLDPWD)

ALLGOOD=1
if which curl &>/dev/null -ne 0; then
  echo "ERROR: curl binary not found in PATH"
  ALLGOOD=0
fi

if [ $ALLGOOD -ne 1 ]; then
  echo "SDK not loaded.  Correct problems and try again."
  exit 1
fi

export BASHRC_BASE=$( echo "$ABSPATH" | sed 's/^\(.*\)\/.*$/\1/' )

#. $BASHRC_BASE/bashrc/errors.bash
. $BASHRC_BASE/bashrc/identity.bash
. $BASHRC_BASE/bashrc/image.bash
. $BASHRC_BASE/bashrc/files.bash
