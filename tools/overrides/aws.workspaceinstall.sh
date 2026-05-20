#!/usr/bin/env bash
# Override: aws workspaceinstall — platform-specific workspace client install

local platform
platform="$(__exp_detect_platform)"

case "$platform" in
  macos)
    local dir="$EXP_PLATFORM_DIR/aws"
    mkdir -p "$dir"
    curl -fSL "https://d2td7dqidlhjx7.cloudfront.net/prod/global/osx/WorkSpaces.pkg" -o "$dir/WorkSpaces.pkg"
    sudo installer -verbose -pkg "$dir/WorkSpaces.pkg" -target /
    ;;
  linux)
    if __exp_is_wsl; then
      echo "AWS WorkSpaces on Windows: opening download page..."
      powershell.exe -Command "Start-Process 'https://clients.amazonworkspaces.com/'"
      echo "Follow the installer in Windows."
      return 0
    fi
    echo "AWS WorkSpaces for Linux: please download from https://clients.amazonworkspaces.com/"
    ;;
esac

echo "AWS WorkSpaces client installed"
return 0
