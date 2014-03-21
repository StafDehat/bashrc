#!/bin/bash

if [ -z "$BASHRC_BASE" ]; then
  export BASHRC_BASE=$(pwd)/$(dirname $0)
fi

if ! which json.tool &>/dev/null; then
  PATH=$PATH:$BASHRC_BASE/util
fi

export IDENTITY_ENDPOINT="https://identity.api.rackspacecloud.com/v2.0"
export PATH=$PATH:$BASHRC_BASE/identity

