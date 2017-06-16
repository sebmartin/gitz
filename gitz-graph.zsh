_gitz-graph() {
	local list=$(git log --graph --decorate --oneline --color -n 1000)
	local result=$(echo $list | fzf --ansi --reverse --header='Commit graph')
	
	if [[ -z $result ]]; then
		zle redisplay
		return
	fi

	# trim the graph
	result=$(echo $result | sed 's/^[^a-b0-9]*//') 
	# extract SHA and ref names (if any)
	result=$(echo $result | sed -E 's/([a-b0-9]*) (\(([^)]*))?.*$/\1, \3/')
	# remove the HEAD -> marker if present
	result=$(echo $result | sed -E 's/HEAD -> //')
	# remove 'tag: ' markers
	result=$(echo $result | sed -E 's/tag: //g')
	# extract into multiple lines and remove empty lines
	result=$(echo $result | tr ', ' '\n' | grep -v '^$')

	if (( $(echo "$result" | wc -l) > 1 )); then
		# display chooser if multiple refs on the selected line
		result=$(echo $result | fzf --reverse --header='Choose a refname')
	fi

	gitz-append-text $result
}

_gitz-graph-menu-item() {
	echo "graph -- graph of commits"
}
_gitz-graph-shortcut() {
	echo "G"
}
