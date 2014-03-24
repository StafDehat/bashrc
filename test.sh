#!/bin/bash

ABSPATH=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd && cd $OLDPWD)

# Import framework
. $ABSPATH/bashrc/bashrc.bash

# Import creds
. ~/.rackspace-bashrc-creds

# brc-identity-getauthtoken
AUTHINFO=$( brc-identity-getauthtoken )
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
  echo "Failure"
  exit 0
fi
echo
echo "Auth:"
for x in $AUTHINFO; do
  echo $x
  export $x
done

# brc-identity-listusers
USERS=$( brc-identity-listusers )
RETVAL=$?
echo
echo "Users:"
echo "$USERS"
USERID=$(echo "$USERS" | sed -n 's/^bashrc~users~id\.1~//p')
if [ $RETVAL -ne 0 ]; then
  echo "Failure"
  exit 0
fi

# brc-identity-listroles
ROLES=$( brc-identity-listroles )
RETVAL=$?
echo
echo "Roles:"
echo "$ROLES"
ROLEID=$( echo "$ROLES" | sed -n 's/^bashrc~roles~id\.1~//p' )
if [ $RETVAL -ne 0 ]; then
  echo "Failure"
  exit 0
fi

# brc-identity-adduser
USERINFO=$( brc-identity-adduser -u "bashrc.test" )
RETVAL=$?
echo
echo "New user info:"
echo "$USERINFO"
USERID=$( echo "$USERINFO" | sed -n 's/^bashrc~user~id~//p' )
if [ $RETVAL -ne 0 ]; then
  echo "Failure"
  exit 0
fi

# brc-identity-addroletouser
# Add a role

# brc-identity-listrolesforuser
# Confirm added role exists

# brc-identity-deleteuser
echo "Userid: $USERID"
echo 
echo "Deleting user:"
brc-identity-deleteuser -i $USERID
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
  echo "Failure"
  exit 0
fi


