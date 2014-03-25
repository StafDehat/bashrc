#!/bin/bash

# If any command fails, exit
set -e

ABSPATH=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd && cd $OLDPWD)

# Import framework
. $ABSPATH/bashrc/bashrc.bash

# Import creds
. ~/.rackspace-bashrc-creds

# brc-identity-getauthtoken
echo
echo "Auth:"
AUTHINFO=$( brc-identity-getauthtoken )
for x in $AUTHINFO; do
  echo $x
  export $x
done

# brc-identity-listusers
echo
echo "Users:"
USERS=$( brc-identity-listusers )
echo "$USERS"
USERID=$(echo "$USERS" | sed -n 's/^bashrc~users~id\.1~//p')

# brc-identity-listroles
echo
echo "Roles:"
ROLES=$( brc-identity-listroles )
echo "$ROLES"
ROLEID=$( echo "$ROLES" | sed -n 's/^bashrc~roles~id\.1~//p' )

# brc-identity-adduser
echo
echo "New user info:"
USERINFO=$( brc-identity-adduser -u "bashrc.test" )
echo "$USERINFO"
USERID=$( echo "$USERINFO" | sed -n 's/^bashrc~user~id~//p' )

# brc-identity-addroletouser
echo
echo "Adding role to user:"
brc-identity-addroletouser -u $USERID -r $ROLEID
echo "Done"

# brc-identity-listrolesforuser
echo
echo "Roles for new user:"
brc-identity-listrolesforuser -u $USERID

# brc-identity-deleteuser
echo 
echo "Deleting user:"
echo "Userid: $USERID"
brc-identity-deleteuser -i $USERID


