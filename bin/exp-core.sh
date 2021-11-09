function __exp_list() {
  echo "available tools"
  echo " aws"
  echo " java"
  echo " nodejs"
  echo " heroku"
  return 0
}

function __exp_version() {
  echo "21.11-beta"
  return 0
}

function __exp_update() {
  (cd $EXP_HOME_DIR; git pull) || return 1
  return 0
}