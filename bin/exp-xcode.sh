function __exp_xcode {
   if [[ -z "$COMMAND" ]]; then
     echo "Available commands:"
     echo " install - install latest xcode"
   fi


   case "$COMMAND" in
            install)
              sudo xcode-select --install

   esac

  return 0
}