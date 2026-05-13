function __exp_list() {
  echo "available tools"
  echo " aws"
  echo " java"
  echo " nodejs"
  echo " heroku (requires nodejs)"
  echo " ruby"
  echo " shopify (requires ruby)"
  echo " xcode"
  echo " virtualbox"
  echo " claude"
  return 0
}

function __exp_version() {
  echo "26.6"
  return 0
}

function __exp_update() {
  (cd $EXP_HOME_DIR; git pull) || return 1
  source "$EXP_HOME_DIR/exp-init.sh"
  return 0
}