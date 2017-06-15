gitz-append-text() {
	if [[ $LBUFFER[-1] != ' ' ]]; then
		result=" $result"
	fi

	zle -U "$result "
	zle redisplay
}
