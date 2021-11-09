#!/usr/bin/env bash
if [[ -z "$EXP_HOME_DIR" ]]; then
  export EXP_HOME_DIR=$HOME/.acn
fi

ACN_PLATFORM_DIR="$EXP_HOME_DIR/platforms"
OLD_IFS="$IFS"
IFS=$'\n'
scripts=($(find "${EXP_HOME_DIR}/bin" -type f -name 'exp-*'))
for f in "${scripts[@]}"; do
  source "$f"
done
IFS="$OLD_IFS"
unset scripts f

unset OLD_IFS
