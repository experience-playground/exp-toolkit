#!/usr/bin/env bash
# exp-toolkit: macOS platform primitives

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
  sudo installer -verbose -pkg "$pkg" -target / || return 1
}

__exp_prim_install_dmg() {
  local dmg="$1"
  local volume_name="$2"
  local app_name="$3"
  local pkg_path="$4" # optional — if set, install .pkg from DMG instead of copying .app

  hdiutil attach "$dmg" || { echo "failed to mount $dmg"; return 1; }

  if [[ -n "$pkg_path" ]]; then
    # Install a .pkg from inside the DMG
    sudo installer -pkg "/Volumes/${volume_name}/${pkg_path}" -target /Volumes/Macintosh\ HD
  elif [[ -n "$app_name" ]]; then
    # Copy .app to /Applications
    cp -R "/Volumes/${volume_name}/${app_name}" /Applications/
  fi

  hdiutil detach "/Volumes/${volume_name}"
  rm -f "$dmg"
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
