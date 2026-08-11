# CLAUDE.md

## Project Overview

exp-toolkit is a shell-based development tool installer. Users run `exp <tool> install` to install tools on macOS, Linux, or Windows (via WSL). See ARCHITECTURE.md for the full design.

## Key Conventions

- Tools are defined in `tools/<name>.conf` as bash variable assignments
- Complex installs use override scripts in `tools/overrides/<name>.<command>.sh`
- Override scripts are **sourced** (not executed) and have access to all `__exp_*` functions
- Platform primitives in `lib/platforms/{macos,linux}.sh` share identical function signatures
- The `exp()` dispatcher lives in `lib/common.sh`
- Version is in `__exp_version()` in `lib/common.sh`

## Adding a New Tool

1. Create `tools/<name>.conf` with required fields: `TOOL_NAME`, `TOOL_DESCRIPTION`, `TOOL_PLATFORMS`, `TOOL_COMMANDS`, and an `INSTALL_STRATEGY`
2. If the strategy is `custom`, create `tools/overrides/<name>.install.sh`
3. Update the tool list in `README.md`
4. No changes to `lib/common.sh` or dispatcher logic are needed

## Rules

- Never run `dev` tasks
- All `.conf` files must set `TOOL_NAME`, `TOOL_DESCRIPTION`, `TOOL_PLATFORMS`, and `TOOL_COMMANDS`
- Override scripts must `return` (not `exit`) since they are sourced
- Override scripts should handle both macOS and Linux when `TOOL_PLATFORMS` includes both
- Use `__exp_detect_platform` and `__exp_is_wsl` for platform branching in overrides
- Use `uname -m` for architecture detection (arm64 vs amd64) when needed
- Downloaded artifacts go to `$EXP_PLATFORM_DIR/<tool-name>/`

## Install Strategies Quick Reference

| Strategy | Config needed |
|----------|--------------|
| `script` | `INSTALL_URL_MACOS` and/or `INSTALL_URL_LINUX` |
| `pkg` | `INSTALL_URL_MACOS` and/or `INSTALL_URL_LINUX` |
| `dmg` | `INSTALL_URL_MACOS`, `DMG_VOLUME_NAME`, optionally `DMG_APP_NAME` or `PKG_PATH` |
| `npm_global` | `NPM_PACKAGE` |
| `gem_global` | `GEM_PACKAGE` |
| `curl_pipe_bash` | `INSTALL_URL_MACOS` and/or `INSTALL_URL_LINUX` |
| `os_command` | `OS_COMMAND` |
| `custom` | Override script required |

## Testing

Run `bash test.sh` to execute the test suite.
