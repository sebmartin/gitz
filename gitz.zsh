#! /bin/zsh

# enabled gitz commans

GITZ_COMMANDS=(recent unmerged graph tags append-path)

# gitz main plugin chooser menu

local MAIN=menu
local MAIN_KEY='~'
GITZ_MAIN_KEY=$MAIN_KEY

_gitz-main() {
	if ! is_in_git_repo || ! is_git_command; then
		# Do nothing, append the bound key as if nothing got triggered
		LBUFFER="$LBUFFER$KEYS"
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

# zle -N gitz-favourite _gitz-favourite
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

# utilities

local is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

local is_git_command() {
	# succeeds if command is `git` or a shell alias to `git`
	[[ $LBUFFER[(w)1] == 'git' ]] || which $LBUFFER[(w)1] | grep 'aliased to git ' > /dev/null 2>&1
}

gitz-append-text() {
	local text=$1
	if [[ $LBUFFER[-1] != ' ' ]]; then
		text=" $result"
	fi

	zle -U "$text "
	zle redisplay
}
