_gitz-menu() {
	menu=$(
		for command in $GITZ_COMMANDS; do
			prettyprint_command "$command,$(eval "_gitz-$command-menu-item")"
		done
	)
	local result=$(echo -n $menu | fzf -i -d ',' --ansi --with-nth=2.. --height=25% --reverse --header='Available commands' | awk -F  "," '{print $1}')

	if [[ -z $result ]]; then
		zle redisplay
		return
	fi

	eval "_gitz-$result"
}

local prettyprint_command() {
	cmd=$1

	local cmd_key="${cmd%%,*}"
	local cmd_caption="${cmd#*,}"

	shortcut_text=''
	shortcut=$(eval "_gitz-$cmd_key-shortcut 2>/dev/null")
	if [ -n "$shortcut" ]; then
		shortcut_text=" $fg_no_bold[green]$GITZ_MAIN_KEY$shortcut"
	fi

	echo "${cmd_key},$fg_bold[default]${cmd_caption%% -- *}${shortcut_text}$fg[blue] -- $reset_color${cmd_caption#* -- }"
}