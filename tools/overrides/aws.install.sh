#!/usr/bin/env bash
# Override: aws install — macOS uses .pkg, Linux uses .zip

local platform
platform="$(__exp_detect_platform)"

case "$platform" in
  macos)
    local dir="$EXP_PLATFORM_DIR/aws"
    mkdir -p "$dir"
    curl -fSL "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "$dir/awscli-v2.pkg"
    sudo installer -verbose -pkg "$dir/awscli-v2.pkg" -target /
    ;;
  linux)
    local dir="$EXP_PLATFORM_DIR/aws"
    mkdir -p "$dir"
    curl -fSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "$dir/awscliv2.zip"
    (cd "$dir" && unzip -o awscliv2.zip && sudo ./aws/install) || return 1
    ;;
esac

aws --version
echo "AWS CLI installed"
return 0
