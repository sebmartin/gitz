_gitz-menu() {
	menu=$(
		for command in $GITZ_COMMANDS; do
			colorize_command "$command,$(eval "_gitz-$command-menu-item")"
		done
	)
	local result=$(echo -n $menu | fzf -i -d ',' --ansi --with-nth=2.. --height=25% --reverse --header='Available commands' | awk -F  "," '{print $1}')

	if [[ -z $result ]]; then
		zle redisplay
		return
	fi

	eval "_gitz-$result"
}

local colorize_command() {
	cmd=$1

	local cmd_key="${cmd%%,*}"
	local cmd_caption="${cmd#*,}"

	echo "${cmd_key},$fg_bold[default]${cmd_caption%% -- *}$fg[blue] -- $reset_color${cmd_caption#* -- }"
}