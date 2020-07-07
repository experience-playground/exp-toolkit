#!/usr/bin/env bash

if [ -z "$ACN_HOME_DIR" ]; then
	export ACN_HOME_DIR="$HOME/.acn"
fi
if [ -d $ACN_HOME_DIR ]; then
	  echo " $ACN_HOME_DIR exists, looks like you've already set this up before, this might cause problems"
	  echo " if things just don't seem  to work right rm -rf $ACN_HOME_DIR and start over"
	  echo " if that doesn't work, drop an email to ???"
fi
echo "[[ -s \"$HOME/.acn/acn-init.sh\" ]] && source \"$HOME/.acn/acn-init.sh\"" >> "$HOME/.bash_profile"
git clone https://innersource.accenture.com/scm/dqt/start-here.git $ACN_HOME_DIR
(cd $ACN_HOME_DIR; git pull)
echo
echo "either exit this window and relauch\n or type:"
echo
echo "[[ -s \"$HOME/.acn/acn-init.sh\" ]] && source \"$HOME/.acn/acn-init.sh\""
echo
echo "once you've done either of these, type:"
echo
echo "acn"

