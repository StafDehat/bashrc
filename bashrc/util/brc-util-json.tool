#!/bin/bash

CSTACK=(0)
PSTACK=(0)

PREFIX="bashrc"
DROPPED=""

while read LINE; do
  if [ $( echo "$LINE" | grep -c "$PREFIX" ) -eq 0 ]; then
    echo $PREFIX
  fi
  PREFIX="$LINE"
done < <(
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
    if [ "$LASTLINE" == ',' ]; then
      PREFIX="$PREFIX~$DROPPED"
    fi
    POS=${PSTACK[ $(( ${#PSTACK[@]} - 1 )) ]}
    if [ "$PREFIX" == "$POS" ]; then
      # increment top(CSTACK)
      SIZE=$(( ${#CSTACK[*]} - 1 ))
      COUNT=${CSTACK[ $SIZE ]} #top
      COUNT=$(( $COUNT + 1 ))
      CSTACK[$SIZE]=$COUNT #push
    fi
  elif [[ "$LINE" == '}' || "$LINE" == ',' ]]; then
    # Problem is here
    #if [ "$LASTLINE" != '}' ]; then
      # Strip a PREFIX level
      DROPPED=$(echo $PREFIX | sed 's/^\(.*\)~\(.*\)$/\2/')
      PREFIX=$(echo $PREFIX | sed 's/^\(.*\)~\(.*\)$/\1/')
    #fi
  elif [ "$LINE" == '[' ]; then
    CSTACK=("${CSTACK[@]}" 0)         #push 0
    PSTACK=("${PSTACK[@]}" "$PREFIX") #push $PREFIX
  elif [ "$LINE" == ']' ]; then
    POS=$(( ${#CSTACK[*]} - 1 ))
    unset CSTACK[$POS] #pop(CSTACK)
    unset PSTACK[$POS] #pop(PSTACK)
    #DROPPED=$(echo $PREFIX | sed 's/^\(.*\).\('$NAME'\)$/\2/')
    PREFIX=$(echo $PREFIX | sed 's/^\(.*\).'$NAME'$/\1/')
  else
    echo $PREFIX~$LINE
  fi
  LASTLINE="$LINE"
done
)
echo $PREFIX

