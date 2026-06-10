#!/usr/bin/env bash
# Override: openai-tunnel install — downloads arch-specific zip from OpenAI CDN

local platform
platform="$(__exp_detect_platform)"

local arch
case "$(uname -m)" in
  arm64|aarch64) arch="arm64" ;;
  *)             arch="amd64" ;;
esac

local version="v0.0.9--context-conduit-topaz"
local base_url="https://persistent.oaistatic.com/tunnel-client/${version}"

case "$platform" in
  macos)
    local os="darwin"
    ;;
  linux)
    local os="linux"
    ;;
  *)
    echo "error: unsupported platform: $platform"
    return 1
    ;;
esac

local filename="tunnel-client-${version}-${os}-${arch}.zip"
local url="${base_url}/${filename}"

local dir="$EXP_PLATFORM_DIR/openai-tunnel"
mkdir -p "$dir"

echo "Downloading tunnel-client ${version} for ${os} (${arch})..."
curl -fSL "$url" -o "$dir/tunnel-client.zip" || return 1
unzip -o "$dir/tunnel-client.zip" -d "$dir"
chmod +x "$dir/tunnel-client"
sudo ln -sf "$dir/tunnel-client" /usr/local/bin/tunnel-client

tunnel-client --version 2>/dev/null || echo "tunnel-client installed"
return 0
