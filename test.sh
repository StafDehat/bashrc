#!/bin/bash

ABSPATH=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd && cd $OLDPWD)

# Import framework
. $ABSPATH/bashrc/bashrc.bash

# Import creds
. ~/.rackspace-bashrc-creds

# brc-identity-getauthtoken
echo
echo "Auth:"
for x in `brc-identity-getauthtoken`; do
  echo $x
  export $x
done

# brc-identity-listusers
USERS=`brc-identity-listusers`
echo
echo "Users:"
echo "$USERS"
USERID=$(echo "$USERS" | sed -n 's/bashrc~users~id\.1~//p')

exit 0
brc-identity-listrolesforuser

brc-identity-listroles

brc-identity-addroletouser


