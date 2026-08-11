# Architecture

## Overview

exp-toolkit is a shell-based tool installer and manager. Users run `exp <tool> install` to install development tools on macOS, Linux, or Windows (via WSL). Tools are defined declaratively via `.conf` files; complex installations use imperative override scripts.

## Directory Structure

```
exp-toolkit/
├── exp-init.sh                 # Shell session entry point (sourced by ~/.bashrc etc.)
├── exp-setup.sh                # First-time setup script (macOS/Linux)
├── exp-setup.ps1               # First-time setup script (Windows — installs WSL, then runs exp-setup.sh)
├── lib/
│   ├── common.sh               # Dispatcher, config loader, dependency checker, platform detection
│   └── platforms/
│       ├── macos.sh            # macOS platform primitives (download, install pkg/dmg/script, etc.)
│       └── linux.sh            # Linux platform primitives (same function signatures)
├── tools/
│   ├── *.conf                  # Tool configuration files (one per tool)
│   └── overrides/
│       └── *.install.sh        # Custom install scripts for tools that need imperative logic
├── text/
│   └── exp.txt                 # Help text shown by `exp` with no arguments
└── .claude/skills/exp/
    └── SKILL.md                # Claude Code skill definition for /exp command
```

## Runtime Layout

When installed, the repo is cloned to `~/.exp/`. Downloaded tool artifacts go to `~/.exp/platforms/<tool-name>/`.

## Initialization Flow

```
Shell startup
  └─ ~/.bashrc (or ~/.zshrc) sources ~/.exp/exp-init.sh
       ├─ Sets EXP_HOME_DIR and EXP_PLATFORM_DIR
       ├─ Sources lib/common.sh  (dispatcher + config loader)
       └─ Sources lib/platforms/{macos,linux}.sh  (platform primitives)
```

After initialization, the `exp()` shell function is available.

## Dispatcher (lib/common.sh)

The `exp()` function is the main entry point:

```
exp <tool> <command>
  │
  ├─ No args → show help text
  ├─ list / version / update → built-in commands
  └─ Tool command:
       ├─ Find .conf file (direct name match or alias lookup)
       ├─ Load config variables
       ├─ Check platform support
       ├─ No command → list available commands
       ├─ Override script exists? → source tools/overrides/<tool>.<command>.sh
       └─ install command → check dependencies → __exp_execute_install()
```

## Tool Configuration (.conf Files)

Each `.conf` file is a set of bash variable assignments. The config loader clears all previous `TOOL_*` and `INSTALL_*` variables before sourcing a new one.

### Required Fields

| Field | Description |
|-------|-------------|
| `TOOL_NAME` | Unique identifier (e.g., `nodejs`) |
| `TOOL_DESCRIPTION` | Human-readable description |
| `TOOL_PLATFORMS` | Comma-separated: `macos`, `linux`, or both |
| `TOOL_COMMANDS` | Comma-separated commands (e.g., `install` or `install,skill`) |

### Optional Fields

| Field | Description |
|-------|-------------|
| `TOOL_DEPENDENCIES` | Comma-separated tool names required before install |
| `TOOL_ALIASES` | Alternative names (e.g., `github` for `gh`) |
| `INSTALL_STRATEGY` | How to install: `script`, `pkg`, `dmg`, `npm_global`, `gem_global`, `curl_pipe_bash`, `os_command`, `custom` |
| `INSTALL_STRATEGY_LINUX` | Override strategy for Linux only |
| `INSTALL_URL_MACOS` | Download URL for macOS |
| `INSTALL_URL_LINUX` | Download URL for Linux |
| `POST_INSTALL_MSG` | Message shown after successful install |
| `NPM_PACKAGE` | Package name for `npm_global` strategy |
| `GEM_PACKAGE` | Package name for `gem_global` strategy |
| `OS_COMMAND` | Shell command for `os_command` strategy |
| `SCRIPT_DIR` | Subdirectory name in platforms/ (defaults to TOOL_NAME) |
| `DMG_VOLUME_NAME` | Mounted volume name for `dmg` strategy |
| `DMG_APP_NAME` | .app to copy to /Applications for `dmg` strategy |
| `PKG_PATH` | .pkg filename (for `pkg` strategy) or path inside DMG |

