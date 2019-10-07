#!/usr/bin/env bash

if [ -z "$ACN_HOME_DIR" ]; then
	export ACN_HOME_DIR="$HOME/.acn"
	git clone https://innersource.accenture.com/scm/dqt/start-here.git $ACN_HOME_DIR
fi
(cd $ACN_HOME_DIR; git pull)

echo "[[ -s \"$HOME/.acn/acn-init.sh\" ]] && source \"$HOME/.acn/acn-init.sh\"" >> "$HOME/.bash_profile"
source "$ACN_HOME_DIR/acn-init.sh"





