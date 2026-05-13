# Easy eXperience Platform Manager (EXP)
gitbash command line to install management platforms for the following tools

- aws
- java
- nodejs
- heroku (requires nodejs)
- ruby
- shopify (requires ruby)
- xcode
- virtualbox

Currently developed for mac users only, some "might" work on ubuntu, it hasn't been tested.

# Prerequisites
Currently, for this to work you need git, which on a new mac will require you to install the xcode command line tools (rvm and node need this anyway).  To install these just open a terminal and type:
```
xcode-select --install
```
A window with a license will pop up and you can then click continue.  Once this is done you can install this with simple gitbash from a terminal by typing:
```
curl https://raw.githubusercontent.com/experience-playground/exp-toolkit/master/exp-setup.sh | bash
```

to uninstall, delete the $HOME/.exp directory and remove lines from $HOME/.zshrc and $HOME/.bash_profile that refer to the ~/.exp directory.

# Usage Examples
```
exp
```

will print which packages you can install and should look something like:

```
help
Enhanced Experience Platform Manager
exp is a command line tool to accelerate setting up projects and tools with common patterns.

Usage
=====
exp
- return this help

exp update
- update this tool to latest version

exp list
- return list of platforms

exp version
- return current version of tool

exp [platform]
- return commands available for specific platform

```
exp install nodejs
```
will install nvm.