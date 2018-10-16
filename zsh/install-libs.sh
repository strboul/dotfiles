#! /usr/bin/env bash

# Installation script to build libraries mainly for Debian based distro (or like
# one of its flavors like Ubuntu) because macOS libraries are (usually) handled by
# brew package manager. Nevertheless, this script is complementary which should
# be sourced after installing the libraries in the Brewfile.

found_msg () { printf "%s found in the system:\\n%s\\n" "$1" "$2" ;}
unfound_msg() {	printf "%s not found. Installing...\\n" "$1" ;}

# install fzf (there is no official apt package)
if [ ! "$("$(command -v fzf)" 2> /dev/null)" == "" ]; then
	found_msg "fzf" "$(command -v fzf)"
else
	unfound_msg "fzf"
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
		~/.fzf/install
fi

# install universal-ctags (needed for nvim-tagbar): https://ctags.io/
if [ ! "$("$(command -v uctags)" 2> /dev/null)" == "" ]; then
	found_msg "uctags" "$(command -v uctags)"
else
	unfound_msg "uctags"
	git clone https://github.com/universal-ctags/ctags.git && \
		pushd ctags && \
		./autogen.sh && \
		./configure --program-prefix=u && \ # rename the program as 'uctags'
		make && make install && \
		popd && \
		rm -rf ctags/
fi

# Install python neovim modules (see `:help provider-python`). However, this may
# change in the feature:
# https://github.com/neovim/neovim/wiki/Following-HEAD#20181118
pip2 install --upgrade neovim
pip3 install --upgrade neovim

