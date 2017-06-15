#! /bin/zsh

# Run this from your ~/.zshrc file to enable when launching zsh

gitz-start() {
	if ! is_in_git_repo || ! is_git_command; then
		# Do nothing, append the bound key as if nothing got triggered
		LBUFFER="$LBUFFER\`"
		return
	fi

	gitz-recent
}