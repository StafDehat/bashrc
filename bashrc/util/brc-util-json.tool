#!/bin/bash

LASTLINE="bashrc"
PREFIX="bashrc"

# Handle whatever's inside the { } brackets
function docurlygroup() {
  local PREFIX=$1
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
  local PREFIX=$1
  local COUNT=0
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
  done
}

cat \
  | sed -e's/":/"\n:\n/g' \
        -e's/{/\n{\n/g' \
        -e's/}/\n}\n/g' \
        -e's/\[/\n\[\n/g' \
        -e's/\]/\n\]\n/g' \
        -e's/,/\n/g' \
  | grep -vE '^\s*$' \
  | sed -e's/^\s*//' \
  | while read LINE; do
    if [ "$LINE" == '{' ]; then
      docurlygroup $PREFIX
    else
      echo "ERROR: This isn't json"
      echo "$LINE"
    fi
  done
