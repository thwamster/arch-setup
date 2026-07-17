# thwamster's bashrc

# Environment
[[ $- != *i* ]] && return

if [[ -r /usr/share/bash-completion/bash_completion ]]; then
  . /usr/share/bash-completion/bash_completion
fi

export TERM=screen-256color

# --- History Control ---
shopt -s histappend
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000

# WSL Check
IS_WSL=0
if grep -qEi "(Microsoft|WSL)" /proc/version 2>/dev/null; then
	IS_WSL=1
fi

# Paths
if (( IS_WSL )); then
	export WIN_USER="thwamster"
	export WIN_HOME="/mnt/c/Users/$WIN_USER"
	export DEV_DIR="$WIN_HOME/source/repos"
	export NETHACK_DIR="/mnt/c/Users/thwam/dNAO/dnethackdir"
else
	export DEV_DIR="$HOME/source/repos"
	export NETHACK_DIR="$HOME/dNAO/dnethackdir"
fi

# Aliases
if (( IS_WSL )); then
	alias open="explorer.exe"
	alias ee="explorer.exe"
	alias np="/mnt/c/Program\ Files/Notepad++/notepad++.exe"
elif [[ "$OSTYPE" == "darwin"* ]]; then
	alias open="open"
	alias ee="open"
else
	alias open="xdg-open"
	alias ee="xdg-open"
fi

# Prompt
update_prompt() {
	local prompt="${PWD/$DEV_DIR/#}"
	prompt="${prompt/#$HOME/\~}"
	PS1="[\[\e[2m\]\u\[\e[0m\].\[\e[2m\]\h\[\e[0m\]] ${prompt}> "
}

PROMPT_COMMAND=update_prompt

# Directories
mkcd() {
	mkdir -p "$1" && cd "$1"
}

up(){
	local d=""
	limit=$1
	for ((i=1 ; i <= limit ; i++))
		do
			d=$d/..
		done
	d=$(echo $d | sed 's/^\///')
	if [ -z "$d" ]; then
		d=..
	fi
	cd $d
}

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Utilities
ex() {
	if [[ -f "$1" ]]; then
		case "$1" in
			*.tar.bz2)   tar xjf "$1"   ;;
			*.tar.gz)	tar xzf "$1"   ;;
			*.bz2)	   bunzip2 "$1"   ;;
			*.rar)	   unrar x "$1"   ;;
			*.gz)		gunzip "$1"	;;
			*.tar)	   tar xf "$1"	;;
			*.tbz2)	  tar xjf "$1"   ;;
			*.tgz)	   tar xzf "$1"   ;;
			*.zip)	   unzip "$1"	 ;;
			*.Z)		 uncompress "$1";;
			*.7z)		7z x "$1"	  ;;
			*.tar.xz)	tar xf "$1"	;;
			*)		   echo "'$1' cannot be extracted via ex()" ;;
		esac
	else
		echo "'$1' is not a valid file"
	fi
}

pfind() {
	ps aux | grep -v grep | grep -i "$1"
}

pkill() {
	local pids=$(pgrep -i "$1")
	if [[ -n "$pids" ]]; then
		kill -9 $pids
		echo "Killed process(es) matching '$1'"
	else
		echo "No process found matching '$1'"
	fi
}

# Core
alias rm='rm -I'
alias ls='ls --all --color=auto --classify --group-directories-first'
alias reload='source ~/.bashrc'

export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"

# Navigation
alias home="cd $WIN_HOME"
alias uhome="cd /usr/"
alias repos="cd $DEV_DIR"
alias urepos="cd /usr/src/repos/"

# Editors
alias bashrc="sudo nvim ~/.bashrc"
alias vimrc="sudo nvim ~/.vimrc"
alias dnethackrc="sudo nvim ~/.dnethackrc"
alias v="nvim"
alias vim="nvim"

# Cargo
alias cf="cargo fmt"
alias cr="cargo run"
alias crb="cargo run --bin"
alias crd="cargo run 2>/dev/null"

# Nethack
alias hf="ssh nethack@hardfought.org"
alias dn="cd $NETHACK_DIR && ./dnethack && cd - > /dev/null"
alias dnw="cd $NETHACK_DIR && ./dnethack -D -u wizard && cd - > /dev/null"

# Git
gr() {
	git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Error: Not a git repository."; return 1; }
	local url=$(git remote get-url origin | sed 's/\.git$//;s|git@github.com:|https://github.com/|')
	echo "Opening $url"
	open "$url"
}

ga() {
	git rm -r --cached .
	git add .
}

gcp() {
	local name="$1"
	git add .
	git commit -a -v -m "$name"
	git push
	gr
}

gi() {
	local name="$1"
	mkdir "$name" && cd "$name" || return
	git init
	
	[[ -f ~/templates/git/LICENSE ]] && cp ~/templates/git/LICENSE . || touch LICENSE
	[[ -f ~/templates/git/README.md ]] && cp ~/templates/git/README.md . || touch README.md
	[[ -f ~/templates/git/.gitignore ]] && cp ~/templates/git/.gitignore .gitignore || touch .gitignore
	
	git add .
	git commit -m "Initialization"
	git branch -M main
	gh repo create "$name" --private --source=. --push
	gr
	cd ..
	ls
}

# CMake
cmr() {
	if [ ! -d build ]; then
		mkdir build && cd build && cmake .. || return
	else
		cd build
	fi
	make "run_$1"
	cd ..
}

cmt() {
	if [ ! -d build ]; then
		mkdir build && cd build && cmake .. || return
	else
		cd build
	fi
	make "test_$1"
	cd ..
	ctest -V --test-dir build -R "$1" 2>/dev/null
}

# Java
jrun() {
	if [[ -z "$1" ]]; then
		echo "Usage: jrun <filename.java>"
		return 1
	fi
	
	if [[ -f "$1" ]]; then
		javac "$1" && java "${1%.java}"
	else
		echo "Error: File '$1' not found."
	fi
}