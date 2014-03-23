#!/bin/bash

ALLGOOD=1
if which curl &>/dev/null -ne 0; then
  echo "ERROR: curl binary not found in PATH"
  ALLGOOD=0
fi

if [ $ALLGOOD -ne 1 ]; then
  echo "SDK not loaded.  Correct problems and try again."
  exit 1
fi

export BASHRC_BASE=$(pwd)/$(dirname $0)
source $BASHRC_BASE/identity.bash
