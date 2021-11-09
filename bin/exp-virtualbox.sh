function __exp_vbox {
   if [[ -z "$COMMAND" ]]; then
     echo "Available commands:"
     echo " install - install latest virtualbox"
   fi


   case "$COMMAND" in
            install)
              mkdir -p "$EXP_PLATFORM_DIR/virtualbox"
              curl https://download.virtualbox.org/virtualbox/6.1.28/VirtualBox-6.1.28-147628-OSX.dmg -o "$EXP_PLATFORM_DIR"/virtualbox/virtualbox.dmg
              hdiutil attach "$EXP_PLATFORM_DIR"/virtualbox/virtualbox.dmg
              sudo installer -pkg /Volumes/VirtualBox/VirtualBox.pkg -target /Volumes/Macintosh\ HD

              echo "virtual box install";;

   esac

  return 0
}