" Set tabs based on the extension

autocmd BufNewFile,BufRead *.cpp set tabstop=4 shiftwidth=4 expandtab
autocmd BufNewFile,BufRead *.md set tabstop=2 shiftwidth=2
autocmd BufNewFile,BufRead *.R set tabstop=2 shiftwidth=2

autocmd BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79
autocmd BufNewFile,BufRead *.js, *.html, *.css set tabstop=2 softtabstop=2 shiftwidth=2
autocmd BufNewFile,BufRead *.go set tabstop=4 shiftwidth=4

autocmd BufNewFile,BufRead Brewfile set syntax=ruby
autocmd BufNewFile,BufRead Dockerfile set tabstop=2 shiftwidth=2 expandtab 

