#!/bin/bash

ABSPATH=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd && cd $OLDPWD)

#if [ -z "$BASHRC_BASE" ]; then
#  export BASHRC_BASE=$( echo "$ABSPATH" \
#                          | sed 's/.*\(\/.*\).*$/\1/' )
#fi

if ! which brc-util-json.tool &>/dev/null; then
  export BRCUTIL=$BASHRC_BASE/bashrc/util
  export PATH=$PATH:$BASHRC_BASE/bashrc/util
fi

# Hard-coded - fix this 
# Multiple endpoints - Gonna have to write an include to export stuff, or at
# least to echo the endpoint based on region.
export BRC_REGION=$BRC_REGION
export FILES_ENDPOINT="https://storage101.${BRC_REGION}1.clouddrive.com/v1"

# This needs to be in every script
# export FILES_ENDPOINT=$( $BRCUTIL/brc-util-filesendpoint -r $BRC_REGION )

export PATH=$PATH:$BASHRC_BASE/bashrc/files



