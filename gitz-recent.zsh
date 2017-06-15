# Show recent HEAD values by crubbing through reflog
_gitz-recent() {


	local list=$(git reflog --date=relative | grep 'checkout: moving from' | sed -E 's/^.*HEAD@{(.*)}.*moving from [^ ]* to ([^ ]*)/(\1)	\2/' | head -n 50)
	local result=$(echo $list | fzf --delimiter='\t' --tabstop=2 --nth=2 --height=25% --reverse --header='Recent checkouts' | awk -F  "\t" '{print $2}')
	
	if [[ -z $result ]]; then
		zle redisplay
		return
	fi

	gitz-append-text($result)
}

_gitz-shortcut-U() {
	_gitz-recent
}

# Shortcut
local SHORTCUT_KEY="${GITZ_MAIN_KEY}U"
# zle -N gitz-recent _gitz-recent
bindkey $SHORTCUT_KEY gitz
