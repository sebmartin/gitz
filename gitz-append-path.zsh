# Append a path specifier using fzf file browser

gitz-append-path() {
	LBUFFER="${LBUFFER} -- "
	zle fzf-file-widget
}

# zle -N gitz-append-path
# bindkey '~~' gitz-append-path