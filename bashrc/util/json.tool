#!/bin/bash

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
    PREFIX="$PREFIX:$LASTLINE"
    if [ "$LASTLINE" == 'name' ]; then
      read LINE
      NAME=$(echo "$LINE" | tr -d '"')
      echo $PREFIX:$NAME
    fi
  elif [[ "$LINE" == '}' || "$LINE" == ',' ]]; then
    PREFIX=$(echo $PREFIX | sed 's/^\(.*\):.*$/\1/')
  elif [ "$LINE" == '[' ]; then
    PREFIX="$PREFIX.$NAME"
  elif [ "$LINE" == ']' ]; then
    PREFIX=$(echo $PREFIX | sed 's/^\(.*\).'$NAME'$/\1/')
  elif [ "$LINE" != '{' ]; then
    echo $PREFIX:$LINE
  fi
  LASTLINE="$LINE"
done
