function __exp_nodejs {
   if [[ -z "$COMMAND" ]]; then
     echo "Available commands:"
     echo " install - install nvm and latest nodjejs"
   fi
   case "$COMMAND" in
    install)
      mkdir -p "$EXP_PLATFORM_DIR/nodejs"
      curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh -o "$EXP_PLATFORM_DIR"/nodejs/install.sh
      chmod 777 "$EXP_PLATFORM_DIR"/nodejs/install.sh
      (cd "$EXP_PLATFORM_DIR"/nodejs; ./install.sh) || return 1
      echo "nvm install...exit shell and relaunch, then run 'nvm'";;
   esac
  return 0
}