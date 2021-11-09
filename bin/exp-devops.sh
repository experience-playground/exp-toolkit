function __exp_devops {
   if [[ -z "$COMMAND" ]]; then
     echo "Available commands:"
     echo " install - install devops toolchains"
   fi
   case "$COMMAND" in
    install)

      echo "devops install";;
   esac
  return 0
}