function __exp_xcode {
   if [[ -z "$COMMAND" ]]; then
     echo "Available commands:"
     echo " install - install latest xcode cli"
   fi


   case "$COMMAND" in
            install)
              sudo xcodebuild -license accept

   esac

  return 0
}