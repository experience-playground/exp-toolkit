function acn {
  PLATFORM="$1"
  COMMAND="$2"
  case "$COMMAND" in
    i)
      COMMAND="install";;
  esac


  if [[ -z "$PLATFORM" ]]; then
    echo "help"
		cat "$ACN_HOME_DIR/text/acn.txt"
		return 1
	else
    __acn_"$PLATFORM" "$COMMAND"
  fi


  return 0
}