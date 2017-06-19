_gitz-unmerged() {
	local list=$(git branch --sort=-committerdate --no-merged | sed 's/^ *//')
	local result=$(echo $list | fzf --height=25% --reverse --header='Unmerged branches, by last commit date')

	gitz-append-text $result
}

_gitz-unmerged-menu-item() {
	echo "unmerged -- alphabetical list of unmerged"
}
_gitz-unmerged-shortcut() {
	echo "U"
}
