#!/bin/bash

ABSPATH=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd && cd $OLDPWD)

if [ -z "$BASHRC_BASE" ]; then
  echo "This script not intended to be executed directly."
  echo "Please source bashrc.bash, or at least define"
  echo "$BASHRC_BASE manually."
  return 1
fi

if [ -z "$BRCUTIL" ]; then
  export BRCUTIL=$BASHRC_BASE/bashrc/util
fi

export PATH=$PATH:$BASHRC_BASE/bashrc/server



