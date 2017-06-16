_gitz-tags() {
	local list=$(git tag)
	local result=$(echo $list | fzf --height=25% --reverse --header='Tags')
	
	if [[ -z $result ]]; then
		zle redisplay
		return
	fi

	gitz-append-text $result
}

_gitz-tags-menu-item() {
	echo "tags -- alphabetical list of tags"
}

_gitz-tags-shortcut() {
	echo "T"
}
