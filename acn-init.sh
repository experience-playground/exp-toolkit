#!/usr/bin/env bash
export ACN_HOME_DIR=`dirname "$0"`

ACN_PLATFORM_DIR="$ACN_HOME_DIR/platforms"
OLD_IFS="$IFS"
IFS=$'\n'
scripts=($(find "${ACN_HOME_DIR}/bin" -type f -name 'acn-*'))
for f in "${scripts[@]}"; do
  source "$f"
done
IFS="$OLD_IFS"
unset scripts f

unset OLD_IFS
