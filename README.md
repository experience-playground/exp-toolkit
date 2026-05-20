# Easy eXperience Platform Manager (EXP)

Command line tool to install and manage development platforms:

- aws
- java
- nodejs
- heroku (requires nodejs)
- ruby
- shopify (requires ruby)
- claude (Desktop and/or Code CLI)
- xcode (macOS only)
- virtualbox (macOS only)

Works on macOS, Linux, and Windows (via WSL).

---

## Install on macOS

You need git, which on a new Mac requires Xcode Command Line Tools. Open a terminal and run:
```
xcode-select --install
```

Then install exp-toolkit:
```
curl https://raw.githubusercontent.com/experience-playground/exp-toolkit/master/exp-setup.sh | bash
```

## Install on Linux

You need git and curl. On Ubuntu/Debian:
```
sudo apt-get update && sudo apt-get install -y git curl
curl https://raw.githubusercontent.com/experience-playground/exp-toolkit/master/exp-setup.sh | bash
```

## Install on Windows

exp-toolkit uses WSL (Windows Subsystem for Linux) on Windows. The setup script will install WSL if needed.

**Step 1:** Open PowerShell as Administrator and run:
```powershell
irm https://raw.githubusercontent.com/experience-playground/exp-toolkit/master/exp-setup.ps1 | iex
```

**Step 2:** If WSL was just installed, you may need to restart your computer and run the command again.

**Step 3:** Open a WSL terminal to use exp:
- Type `wsl` in PowerShell or Command Prompt
- Or open "Ubuntu" from the Start menu
- Or use Windows Terminal and select the Ubuntu tab

---

## Usage

```
exp                     # Show help
exp list                # Show available tools for your platform
exp version             # Show version
exp update              # Update to latest version
exp [tool]              # Show available commands for a tool
exp [tool] install      # Install a tool
```

### Examples

```
exp nodejs install      # Install Node.js via NVM
exp java install        # Install Java via SDKMAN
exp ruby install        # Install Ruby via RVM
exp claude install      # Install Claude Desktop and/or Code CLI
exp aws install         # Install AWS CLI
```

## Uninstall

Delete `~/.exp` and remove the sourcing line from your shell profile (`~/.bashrc`, `~/.bash_profile`, or `~/.zshrc`).
