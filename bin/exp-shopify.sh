function __exp_shopify {
   if ! npm_loc="$(type -p "gem")" || [[ -z $npm_loc ]]; then
     echo "please install ruby first:"
     echo "exp ruby install"
     return 1
   fi

   if [[ -z "$COMMAND" ]]; then
     echo "Available commands:"
     echo " install - install latest Shopify cli"
   fi


   case "$COMMAND" in
            install)
              gem install shopify-cli
              echo "gem install...exit shell and relaunch, then run 'shopify'";;
   esac

  return 0
}