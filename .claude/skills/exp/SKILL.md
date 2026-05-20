---
name: exp
description: Help users install and use the exp-toolkit CLI for setting up dev tools on macOS, Linux, and Windows (via WSL)
allowed-tools: Bash(exp *)
---

## What is exp-toolkit?

exp is a command line tool that accelerates setting up development tools and platforms on macOS, Linux, and Windows (via WSL). It provides a unified interface to install tools like Node.js, Java, Ruby, AWS CLI, Claude, and more.

## Help text

!`exp`

## Available tools

!`exp list`

## Installation

**macOS:** Prerequisites: git and Xcode command line tools (`xcode-select --install`).
```
curl https://raw.githubusercontent.com/experience-playground/exp-toolkit/master/exp-setup.sh | bash
```

**Linux:** Prerequisites: git and curl.
```
curl https://raw.githubusercontent.com/experience-playground/exp-toolkit/master/exp-setup.sh | bash
```

**Windows:** Run in PowerShell as Administrator:
```powershell
irm https://raw.githubusercontent.com/experience-playground/exp-toolkit/master/exp-setup.ps1 | iex
```
Then use exp inside a WSL terminal.

## Usage patterns

- `exp` — show help
- `exp list` — show all available tools
- `exp version` — show current version
- `exp update` — update exp to latest version
- `exp [tool]` — show available commands for a tool
- `exp [tool] install` or `exp [tool] i` — install a tool

## Instructions

You are helping a user with the exp-toolkit CLI. When answering:

1. Check which tools are available by running `exp list`
2. Guide users through installation using the `exp <tool> install` pattern
3. Note dependency requirements (e.g., heroku requires nodejs, shopify requires ruby)

