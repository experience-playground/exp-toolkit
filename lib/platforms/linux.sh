#!/usr/bin/env bash
# exp-toolkit: Linux/WSL platform primitives

__exp_prim_download() {
  local url="$1"
  local dest="$2"
  local dir
  dir="$(dirname "$dest")"
  mkdir -p "$dir"
  echo "downloading $(basename "$dest")..."
  curl -fSL "$url" -o "$dest" || { echo "download failed: $url"; return 1; }
}

__exp_prim_install_script() {
  local script="$1"
  chmod +x "$script"
  local dir
  dir="$(dirname "$script")"
  (cd "$dir" && ./$(basename "$script")) || return 1
}

__exp_prim_install_pkg() {
  local pkg="$1"
  if [[ "$pkg" == *.deb ]]; then
    sudo dpkg -i "$pkg" || { sudo apt-get install -f -y; return 1; }
  elif [[ "$pkg" == *.rpm ]]; then
    sudo rpm -i "$pkg" || return 1
  else
    echo "unsupported package format: $pkg"
    return 1
  fi
}

__exp_prim_install_dmg() {
  echo "DMG installation is not supported on Linux"
  return 1
}

__exp_prim_npm_global() {
  local package="$1"
  npm install -g "$package" || return 1
}

__exp_prim_gem_global() {
  local package="$1"
  gem install "$package" || return 1
}

__exp_prim_curl_pipe_bash() {
  local url="$1"
  curl -fsSL "$url" | bash || return 1
}
