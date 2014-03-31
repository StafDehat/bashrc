#!/bin/bash

ABSPATH=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd && cd $OLDPWD)

if ! which brc-util-json.tool &>/dev/null; then
  export BRCUTIL=$BASHRC_BASE/bashrc/util
fi

# Hard-coded - fix this
export BRC_REGION=$BRC_REGION
export IMAGE_ENDPOINT="https://$BRC_REGION.images.api.rackspacecloud.com/v2"
export PATH=$PATH:$BASHRC_BASE/bashrc/image



