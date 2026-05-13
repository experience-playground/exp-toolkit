function __exp_claude {
   if [[ -z "$COMMAND" ]]; then
     echo "Available commands:"
     echo " install - install Claude (desktop, code cli, or both)"
     echo " skill   - install exp-help skill for Claude Code"
   fi

   case "$COMMAND" in
            install)
              echo "What would you like to install?"
              echo " 1) Claude Desktop app"
              echo " 2) Claude Code CLI"
              echo " 3) Both"
              printf "Enter choice [1-3]: "
              read choice

              case "$choice" in
                1)
                  __exp_claude_desktop
                  ;;
                2)
                  __exp_claude_code
                  ;;
                3)
                  __exp_claude_desktop
                  __exp_claude_code
                  ;;
                *)
                  echo "Invalid choice"
                  return 1
                  ;;
              esac
              ;;
            skill)
              __exp_claude_skill
              ;;

   esac

  return 0
}

function __exp_claude_desktop {
  mkdir -p "$EXP_PLATFORM_DIR/claude"
  curl -fSL https://claude.ai/api/desktop/darwin/universal/dmg/latest/redirect -o "$EXP_PLATFORM_DIR"/claude/Claude.dmg
  hdiutil attach "$EXP_PLATFORM_DIR"/claude/Claude.dmg
  cp -R /Volumes/Claude/Claude.app /Applications/
  hdiutil detach /Volumes/Claude
  rm -f "$EXP_PLATFORM_DIR"/claude/Claude.dmg
  echo "Claude desktop app installed"
}

function __exp_claude_code {
  curl -fsSL https://claude.ai/install.sh | bash
  echo "Claude Code CLI installed"
}

function __exp_claude_skill {
  mkdir -p "$HOME/.claude/skills/exp"
  cp "$EXP_HOME_DIR/.claude/skills/exp/SKILL.md" "$HOME/.claude/skills/exp/SKILL.md"

  # Add exp guidance to global CLAUDE.md if not already present
  local claude_md="$HOME/.claude/CLAUDE.md"
  local marker="/exp"
  if [ -f "$claude_md" ]; then
    if ! grep -q "$marker" "$claude_md"; then
      printf '\n## exp-toolkit\n- If the user asks about installing or managing dev tools (Node.js, Java, Ruby, AWS, etc.) or asks about the `exp` command, suggest they use `/exp` for guided assistance.\n' >> "$claude_md"
    fi
  else
    printf '## exp-toolkit\n- If the user asks about installing or managing dev tools (Node.js, Java, Ruby, AWS, etc.) or asks about the `exp` command, suggest they use `/exp` for guided assistance.\n' > "$claude_md"
  fi

  echo "exp skill installed. Type /exp in Claude Code to use it."
}
