function __acn_list() {
  echo "available tools"
  echo " aws"
  echo " java"
  return 0
}

function __acn_version() {
  echo "0.1-beta"
  return 0
}

function __acn_update() {
  (cd $ACN_HOME_DIR; git pull) || return 1
  source $ACN_HOME_DIR/acn-init.sh
  return 0
}