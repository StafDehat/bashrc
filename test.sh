#!/bin/bash

ABSPATH=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd && cd $OLDPWD)

# Import framework
. $ABSPATH/bashrc/bashrc.bash

# Import creds
. ~/.rackspace-bashrc-creds

# brc-identity-getauthtoken
brc-identity-getauthtoken
exit 0

brc-identity-listusers
brc-identity-listroles

brc-identity-listrolesforuser
brc-identity-addroletouser


