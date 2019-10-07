#!/usr/bin/env bash
if [[ -z "$ACN_HOME_DIR" ]]; then
  export ACN_HOME_DIR=$HOME/.acn
fi

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
