#!/bin/bash

function errorcurlfail() {
  echo "ERROR: Attempt to reach API (a curl command) failed.  This depends on endpoints"
  echo "  being properly defined in your environment.  Make sure you've sourced the"
  echo "  bashrc.bash file.  See the README file for more information."
  exit 1
}

function errornot200() {
  CODE=$1
  shift 1
  echo "$@"
  echo
  echo "ERROR: API call unsuccessful"
  echo "Response code: $CODE"
  echo "Raw response data above."
  exit 1
}

