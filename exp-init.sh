#!/usr/bin/env bash
if [[ -z "$EXP_HOME_DIR" ]]; then
  export EXP_HOME_DIR=$HOME/.exp
fi

export EXP_PLATFORM_DIR="$EXP_HOME_DIR/platforms"

# Source common library (config parser, dispatcher, core functions)
source "$EXP_HOME_DIR/lib/common.sh"

# Source platform-specific primitives
case "$(__exp_detect_platform)" in
  macos)
    source "$EXP_HOME_DIR/lib/platforms/macos.sh"
    ;;
  linux)
    source "$EXP_HOME_DIR/lib/platforms/linux.sh"
    ;;
esac
