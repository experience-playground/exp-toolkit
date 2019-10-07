function __acn_nodejs {
   if [[ -z "$COMMAND" ]]; then
     echo "Available commands:"
     echo " install - install nvm and latest nodjejs"
   fi
   case "$COMMAND" in
    install)
      curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.0/install.sh -o "$ACN_PLATFORM_DIR"/nodejs/install.sh
      chmod 777 "$ACN_PLATFORM_DIR"/nodejs/install.sh
      (cd "$ACN_PLATFORM_DIR"/nodejs; ./install.sh) || return 1
      echo "nvm install...exit shell and relaunch, then run 'nvm'";;
   esac
  return 0
}