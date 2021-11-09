function __exp_heroku {
   if ! npm_loc="$(type -p "npm")" || [[ -z $npm_loc ]]; then
     echo "please install nodejs first:"
     echo "exp nodejs install"
     return 1
   fi

   if [[ -z "$COMMAND" ]]; then
     echo "Available commands:"
     echo " install - install latest Heroku cli"
   fi


   case "$COMMAND" in
            install)
              npm install -g heroku
              echo "nvm install...exit shell and relaunch, then run 'heroku'";;
   esac

  return 0
}