## Install Strategies

| Strategy | What it does |
|----------|-------------|
| `script` | Downloads a script to `~/.exp/platforms/<tool>/install.sh`, makes it executable, runs it |
| `pkg` | Downloads a .pkg, installs via `sudo installer` (macOS) or `dpkg`/`rpm` (Linux) |
| `dmg` | Downloads a .dmg, mounts it, copies .app or installs .pkg from inside (macOS only) |
| `npm_global` | Runs `npm install -g <package>` |
| `gem_global` | Runs `gem install <package>` |
| `curl_pipe_bash` | Pipes a URL directly to bash |
| `os_command` | Runs an arbitrary shell command |
| `custom` | No built-in logic; requires an override script at `tools/overrides/<tool>.install.sh` |

## Override Scripts (tools/overrides/)

Override scripts handle cases too complex for declarative config (architecture detection, multi-step installs, platform-specific package managers). They are **sourced** (not executed), so they have access to all loaded variables and functions.

Naming convention: `<TOOL_NAME>.<command>.sh` (e.g., `gh.install.sh`, `claude.skill.sh`).

## Platform Primitives (lib/platforms/)

Both `macos.sh` and `linux.sh` implement the same function signatures:

- `__exp_prim_download(url, dest)` — download a file
- `__exp_prim_install_script(path)` — chmod +x and run a script
- `__exp_prim_install_pkg(path)` — install a .pkg/.deb/.rpm
- `__exp_prim_install_dmg(dmg, volume, app, pkg)` — mount and install from DMG
- `__exp_prim_npm_global(package)` — npm install -g
- `__exp_prim_gem_global(package)` — gem install
- `__exp_prim_curl_pipe_bash(url)` — curl | bash

This abstraction layer means adding a new platform only requires implementing these functions.

## Cross-Platform Support

- **macOS/Linux**: Direct bash execution via `exp-init.sh`
- **Windows**: `exp-setup.ps1` installs WSL + Ubuntu, then runs `exp-setup.sh` inside WSL. All tool installation happens in WSL's bash
- **Platform detection**: `uname -s` (Darwin=macos, Linux=linux, MINGW/MSYS/CYGWIN=linux)
- **WSL detection**: `__exp_is_wsl()` checks `/proc/version` for "microsoft"
- **Architecture detection**: Override scripts use `uname -m` (arm64 vs amd64) where needed

## Adding a New Tool

### Simple tool (declarative only)

If the tool can be installed by downloading and running a script, installing a package, or running a single command, you only need a `.conf` file.

**Example: adding a tool called `mytool` that installs via a bash script**

1. Create `tools/mytool.conf`:

```bash
TOOL_NAME="mytool"
TOOL_DESCRIPTION="Install My Tool"
TOOL_PLATFORMS="macos,linux"
TOOL_DEPENDENCIES=""
TOOL_COMMANDS="install"

INSTALL_STRATEGY="script"
INSTALL_URL_MACOS="https://example.com/install.sh"
INSTALL_URL_LINUX="https://example.com/install-linux.sh"

POST_INSTALL_MSG="mytool installed. Run 'mytool --version' to verify."
```

2. Add the tool to the list in `README.md`.

That's it. The dispatcher will automatically find the `.conf` file and handle installation using the platform primitives.

### Tool with dependencies

Set `TOOL_DEPENDENCIES` to a comma-separated list of tools that must be installed first:

```bash
TOOL_DEPENDENCIES="nodejs"        # Checks that npm is available
TOOL_DEPENDENCIES="ruby"          # Checks that gem is available
TOOL_DEPENDENCIES="nodejs,ruby"   # Checks both
```

