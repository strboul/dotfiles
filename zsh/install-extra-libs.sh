#! /usr/bin/env bash

# https://github.com/junegunn/fzf
install_fzf() {
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install
}

# https://github.com/BurntSushi/ripgrep
install_ripgrep() {
  # TODO fix the do_install_with_pkg_manager function definition file
  do_install_with_pkg_manager ripgrep
}

install_nodejs() {
 # FIXME
  do_install_with_pkg_manager nodejs
}

# https://github.com/universal-ctags/ctags.git
install_universal_ctags() {
  git clone https://github.com/universal-ctags/ctags.git /tmp/ctags && \
    pushd /tmp/ctags && \
    ./autogen.sh && \
    ./configure --program-prefix=u && \
    make && make install && \
    popd && \
    rm -rf /tmp/ctags/
}


# Map vim-sensible file to ".vimrc" for having a sensible vim functionality.
# https://github.com/tpope/vim-sensible
install_vim_sensible() {
  if [ ! -f "$HOME"/.vimrc ]; then
    wget -O \
      "$HOME"/.vimrc \
      https://raw.githubusercontent.com/tpope/vim-sensible/master/plugin/sensible.vim
        fi
}


# https://github.com/strboul/git-substatus
install_git_substatus() {
  curl -L	\
    https://raw.githubusercontent.com/strboul/git-substatus/master/git-substatus.py \
    > "$HOME"/bin/git-substatus && \
    chmod u+x "$HOME"/bin/git-substatus
}

