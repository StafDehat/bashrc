#!/bin/bash

# EXITLEVELS is still buggy - it's not local-scope enough
# Edit: On second thought, it's probably only possible to hit EXITLEVELS>0
#   at the tail of a construct, so it should implicitly be local enough.

PREFIX="bashrc"
EXITLEVELS=0


# Handle a single item from this list/array
function dolineitem() {
  local PREFIX=$1
  while read LINE; do
    LINE=$( echo "$LINE" | tr -d '"' )
    case $LINE in
      '{' ) # Start a list
        docurlygroup $PREFIX;;
      '[' ) # Start an array
        dosquaregroup $PREFIX;;
      ',' ) #Line Terminator
        echo "$PREFIX"
        return;;
      '}'|']' ) # Line terminators that also terminate a group
        EXITLEVELS=1
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
      EXITLEVELS=0
      return
    fi
  done
}


# Handle whatever's inside the [ ] brackets
function dosquaregroup() {
  local PREFIX=$1
  local COUNT=0
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
  dolineitem $PREFIX < <(
  ESCAPED=0
  INQUOTE=0
  LINE=""
  cat | 
    sed 's/\\/\\\\/g' | #This sed is required because "read" strips escape characters
    while read -n 1 CHAR; do
      if [ "$ESCAPED" -eq 1 ]; then
        LINE="$LINE\\$CHAR"
        ESCAPED=0
      elif [ "$INQUOTE" -eq 1 ]; then
        case "$CHAR" in
          ("\\")
            ESCAPED=1
          ;;
          ('"')
            LINE="$LINE$CHAR"
            INQUOTE=0
          ;;
          (*)
            LINE="$LINE$CHAR"
          ;;
        esac
      else #INQUOTE=0
        case "$CHAR" in
          ("\\")
            ESCAPED=1
          ;;
          ('"')
            INQUOTE=1
            LINE="$LINE$CHAR"
          ;;
          ('{'|'}'|'['|']'|',')
            echo "$LINE"
            LINE=""
            echo "$CHAR"
          ;;
          (':')
            echo "$LINE"
            LINE=""
          ;;
          (*)
            LINE="$LINE$CHAR"
          ;;
        esac
      fi
    done | grep -vE '^\s*$'
  )
)
