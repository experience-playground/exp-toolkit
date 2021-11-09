function __exp_ruby {
   if [[ -z "$COMMAND" ]]; then
     echo "Available commands:"
     echo " install - install latest rvm (Ruby Version Manager)"
   fi

  case "$COMMAND" in
    install)
      mkdir -p "$EXP_PLATFORM_DIR/ruby"
      curl -sSL https://get.rvm.io -o "$EXP_PLATFORM_DIR"/ruby/install.sh
      chmod 777 "$EXP_PLATFORM_DIR"/ruby/install.sh
      (cd "$EXP_PLATFORM_DIR"/ruby; ./install.sh) || return 1
      echo "rvm install...exit shell and relaunch, then run 'rvm'";;
   esac


  return 0
}