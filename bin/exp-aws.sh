function __exp_aws {
   if [[ -z "$COMMAND" ]]; then
     echo "Available commands:"
     echo " install - install aws cli"
     echo " workspaceinstall - install aws workspace pkg"
   fi
   case "$COMMAND" in
    install)
      (cd "$EXP_PLATFORM_DIR"/aws; ./setupaws.sh) || return 1
      echo "awscli installed";;
    workspaceinstall)
      (cd "$EXP_PLATFORM_DIR"/aws; ./setupworkspace.sh) || return 1
      echo "aws workspaces installed";;
   esac
  return 0
}