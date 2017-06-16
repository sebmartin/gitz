_gitz-menu() {
	menu=$(
		for command in $GITZ_COMMANDS; do
			echo "$command,$(eval "_gitz-$command-menu-item")"
		done
	)
	# local menu="$(_gitz-recent-menu-item)\n$(_gitz-append-path-menu-item)"
	local result=$(echo -n $menu | fzf -i -d ',' --with-nth=2.. --height=25% --reverse --header='Select a list' | awk -F  "," '{print $1}')

	if [[ -z $result ]]; then
		zle redisplay
		return
	fi

	eval "_gitz-$result"
}
