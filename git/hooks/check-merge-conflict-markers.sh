#!/usr/bin/env bash

# merge conflict markers
MARKERS="(<<<<<<<|=======|>>>>>>>)"

# Make a search with rg (ripgrep), which is fast enough especially for big
# files, if exists in the system. If not, it calls the GNU Grep, which is a
# POSIX compliant search command.
RG="$(command -v rg)"
rg_find() {
	git diff --cached --name-only | xargs "$RG" --color never --line-number --with-filename "$MARKERS"
}

grep_find() {
	git diff --cached --name-only | xargs grep --with-filename -n -E "$MARKERS"
}

# display message in proper format
display() {
	printf "%s\\n" "$@"
}

# print which find command is used
if [[ ! -d "$RG" ]]; then
	SEARCH="rg"
	RESULT="$(rg_find)"
else
	SEARCH="grep"
	RESULT="$(grep_find)"
fi

if [[ "${#RESULT}" -ge 0 ]]; then
	# TODO: the override msg should be a general msg for this file (i.e.
	# will be thrown if any pre-commit issue check isn't satisfied). 
	echo "Use 'git commit --no-verify' to override this check."
	echo "Fix merge problems. " 
	display "$SEARCH search" "$RESULT"
	exit 1
fi

