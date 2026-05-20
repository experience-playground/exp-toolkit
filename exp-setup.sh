#!/usr/bin/env bash

if [ -z "$EXP_HOME_DIR" ]; then
	export EXP_HOME_DIR="$HOME/.exp"
fi

if [ -d "$EXP_HOME_DIR" ]; then
	echo " $EXP_HOME_DIR exists, looks like you've already set this up before, this might cause problems"
	echo " if things just don't seem to work right rm -rf $EXP_HOME_DIR and start over"
fi

# Add sourcing to shell profiles that exist (or are expected)
INIT_LINE='[[ -s "$HOME/.exp/exp-init.sh" ]] && source "$HOME/.exp/exp-init.sh"'

# macOS uses .bash_profile; Linux/WSL uses .bashrc
if [[ -f "$HOME/.bash_profile" ]] || [[ "$(uname -s)" == "Darwin" ]]; then
	grep -qF "$INIT_LINE" "$HOME/.bash_profile" 2>/dev/null || echo "$INIT_LINE" >> "$HOME/.bash_profile"
fi

if [[ -f "$HOME/.bashrc" ]] || [[ "$(uname -s)" != "Darwin" ]]; then
	grep -qF "$INIT_LINE" "$HOME/.bashrc" 2>/dev/null || echo "$INIT_LINE" >> "$HOME/.bashrc"
fi

if [[ -f "$HOME/.zshrc" ]] || [[ "$(uname -s)" == "Darwin" ]]; then
	grep -qF "$INIT_LINE" "$HOME/.zshrc" 2>/dev/null || echo "$INIT_LINE" >> "$HOME/.zshrc"
fi

# Clone if not already present (exp-setup.ps1 may have already cloned)
if [ ! -d "$EXP_HOME_DIR/.git" ]; then
	git clone https://github.com/experience-playground/exp-toolkit.git "$EXP_HOME_DIR"
fi
(cd "$EXP_HOME_DIR" && git pull)

echo
echo "Either exit this window and relaunch, or type:"
echo
echo "  source \"$HOME/.exp/exp-init.sh\""
echo
echo "Once you've done either of these, type:"
echo
echo "  exp"

if type -p claude &>/dev/null; then
  printf "\nClaude Code detected. Would you like to add the exp skill to Claude? [y/N]: "
  read answer
  if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    mkdir -p "$HOME/.claude/skills/exp"
    cp "$EXP_HOME_DIR/.claude/skills/exp/SKILL.md" "$HOME/.claude/skills/exp/SKILL.md"
    echo "exp skill installed. Type /exp in Claude Code to use it."
  fi
fi
