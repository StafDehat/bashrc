#!/bin/bash

LASTLINE="bashrc"
PREFIX="bashrc"

# Handle whatever's inside the { } brackets
function docurlygroup() {
  PREFIX=$1
  while read LINE; do
    LINE=$( echo "$LINE" | tr -d '"' )
    case $LINE in
      '{') LASTLINE="$LINE"
           docurlygroup $PREFIX;;
      '}') # Note: We're relying on greedy sed here to only trim the last tree node
           PREFIX=$( echo "$PREFIX" | sed 's/^\(.*\)~.*$/\1/' )
           LASTLINE="$LINE"
           return;;
      '[') LASTLINE="$LINE"
           dosquaregroup $PREFIX;;
      ']') echo "ERROR: Thought we were in a {} group but encountered ']'."
           exit 1;;
      ':') PREFIX="$PREFIX~$LASTLINE"
           LASTLINE="$LINE";;
      *)   if [ "$LASTLINE" == ':' ]; then
             echo "$PREFIX~$LINE"
             PREFIX=$( echo "$PREFIX" | sed 's/^\(.*\)~.*$/\1/' )
           fi
           LASTLINE="$LINE";;
    esac
  done
}

# Handle whatever's inside the [ ] brackets
function dosquaregroup() {
  #echo "Doing a square group"
  #echo "Prefix at start: $PREFIX"
  PREFIX=$1
  COUNT=0
  while read LINE; do
    LINE=$( echo "$LINE" | tr -d '"' )
    case $LINE in
      '{') LASTLINE="$LINE"
           docurlygroup "$PREFIX~$COUNT"
           COUNT=$(( $COUNT + 1 ));;
      '}') echo "ERROR: Thought we were in a [] group but encountered '}'."
           exit 1;;
      '[') LASTLINE="$LINE"
           dosquaregroup $PREFIX;;
      ']') # Note: We're relying on greedy sed here to only trim the last tree node
           PREFIX=$( echo "$PREFIX" | sed 's/^\(.*\)~.*$/\1/' )
           LASTLINE="$LINE"
           return;;
      ':') PREFIX="$PREFIX~$COUNT~$LASTLINE"
           COUNT=$(( $COUNT + 1 ))
           LASTLINE="$LINE";;
      *)   if [ "$LASTLINE" == ':' ]; then
             echo "$PREFIX~$LINE"
           fi
           LASTLINE="$LINE";;
    esac
    #LASTLINE="$LINE"
  done
}

#while read LINE; do
#  if [ $( echo "$LINE" | grep -c "$PREFIX" ) -eq 0 ]; then
#    echo $PREFIX
#  fi
#  PREFIX="$LINE"
#done < <(
cat \
  | sed -e's/":/"\n:\n/g' \
        -e's/{/\n{\n/g' \
        -e's/}/\n}\n/g' \
        -e's/\[/\n\[\n/g' \
        -e's/\]/\n\]\n/g' \
        -e's/,//g' \
  | grep -vE '^\s*$' \
  | while read LINE; do
    if [ "$LINE" == '{' ]; then
      docurlygroup $PREFIX
    else
      echo "ERROR: This isn't json"
      echo "$LINE"
    fi
  done
#)
