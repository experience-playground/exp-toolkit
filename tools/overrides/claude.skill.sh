#!/usr/bin/env bash
# Override: claude skill — install exp skill for Claude Code

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
return 0