### Tool with npm/gem install

For tools distributed as npm or gem packages:

```bash
INSTALL_STRATEGY="npm_global"
NPM_PACKAGE="my-cli"
TOOL_DEPENDENCIES="nodejs"
```

```bash
INSTALL_STRATEGY="gem_global"
GEM_PACKAGE="my-gem"
TOOL_DEPENDENCIES="ruby"
```

### Complex tool (with override script)

If installation requires platform branching, architecture detection, API calls, or multi-step logic, use `INSTALL_STRATEGY="custom"` and create an override script.

1. Create `tools/mytool.conf`:

```bash
TOOL_NAME="mytool"
TOOL_DESCRIPTION="Install My Tool"
TOOL_PLATFORMS="macos,linux"
TOOL_DEPENDENCIES=""
TOOL_COMMANDS="install"

INSTALL_STRATEGY="custom"

POST_INSTALL_MSG="mytool installed."
```

2. Create `tools/overrides/mytool.install.sh`:

```bash
#!/usr/bin/env bash
# Override: mytool install

local platform
platform="$(__exp_detect_platform)"

case "$platform" in
  macos)
    local arch
    case "$(uname -m)" in
      arm64) arch="arm64" ;;
      *)     arch="amd64" ;;
    esac

    local dir="$EXP_PLATFORM_DIR/mytool"
    mkdir -p "$dir"

    # Download, extract, symlink...
    __exp_prim_download "https://example.com/mytool-${arch}.tar.gz" "$dir/mytool.tar.gz" || return 1
    tar -xzf "$dir/mytool.tar.gz" -C "$dir"
    sudo ln -sf "$dir/mytool" /usr/local/bin/mytool
    ;;
  linux)
    # Use apt, or download a different binary...
    __exp_prim_curl_pipe_bash "https://example.com/install-linux.sh" || return 1
    ;;
esac

return 0
```

**Important override script rules:**
- Use `return` (not `exit`) since the script is sourced into the current shell
- The script has access to all `__exp_*` functions and all loaded `TOOL_*`/`INSTALL_*` variables
- Use `__exp_detect_platform` for OS branching
- Use `__exp_is_wsl` to detect Windows WSL when you need Windows-specific behavior
- Use `uname -m` for CPU architecture (arm64 vs amd64)
- Download artifacts to `$EXP_PLATFORM_DIR/<tool-name>/`

### Adding extra commands beyond install

Tools can have commands other than `install`. For example, `claude` has both `install` and `skill` commands.

1. Add the command to `TOOL_COMMANDS` in the `.conf` file:

```bash
TOOL_COMMANDS="install,skill"
```

2. Create an override script for that command: `tools/overrides/mytool.skill.sh`

### Adding aliases

Allow users to refer to a tool by alternative names:

```bash
TOOL_ALIASES="github"   # exp github install → uses gh.conf
```

### Platform-specific strategy override

If a tool uses a different install method on Linux vs macOS:

```bash
INSTALL_STRATEGY="dmg"              # Default (used for macOS)
INSTALL_STRATEGY_LINUX="pkg"        # Override for Linux
```

### Checklist

- [ ] `tools/<name>.conf` created with all required fields
- [ ] `tools/overrides/<name>.install.sh` created (if using `custom` strategy)
- [ ] Override script uses `return` not `exit`
- [ ] Override script handles all platforms listed in `TOOL_PLATFORMS`
- [ ] `README.md` updated with the new tool

## Key Design Decisions

- **No state tracking**: The toolkit doesn't track what's installed. It assumes standard OS conventions
- **No uninstall**: Installation is one-way; users manually remove tools
- **No auto-update of tools**: Versions are pinned in .conf files or resolved at install time
- **Shell function, not binary**: `exp` is a bash function loaded via `source`, not a standalone executable
- **Declarative + imperative hybrid**: Simple tools use .conf only; complex tools add override scripts
