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

exp-toolkit runs inside WSL (Windows Subsystem for Linux). The setup script installs WSL and Ubuntu automatically if they're not already present.

### Prerequisites

- Windows 10 version 2004+ or Windows 11
- Administrator access (required for WSL installation)

### Step 1: Download the setup script

Download [`exp-setup.ps1`](https://raw.githubusercontent.com/experience-playground/exp-toolkit/master/exp-setup.ps1) and save it to a folder (e.g., your Downloads folder).

### Step 2: Run the setup script

Open **PowerShell as Administrator**:
1. Click Start, type "PowerShell"
2. Right-click **Windows PowerShell** and select **Run as Administrator**

Then navigate to where you saved the file and run:
```powershell
powershell -ExecutionPolicy Bypass -File .\exp-setup.ps1
```

This will:
- Install WSL and Ubuntu if not already present
- Install git inside WSL if needed
- Clone exp-toolkit and configure your shell

### Step 3: Restart if prompted

If WSL was just installed for the first time, you may need to restart your computer. After restarting, run the same command again to finish setup.

### Step 4: Open a WSL terminal

Once setup is complete, open a WSL terminal using any of these methods:
- Type `wsl` in PowerShell or Command Prompt
- Open **Ubuntu** from the Start menu
- Use **Windows Terminal** and select the Ubuntu tab

All `exp` commands are run inside this WSL terminal.

### Alternative: One-liner install

If your execution policy allows it, you can also run this directly in an Administrator PowerShell:
```powershell
irm https://raw.githubusercontent.com/experience-playground/exp-toolkit/master/exp-setup.ps1 | iex
```

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
