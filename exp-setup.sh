#!/usr/bin/env bash

if [ -z "$EXP_HOME_DIR" ]; then
	export EXP_HOME_DIR="$HOME/.exp"
fi
if [ -d $EXP_HOME_DIR ]; then
	  echo " $EXP_HOME_DIR exists, looks like you've already set this up before, this might cause problems"
	  echo " if things just don't seem  to work right rm -rf $EXP_HOME_DIR and start over"
	  echo " if that doesn't work, drop an email to ???"
fi
echo "[[ -s \"$HOME/.exp/exp-init.sh\" ]] && source \"$HOME/.exp/exp-init.sh\"" >> "$HOME/.bash_profile"
echo "[[ -s \"$HOME/.exp/exp-init.sh\" ]] && source \"$HOME/.exp/exp-init.sh\"" >> "$HOME/.zshrc"

git clone https://github.com/experience-playground/exp-toolkit.git $EXP_HOME_DIR
(cd $EXP_HOME_DIR; git pull)
echo
echo "either exit this window and relauch\n or type:"
echo
echo "[[ -s \"$HOME/.exp/exp-init.sh\" ]] && source \"$HOME/.exp/exp-init.sh\""
echo
echo "once you've done either of these, type:"
echo
echo "exp"

if type -p claude &>/dev/null; then
  printf "\nClaude Code detected. Would you like to add the exp-help skill to Claude? [y/N]: "
  read answer
  if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    mkdir -p "$HOME/.claude/skills/exp-help"
    cp "$EXP_HOME_DIR/.claude/skills/exp-help/SKILL.md" "$HOME/.claude/skills/exp-help/SKILL.md"
    echo "exp-help skill installed. Type /exp-help in Claude Code to use it."
  fi
fi
