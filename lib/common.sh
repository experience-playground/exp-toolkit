#!/usr/bin/env bash
# exp-toolkit: common library
# Config parser, dispatcher, platform detection, and core functions

__exp_detect_platform() {
  case "$(uname -s)" in
    Darwin)                    echo "macos" ;;
    Linux)                     echo "linux" ;;
    MINGW*|MSYS*|CYGWIN*)     echo "linux" ;; # Git Bash — treat as linux
    *)                         echo "unknown" ;;
  esac
}

__exp_is_wsl() {
  [[ -f /proc/version ]] && grep -qi microsoft /proc/version
}

# Load a tool .conf file — sets TOOL_* and INSTALL_* variables
# Unsets previous tool config first to avoid bleed between tools
__exp_load_tool_config() {
  local conf_file="$1"
  # Clear previous config
  unset TOOL_NAME TOOL_DESCRIPTION TOOL_PLATFORMS TOOL_DEPENDENCIES TOOL_COMMANDS TOOL_ALIASES
  unset INSTALL_STRATEGY INSTALL_URL_MACOS INSTALL_URL_LINUX
  unset INSTALL_STRATEGY_WINDOWS INSTALL_URL_WINDOWS
  unset POST_INSTALL_MSG NPM_PACKAGE GEM_PACKAGE OS_COMMAND
  unset SCRIPT_DIR DMG_APP_NAME DMG_VOLUME_NAME PKG_PATH
  # Source it — .conf files are valid bash variable assignments
  source "$conf_file"
}

# Resolve the install URL for the current platform
__exp_resolve_url() {
  local platform="$1"
  case "$platform" in
    macos)  echo "$INSTALL_URL_MACOS" ;;
    linux)  echo "$INSTALL_URL_LINUX" ;;
  esac
}

# Resolve the install strategy for the current platform
__exp_resolve_strategy() {
  local platform="$1"
  # Check for platform-specific override first
  case "$platform" in
    linux)
      if [[ -n "$INSTALL_STRATEGY_LINUX" ]]; then
        echo "$INSTALL_STRATEGY_LINUX"
        return
      fi
      ;;
  esac
  echo "$INSTALL_STRATEGY"
}

# Check if a tool's dependencies are satisfied
__exp_check_dependencies() {
  local deps="$TOOL_DEPENDENCIES"
  [[ -z "$deps" ]] && return 0

  local IFS=','
  for dep in $deps; do
    dep="$(echo "$dep" | xargs)" # trim whitespace
    case "$dep" in
      nodejs)
        if ! type -p npm &>/dev/null; then
          echo "please install nodejs first: exp nodejs install"
          return 1
        fi
        ;;
      ruby)
        if ! type -p gem &>/dev/null; then
          echo "please install ruby first: exp ruby install"
          return 1
        fi
        ;;
      *)
        if ! type -p "$dep" &>/dev/null; then
          echo "please install $dep first: exp $dep install"
          return 1
        fi
        ;;
    esac
  done
  return 0
}

