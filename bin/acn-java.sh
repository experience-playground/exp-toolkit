function __acn_java {
   if [[ -z "$COMMAND" ]]; then
     echo "Available commands:"
     echo " install - install sdkman"
   fi
   case "$COMMAND" in
    install)

      mkdir -p "$ACN_PLATFORM_DIR/sdkman"
      curl -s "https://get.sdkman.io" -o "$ACN_PLATFORM_DIR/sdkman/install.sh"
      chmod 777 "$ACN_PLATFORM_DIR"/sdkman/install.sh
      (cd "$ACN_PLATFORM_DIR"/sdkman; ./install.sh) || return 1
      echo "sdkman installed";;
    remove)
   esac
  return 0
}