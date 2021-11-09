function __exp_heroku {
   if [[ -z "$COMMAND" ]]; then
     echo "Available commands:"
     echo " install - install latest Heroku cli"
   fi
   case "$COMMAND" in
    install)
      mkdir -p "$EXP_PLATFORM_DIR/heroku"
      curl https://cli-assets.heroku.com/install.sh -o "$EXP_PLATFORM_DIR"/heroku/install.sh
      chmod 777 "$EXP_PLATFORM_DIR"/heroku/install.sh
      (cd "$EXP_PLATFORM_DIR"/heroku; ./install.sh) || return 1
      echo "nvm install...exit shell and relaunch, then run 'heroku'";;
   esac
  return 0
}