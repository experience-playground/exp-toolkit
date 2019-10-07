function __acn_aws {
   if [[ -z "$COMMAND" ]]; then
     echo "Available commands:"
     echo " install - install aws cli"
   fi
   case "$COMMAND" in
    install)
      (cd "$ACN_PLATFORM_DIR"/aws; ./setupaws.sh) || return 1
      echo "awscli installed";;
   esac
  return 0
}