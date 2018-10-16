#! /usr/bin/env bash

# This script downloads the binary exectuables and places them inside the /bin
# folder in the home directory. Since binary files are usually not desired to be
# version controlled due to the type (sometimes also the size), those binaries
# are not part of the repository. Therefore, those binaries have to be copied
# over from their original sources when e.g. a fresh setup have been done.
#
# The script first checks whether the file or folder exists, and proceeds if
# false.  If you like to change the executables, first them and then do the
# symbolic linking again (see zsh/link.sh).

# create bin folder if not exists
mkdir -p "$HOME"/bin

pushd "$HOME"/bin

# renjin (always latest) -- http://www.renjin.org/downloads.html
if [[ ! -d renjin ]]; then
	wget -O renjin.zip 'https://nexus.bedatadriven.com/service/local/artifact/maven/redirect?r=renjin-release&g=org.renjin&a=renjin-generic-package&v=RELEASE&e=zip' && \
	unzip -qq renjin.zip && \
	rm renjin.zip && \
	# ln -s renjin "$(basename $(find . -maxdepth 1 -name "renjin*" -type d))"/bin/renjin
	echo "renjin installed"
fi

# grv (release binary) -- https://github.com/rgburke/grv/blob/master/doc/documentation.md
## macOS installation handled by Brewfile.
if [[ ! "$OSTYPE" == "darwin"* ]]; then
	if [ ! -f grv ]; then
		wget -O grv https://github.com/rgburke/grv/releases/download/v0.3.0/grv_v0.3.0_linux64 && \
			chmod +x ./grv && \
			echo "grv installed"
	fi
fi

# return working dir
popd