# Auto-generate tool list from .conf files, filtered by platform
__exp_list() {
  local platform
  platform="$(__exp_detect_platform)"
  echo "available tools"
  for conf in "$EXP_HOME_DIR"/tools/*.conf; do
    [[ -f "$conf" ]] || continue
    __exp_load_tool_config "$conf"
    # Check if this tool supports the current platform
    if [[ ",$TOOL_PLATFORMS," == *",$platform,"* ]]; then
      local extra=""
      [[ -n "$TOOL_DEPENDENCIES" ]] && extra=" (requires $TOOL_DEPENDENCIES)"
      echo " $TOOL_NAME$extra — $TOOL_DESCRIPTION"
    fi
  done
  return 0
}

__exp_version() {
  echo "27.0"
  return 0
}

__exp_update() {
  (cd "$EXP_HOME_DIR" && git pull) || return 1
  source "$EXP_HOME_DIR/exp-init.sh"
  return 0
}

# Find the .conf file for a tool name (supports aliases)
__exp_find_tool_conf() {
  local name="$1"
  # Direct match first
  if [[ -f "$EXP_HOME_DIR/tools/${name}.conf" ]]; then
    echo "$EXP_HOME_DIR/tools/${name}.conf"
    return 0
  fi
  # Search aliases
  for conf in "$EXP_HOME_DIR"/tools/*.conf; do
    [[ -f "$conf" ]] || continue
    __exp_load_tool_config "$conf"
    if [[ -n "$TOOL_ALIASES" ]]; then
      local IFS=','
      for alias in $TOOL_ALIASES; do
        alias="$(echo "$alias" | xargs)"
        if [[ "$alias" == "$name" ]]; then
          echo "$conf"
          return 0
        fi
      done
    fi
  done
  return 1
}

# Execute a tool's install command via platform primitives
__exp_execute_install() {
  local platform="$1"
  local strategy
  strategy="$(__exp_resolve_strategy "$platform")"
  local url
  url="$(__exp_resolve_url "$platform")"

  case "$strategy" in
    script)
      local dir="$EXP_PLATFORM_DIR/${SCRIPT_DIR:-$TOOL_NAME}"
      __exp_prim_download "$url" "$dir/install.sh" || return 1
      __exp_prim_install_script "$dir/install.sh" || return 1
      ;;
    pkg)
      local dir="$EXP_PLATFORM_DIR/${SCRIPT_DIR:-$TOOL_NAME}"
      local pkg_name="${PKG_PATH:-install.pkg}"
      __exp_prim_download "$url" "$dir/$pkg_name" || return 1
      __exp_prim_install_pkg "$dir/$pkg_name" || return 1
      ;;
    dmg)
      local dir="$EXP_PLATFORM_DIR/${SCRIPT_DIR:-$TOOL_NAME}"
      local dmg_file="$dir/${TOOL_NAME}.dmg"
      __exp_prim_download "$url" "$dmg_file" || return 1
      __exp_prim_install_dmg "$dmg_file" "$DMG_VOLUME_NAME" "$DMG_APP_NAME" "$PKG_PATH" || return 1
      ;;
    npm_global)
      __exp_prim_npm_global "$NPM_PACKAGE" || return 1
      ;;
    gem_global)
      __exp_prim_gem_global "$GEM_PACKAGE" || return 1
      ;;
    curl_pipe_bash)
      __exp_prim_curl_pipe_bash "$url" || return 1
      ;;
    os_command)
      eval "$OS_COMMAND" || return 1
      ;;
    custom)
      echo "error: custom strategy requires an override script"
      return 1
      ;;
    *)
      echo "error: unknown install strategy '$strategy'"
      return 1
      ;;
  esac

  [[ -n "$POST_INSTALL_MSG" ]] && echo "$POST_INSTALL_MSG"
  return 0
}

# Main dispatcher — replaces the old exp() function
exp() {
  local tool_name="$1"
  local command="$2"

  # Normalize shorthand
  case "$command" in
    i) command="install" ;;
  esac

  # No args — show help
  if [[ -z "$tool_name" ]]; then
    cat "$EXP_HOME_DIR/text/exp.txt"
    return 1
  fi

  # Core commands
  case "$tool_name" in
    list)    __exp_list; return $? ;;
    version) __exp_version; return $? ;;
    update)  __exp_update; return $? ;;
  esac

  # Find tool config
  local conf_file
  conf_file="$(__exp_find_tool_conf "$tool_name")"
  if [[ $? -ne 0 || -z "$conf_file" ]]; then
    echo "unknown tool: $tool_name"
    echo "run 'exp list' to see available tools"
    return 1
  fi

  __exp_load_tool_config "$conf_file"

  # Check platform support
  local platform
  platform="$(__exp_detect_platform)"
  if [[ ",$TOOL_PLATFORMS," != *",$platform,"* ]]; then
    echo "$TOOL_NAME is not available on $platform"
    return 1
  fi

  # No command — show available commands
  if [[ -z "$command" ]]; then
    echo "Available commands for $TOOL_NAME:"
    local IFS=','
    for cmd in $TOOL_COMMANDS; do
      cmd="$(echo "$cmd" | xargs)"
      echo " $cmd"
    done
    return 0
  fi

  # Check if an override script exists for this command
  local override="$EXP_HOME_DIR/tools/overrides/${TOOL_NAME}.${command}.sh"
  if [[ -f "$override" ]]; then
    source "$override"
    return $?
  fi

  # Handle install via platform primitives
  if [[ "$command" == "install" ]]; then
    __exp_check_dependencies || return 1
    __exp_execute_install "$platform"
    return $?
  fi

  echo "unknown command: $command"
  echo "run 'exp $tool_name' to see available commands"
  return 1
}
