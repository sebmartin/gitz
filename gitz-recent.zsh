# Show recent HEAD values by crubbing through reflog
_gitz-recent() {
	local list=$(git log --date=relative -g '--pretty=format:%>(20)%gD%x09%gs' | grep 'checkout: moving from' | awk '{print (NR-1),$0}' | sed -E 's/checkout: moving from [^ ]* to ([^ ]*)/\1/' | head -n 1000 | sort -k 5 -k 1 | uniq -f 4 | sort -n | sed -e 's/^.*HEAD@{\(.*\)}/(\1)/' | column -t -s $'\t')
	local result=$(echo $list | fzf --delimiter='\t' --tabstop=2 --nth=1 --height=25% --reverse --header='Recent checkouts' | sed -E 's/^[^)]*) *//')

	gitz-append-text $result
}

_gitz-recent-menu-item() {
	echo "recent -- recent HEAD -- values"
}

_gitz-recent-shortcut() {
	echo "R"
}
