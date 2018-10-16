#!/usr/bin/env bash

if [[ ! -d "$HOME"/dotfiles ]]; then
	echo >&2  "dotfiles not found in the home directory."
	exit 0
fi

echo "Updating configuration"
(cd ~/dotfiles && git pull && git submodule update --init --recursive)

# Checks package managers brew and apt for macOS and Debian respectively and
# installs them if required:
pkg_manager_check_install() {
	echo "Checking if package manager specific to this OS is installed"
	if [[ "$OSTYPE" == "darwin"* ]]; then
		if [ -x "$(command -v brew)" ]; then
			echo "brew not found. Installing brew"
			user_prompt "brew is not installed and it's required to proceed. Would you like to install it now? [y/N]" >&2
			/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		else
			echo "brew installed"
		fi
	elif [[ "$OSTYPE" == "linux"* ]]; then
		if [ -x "$(command -v apt-get)" ]; then
			echo "apt-get not found in the system. Install it 'manually'. Aborting..."
			exit 1
		else
			echo "apt-get installed"
		fi
	else
		echo "platform/pkg manager not supported."
	fi
}

# Source: https://stackoverflow.com/a/27875395/
user_prompt() {
	echo "$@"
	old_stty_cfg=$(stty -g)
	stty raw -echo
	answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
	stty "$old_stty_cfg"
	if echo "$answer" | grep -iq "^y" ;then
		echo "$answer"
		: # do nothing. proceed to script.
	else
		echo "$answer"
        	echo "Aborting."
        	exit 1
	fi
}

do_install() {
	user_prompt "$1 is not installed. Would you like to install it? [y/N]" >&2
	if [ -x "$(command -v apt-get)" ]; then
		sudo apt-get install $1 -y
	elif [ -x "$(command -v brew)" ]; then
		brew install $1
	else
		echo "platform/pkg manager not supported."
	fi
}

check_for_software() {
	echo "Checking to see if $1 is installed"
	if ! [ -x "$(command -v $1)" ]; then
		do_install $1
	else
		echo "$1 is installed."
	fi
}

dashes="$(printf -- '-%.0s' $(seq 49))"

echo "$dashes"
echo "Configure and install (if not exists) the CLI essentials:"
echo "zsh, nvim, tmux, and fzf"
echo
user_prompt "Let's get started? [y/N]"

pkg_manager_check_install
echo
check_for_software zsh
echo
check_for_software nvim
echo
check_for_software tmux
echo

source "$HOME"/dotfiles/zsh/link.sh

# change the default shell:
check_default_shell() {
	if [ -z "${SHELL##*zsh*}" ]; then
		echo "Default shell is zsh."
	else
		# The configuration will not work properly without zsh.
		user_prompt "Default shell is not zsh. Do you want to chsh -s \$(which zsh)? (y/N)"
		chsh -s $(which zsh)
	fi
}
check_default_shell
echo

# Lastly, install libraries for a specific OS. A user can opt to exit the setup
# process here.  If a user is on a macOS, all programs indicated in the Brewfile
# are installed; on the other hand, if a user is on a Debian distro (or one of
# its flavors like Ubuntu), the installation script are sourced to install
# libraries.
#
# The installation script should be sourced after the brew bundle action (which
# *tries* to install all libraries in the Brewfile) on macOS in order to ensure
# that all libraries are installed (e.g. libraries having no brew source should
# be placed in the installation script). Keep in mind that the installation
# script is not as complete as Brewfile, which should be taken first at all
# times on macOS systems.
user_prompt "Would you like to install (required libraries)? Check the list in
the Brewfile or installation script. [y/N]"
if [ -x "$(command -v apt-get)" ]; then
	source "$HOME"/dotfiles/zsh/install-libs.sh
elif [ -x "$(command -v brew)" ]; then
	brew bundle --file="$HOME"/dotfiles/Brewfile
	source "$HOME"/dotfiles/zsh/install-libs.sh
else
	echo "platform/pkg manager not supported."
fi

echo
echo "Please log out and log back in for default shell to be initialized."

# vim: set ts=4 sw=4
