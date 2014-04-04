#!/bin/bash

# EXITLEVELS is still buggy - it's not local-scope enough

LASTLINE="bashrc"
PREFIX="bashrc"
EXITLEVELS=0


# Handle a single item from this list/array
function dolineitem() {
  local PREFIX=$1
  while read LINE; do
    LINE=$( echo "$LINE" | tr -d '"' )
    case $LINE in
      '{' ) # Start a list
        LASTLINE="$LINE"
        docurlygroup $PREFIX;;
      '[' ) # Start an array
        LASTLINE="$LINE"
        dosquaregroup $PREFIX;;
      ',' ) #Line Terminator
        LASTLINE="$LINE"
        echo "$PREFIX"
        return;;
      '}'|']' ) # Line terminators that also terminate a group
        LASTLINE="$LINE"
        EXITLEVELS=$(( $EXITLEVELS + 1 ))
        echo "$PREFIX"
        return;;
      * ) #Values & Assignment
        PREFIX="$PREFIX~$LINE";;
    esac
  done
}


# Handle whatever's inside the { } brackets
function docurlygroup() {
  local PREFIX=$1
  while true; do
    dolineitem "$PREFIX"
    if [ "$EXITLEVELS" -ne 0 ]; then
      EXITLEVELS=$(( $EXITLEVELS - 1 ))
      return
    fi
  done
}


# Handle whatever's inside the [ ] brackets
function dosquaregroup() {
  local PREFIX=$1
  local COUNT=0
  local PREFIX=$1
  while true; do
    dolineitem "$PREFIX~$COUNT"
    COUNT=$(( $COUNT + 1 ))
    if [ "$EXITLEVELS" -ne 0 ]; then
      EXITLEVELS=$(( $EXITLEVELS - 1 ))
      return
    fi
  done
}


while read LINE; do
  if [ $( echo "$PREFIX" | grep -c "$LINE" ) -eq 0 ]; then
    echo "$LINE"
  fi
  PREFIX="$LINE"
done < <(
cat \
  | sed -e's/":/"\n/g' \
  | sed -e's/{/\n{\n/g' \
  | sed -e's/}/\n}\n/g' \
  | sed -e's/\[/\n\[\n/g' \
  | sed -e's/\]/\n\]\n/g' \
  | sed -e's/,/\n,\n/g' \
  | sed -e's/^\s*//' \
  | grep -vE '^\s*$' \
  | while read LINE; do
    dolineitem $PREFIX
  done
)
