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

# Hard-coded - fix this
export BRC_REGION=$BRC_REGION
export IMAGE_ENDPOINT="https://$BRC_REGION.images.api.rackspacecloud.com/v2"

export PATH=$PATH:$BASHRC_BASE/bashrc/image



