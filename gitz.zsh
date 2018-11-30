#! /bin/zsh

# enabled gitz commands

GITZ_COMMANDS=(recent unmerged graph tags append-path)

# gitz main plugin chooser menu

local MAIN=menu
local MAIN_KEY='~'
GITZ_MAIN_KEY=$MAIN_KEY

_gitz-main() {
	if ! is_in_git_repo || ! is_gitish_command; then
		# Do nothing, append the bound key as if nothing got triggered
		LBUFFER="$LBUFFER$KEYS"
		return
	fi

	if (( $(echo "$LBUFFER" | wc -w) == 1 )) && is_git_command; then
		# If there's only one word, present menu of git commands
		_gitz-git-command
		return
	fi

	case $KEYS in
		"$MAIN_KEY")
			eval "_gitz-$MAIN"
			;;
		"$FAVOURITE_KEY")
			eval "_gitz-$FAVOURITE"
			;;
		*)
			local SHORTCUT_KEY=${KEYS#*$MAIN_KEY}
			if [ -n $SHORTCUT_KEY ]; then
				eval "_gitz-shortcut-$SHORTCUT_KEY"
			fi
			;;
	esac
}

zle -N gitz _gitz-main
bindkey $MAIN_KEY gitz

# gitz favourite

local FAVOURITE=recent
local FAVOURITE_KEY='`'

_gitz-favourite() {
	if ! is_in_git_repo || ! is_git_command; then
		# Do nothing, append the bound key as if nothing got triggered
		LBUFFER="$LBUFFER$FAVOURITE_KEY"
		return
	fi

	eval "_gitz-$FAVOURITE"
}

bindkey $FAVOURITE_KEY gitz #-favourite

# load plugins
for command in menu $GITZ_COMMANDS; do
	eval ". $(dirname $0)/gitz-$command.zsh"

	# load shortcut, if any
	local shortcut=$(eval "_gitz-$command-shortcut 2>/dev/null")
	if [ -n "$shortcut" ]; then
		eval "_gitz-shortcut-$shortcut() { _gitz-$command }"

		local shortcut_key="${GITZ_MAIN_KEY}$shortcut"
		bindkey $shortcut_key gitz
	fi
done

# git command completion

local -A git_commands
git_commands=(
	add 'add file contents to the index'
	bisect 'find by binary search the change that introduced a bug'
	branch 'list, create, or delete branches'
	checkout 'checkout a branch or paths to the working tree'
	clone 'clone a repository into a new directory'
	commit 'record changes to the repository'
	diff 'show changes between commits, commit and working tree, etc'
	fetch 'download objects and refs from another repository'
	grep 'print lines matching a pattern'
	# 'init':'create an empty Git repository or reinitialize an existing one'
	log 'show commit logs'
	merge 'join two or more development histories together'
	mv 'move or rename a file, a directory, or a symlink'
	pull 'fetch from and merge with another repository or a local branch'
	push 'update remote refs along with associated objects'
	rebase 'forward-port local commits to the updated upstream head'
	reset 'reset current HEAD to the specified state'
	rm 'remove files from the working tree and from the index'
	show 'show various types of objects'
	status 'show the working tree status'
	tag 'create, list, delete or verify a tag object signed with GPG')

_gitz-git-command() {
	menu=$(
		for cmd in "${(@k)git_commands}"; do
			description=$git_commands[$cmd]
			echo "$fg_bold[default]$cmd $fg[blue]-- $reset_color$description"
		done
	)
	local result=$(echo -n $menu | fzf --sort --ansi -i -d ' -- ' --nth=1 --height=35% --reverse --header='Git commands' | awk -F  " -- " '{print $1}')

	gitz-append-text $result
	_gitz-favourite
}

# utilities

local is_in_git_repo() {
 	git rev-parse HEAD > /dev/null 2>&1
}

local is_git_command() {
	# succeeds if
	# - command is `git`
	# - a shell alias to `git`
	[[ $LBUFFER[(w)1] == 'git' ]] || which $LBUFFER[(w)1] | grep 'aliased to git ' > /dev/null 2>&1
}

local is_gitish_command() {
	# other commands that can use the ref look up but won't trigger the git menu auto complete
	is_git_command || [[ $LBUFFER[(w)1] == 'tig' ]]
}

gitz-append-text() {
	local text=$1
	if [ -z $text ]; then
		zle redisplay
		return
	fi

	if [[ $LBUFFER[-1] != ' ' ]]; then
		text=" $result"
	fi

	LBUFFER="$LBUFFER$text "
	zle redisplay
}
