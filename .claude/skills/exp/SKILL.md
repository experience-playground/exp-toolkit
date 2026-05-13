---
name: exp
description: Help users install and use the exp-toolkit CLI for setting up dev tools on macOS
allowed-tools: Read Grep Glob Bash(exp *) Bash(cat *)
---

## What is exp-toolkit?

exp is a command line tool that accelerates setting up development tools and platforms on macOS. It provides a unified interface to install tools like Node.js, Java, Ruby, AWS CLI, Claude, and more.

## Help text

!`cat text/exp.txt`

## Available tools

!`cat bin/exp-core.sh`

## Installation

exp-toolkit is installed by running:
```
curl https://raw.githubusercontent.com/experience-playground/exp-toolkit/master/exp-setup.sh | bash
```

Prerequisites: git and Xcode command line tools (`xcode-select --install`).

## Usage patterns

- `exp` — show help
- `exp list` — show all available tools
- `exp version` — show current version
- `exp update` — update exp to latest version
- `exp [tool]` — show available commands for a tool
- `exp [tool] install` or `exp [tool] i` — install a tool

## Instructions

You are helping a user with the exp-toolkit CLI. When answering:

1. Check which tools are available by reading `bin/exp-core.sh` or running `exp list`
2. To understand how a specific tool installer works, read the corresponding `bin/exp-<tool>.sh` file
3. Guide users through installation using the `exp <tool> install` pattern
4. Note dependency requirements (e.g., heroku requires nodejs, shopify requires ruby)
5. If the user wants to add a new tool, follow the existing pattern: create `bin/exp-<tool>.sh` with a `__exp_<tool>` function and add it to `__exp_list()` in `bin/exp-core.sh`
