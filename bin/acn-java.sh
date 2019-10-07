function __acn_java {
   if [[ -z "$COMMAND" ]]; then
     echo "Available commands:"
     echo " install - install sdkman, groovy, gradle"
     echo " remove  - remove setup directory...doesn't remove any of the tools"
   fi
   case "$COMMAND" in
    install)
      git clone https://innersource.accenture.com/scm/dqt/java-local-setup.git "$ACN_PLATFORM_DIR"/java
      (cd "$ACN_PLATFORM_DIR"/java; ./setupjava.sh) || return 1
      echo "sdkman, java, groovy, and gradle are now installed";;
    remove)
      rm -rf "$ACN_PLATFORM_DIR/java";;
   esac
  return 0
}