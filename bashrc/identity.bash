#!/bin/bash

ABSPATH=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd && cd $OLDPWD)

if [ -z "$BASHRC_BASE" ]; then
  echo "This script not intended to be executed directly."
  echo "Please source bashrc.bash"
  return 1
fi

if [ -z "$BRCUTIL" ]; then
  export BRCUTIL=$BASHRC_BASE/bashrc/util
fi

export IDENTITY_ENDPOINT="https://identity.api.rackspacecloud.com/v2.0"
export PATH=$PATH:$BASHRC_BASE/bashrc/identity


