# Append a path specifier using fzf file browser

_gitz-append-path() {
	# The fzf-file-widget appends the selection to the LBUFFER but we want to add it to RBUFFER
	# So wrangle the LBUFFER to act as our result
	prev_lbuffer=$LBUFFER
	LBUFFER=''
	zle fzf-file-widget
	selection=$LBUFFER
	LBUFFER=$prev_lbuffer

	RBUFFER="$RBUFFER -- $selection"
	zle redisplay
}

_gitz-append-path-menu-item() {
	echo "append path -- fuzzy find files and append at the end of the command, separating with ' -- '"
}

_gitz-append-path-shortcut() {
	echo "P"
}
