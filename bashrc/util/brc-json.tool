#!/bin/bash

#
# Push an item onto a stack
# Usage: push $ELEMENT $STACK
push() {
  ELEMENT=$1
  ARRAY=$2
  ARRAY=("${ARRAY[@]}" "$ELEMENT")
}

#
# Get the top item from a stack
# Usage: ELEMENT=$( pop $STACK )
pop() {
  ARRAY=$1
  ELEMENT=${ARRAY[ $(( ${#ARRAY[*]} - 1 )) ]}
  unset ARRAY[ $(( ${#ARRAY[*]} - 1 )) ]
  echo $ELEMENT
}


CSTACK=(0)
PSTACK=(0)

PREFIX="bashrc"
cat | sed -e's/":/"\n:\n/g' \
          -e's/{/\n{\n/g' \
          -e's/}/\n}\n/g' \
          -e's/\[/\n\[\n/g' \
          -e's/\]/\n\]\n/g' \
          -e's/,/\n,\n/g' \
    | grep -vE '^\s*$' \
    | while read LINE; do
  LINE=$(echo "$LINE" | tr -d '"')
  if [ "$LINE" == ':' ]; then
  # if [ PREFIX == top(PSTACK) ]; then
    POS=${PSTACK[ $(( ${#PSTACK[*]} - 1 )) ]}
    if [ "$PREFIX" == "$POS" ]; then
      COUNT=${CSTACK[ $(( ${#CSTACK[*]} - 1 )) ]} #top(CSTACK)
      LASTLINE="$LASTLINE.$COUNT"
    fi
    PREFIX="$PREFIX~$LASTLINE"
  elif [ "$LINE" == '{' ]; then
  # if [ PREFIX == top(PSTACK) ]; then
    POS=${PSTACK[ $(( ${#PSTACK[@]} - 1 )) ]}
    if [ "$PREFIX" == "$POS" ]; then
      # increment top of CSTACK
      SIZE=$(( ${#CSTACK[*]} - 1 ))
      COUNT=${CSTACK[ $SIZE ]} #top
      COUNT=$(( $COUNT + 1 ))
      CSTACK[$SIZE]=$COUNT #push
    fi
  elif [[ "$LINE" == '}' || "$LINE" == ',' ]]; then
#  elif [ "$LINE" == ',' ]; then
    if [ "$LASTLINE" != '}' ]; then
      PREFIX=$(echo $PREFIX | sed 's/^\(.*\)~.*$/\1/')
    fi
  # if [ PREFIX == top(PSTACK) ]; then
#    if [ "$PREFIX" == "${PSTACK[ $(( ${#PSTACK[*]} - 1 )) ]}" ]; then
#      pop PSTACK
#      pop CSTACK
  elif [ "$LINE" == '[' ]; then
    CSTACK=("${CSTACK[@]}" 0)         #push 0
    PSTACK=("${PSTACK[@]}" "$PREFIX") #push $PREFIX
  elif [ "$LINE" == ']' ]; then
    POS=$(( ${#CSTACK[*]} - 1 ))
    unset CSTACK[$POS] #pop(CSTACK)
    unset PSTACK[$POS] #pop(PSTACK)
    PREFIX=$(echo $PREFIX | sed 's/^\(.*\).'$NAME'$/\1/')
#  elif [ "$LINE" != '}' ]; then
  else
    echo $PREFIX~$LINE
  fi
  LASTLINE="$LINE"
done


