#!/bin/bash

ABSPATH=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd && cd $OLDPWD)

#if [ -z "$BASHRC_BASE" ]; then
#  export BASHRC_BASE=$( echo "$ABSPATH" \
#                          | sed 's/.*\(\/.*\).*$/\1/' )
#fi

if ! which brc-json.tool &>/dev/null; then
  export PATH=$PATH:$BASHRC_BASE/bashrc/util
fi

export IDENTITY_ENDPOINT="https://identity.api.rackspacecloud.com/v2.0"
export PATH=$PATH:$BASHRC_BASE/bashrc/identity



