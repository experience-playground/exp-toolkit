function exp {
  PLATFORM="$1"
  COMMAND="$2"
  case "$COMMAND" in
    i)
      COMMAND="install";;
  esac


  if [[ -z "$PLATFORM" ]]; then
    echo "help"
		cat "$EXP_HOME_DIR/text/exp.txt"
		return 1
	else
    __exp_"$PLATFORM" "$COMMAND"
  fi


  return 0
}