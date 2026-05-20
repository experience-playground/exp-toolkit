#!/usr/bin/env bash
# Override: claude install — interactive menu for Desktop/Code/Both

__exp_claude_desktop_macos() {
  local dir="$EXP_PLATFORM_DIR/claude"
  mkdir -p "$dir"
  curl -fSL https://claude.ai/api/desktop/darwin/universal/dmg/latest/redirect -o "$dir/Claude.dmg"
  hdiutil attach "$dir/Claude.dmg"
  cp -R /Volumes/Claude/Claude.app /Applications/
  hdiutil detach /Volumes/Claude
  rm -f "$dir/Claude.dmg"
  echo "Claude desktop app installed"
}

__exp_claude_desktop_linux() {
  echo "Claude Desktop for Linux: please download from https://claude.ai/download"
  echo "(Automated Linux install not yet supported)"
}

__exp_claude_desktop_wsl() {
  echo "Installing Claude Desktop as a Windows app..."
  powershell.exe -Command "Start-Process 'https://claude.ai/download'"
  echo "Opening download page in Windows browser. Follow the installer."
}

__exp_claude_code() {
  curl -fsSL https://claude.ai/install.sh | bash
  echo "Claude Code CLI installed"
}

# --- main ---
echo "What would you like to install?"
echo " 1) Claude Desktop app"
echo " 2) Claude Code CLI"
echo " 3) Both"
printf "Enter choice [1-3]: "
read choice

local platform
platform="$(__exp_detect_platform)"

case "$choice" in
  1)
    if __exp_is_wsl; then
      __exp_claude_desktop_wsl
    elif [[ "$platform" == "macos" ]]; then
      __exp_claude_desktop_macos
    else
      __exp_claude_desktop_linux
    fi
    ;;
  2)
    __exp_claude_code
    ;;
  3)
    if __exp_is_wsl; then
      __exp_claude_desktop_wsl
    elif [[ "$platform" == "macos" ]]; then
      __exp_claude_desktop_macos
    else
      __exp_claude_desktop_linux
    fi
    __exp_claude_code
    ;;
  *)
    echo "Invalid choice"
    return 1
    ;;
esac
return 0
