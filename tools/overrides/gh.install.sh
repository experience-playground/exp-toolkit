#!/usr/bin/env bash
# Override: gh install — macOS uses arch-specific zip from GitHub releases, Linux uses apt repo

local platform
platform="$(__exp_detect_platform)"

case "$platform" in
  macos)
    local arch
    case "$(uname -m)" in
      arm64) arch="arm64" ;;
      *)     arch="amd64" ;;
    esac

    # Resolve latest version from GitHub API
    local version
    version="$(curl -fsSL https://api.github.com/repos/cli/cli/releases/latest | sed -n 's/.*"tag_name": "v\([^"]*\)".*/\1/p')"
    if [[ -z "$version" ]]; then
      echo "error: could not determine latest gh version"
      return 1
    fi

    local dir="$EXP_PLATFORM_DIR/gh"
    mkdir -p "$dir"
    local url="https://github.com/cli/cli/releases/download/v${version}/gh_${version}_macOS_${arch}.zip"
    echo "Downloading gh ${version} for macOS (${arch})..."
    curl -fSL "$url" -o "$dir/gh.zip" || return 1
    unzip -o "$dir/gh.zip" -d "$dir"
    ln -sf "$dir/gh_${version}_macOS_${arch}/bin/gh" /usr/local/bin/gh
    ;;
  linux)
    echo "Adding GitHub CLI apt repository..."
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
      | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg 2>/dev/null
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
      | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update && sudo apt install -y gh || return 1
    ;;
esac

gh --version
echo "GitHub CLI installed"
return 0
