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
  mkdir -p "$HOME/.claude/skills/exp-help"
  cp "$EXP_HOME_DIR/.claude/skills/exp-help/SKILL.md" "$HOME/.claude/skills/exp-help/SKILL.md"
  echo "exp-help skill installed. Type /exp-help in Claude Code to use it."
}
