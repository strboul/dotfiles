" don't enter insert mode after opening a floaterm
  let g:floaterm_autoinsert=0

" REPL utility based on floaterm
  let s:repl_list={}
  let s:repl_list['r']=executable('radian') ? 'radian' : 'R'
  let s:repl_list['python']=executable('bpython') ? 'bpython' : 'python3'
  let s:repl_list['javascript']="node"

  function s:GetREPLCommand(file_type)
    if has_key(s:repl_list,a:file_type)
      let l:cmd=s:repl_list[a:file_type]
    else
      let l:cmd=g:floaterm_shell
    endif
    return l:cmd
  endfunction

  let s:repl_toggle_term_name='REPLToggleTerm'

  function! s:REPLCreate(command)
    if a:command ==# ''
      let l:file_type=&filetype
      let l:repl_cmd=s:GetREPLCommand(l:file_type)
    else
      let l:repl_cmd=a:command
    endif
    execute 'FloatermNew ' .
      \ '--name=' . s:repl_toggle_term_name . ' ' .
      \ '--height=0.5 ' .
      \ '--wintype=split ' .
      \ '--position=belowright ' .
      \ l:repl_cmd
    " don't focus to the repl terminal, keep cursor on the editor
    execute 'wincmd p'
  endfunction

  function! s:REPLDelete()
    FloatermKill s:repl_toggle_term_name
  endfunction

  function! s:REPLToggle(...)
    if a:0 > 0
      let l:command=a:000[0]
    else
      let l:command=''
    endif
    let l:has_repl=floaterm#buflist#curr()
    if l:has_repl>0
      call <SID>REPLDelete()
    else
      call <SID>REPLCreate(l:command)
    endif
  endfunction

  " Restarts REPL and keep the pane intact (by restarting)
  function! s:REPLRestart()
    redir=>s:messages
    call <SID>REPLDelete()
    redir END
    let s:error_msg='No floaterms with the bufnr or name'
    if s:messages =~ s:error_msg
      return
    else
      echo 'REPL restarted'
      call <SID>REPLCreate()
    endif
  endfunction

  function! s:REPLSendLine()
    FloatermSend --name=s:repl_toggle_term_name
  endfunction

  function! s:REPLSendSelection()
    '<,'>FloatermSend --name=s:repl_toggle_term_name
  endfunction

  " TODO REPLSendBuffer - send whole buffer line by line

" commands & keymappings
  " toggle terminal

  " command :REPLToggle <empty>, :REPLToggle python
  command! -nargs=* REPLToggle :call <SID>REPLToggle(<f-args>)

  nnoremap <silent><leader>tt :call <SID>REPLToggle()<CR>
  tnoremap <silent><leader>tt <C-\><C-n> :call <SID>REPLToggle()<CR>
  " restart terminal
  nnoremap <silent><leader>tr :call <SID>REPLRestart()<CR>
  " send current line
  nnoremap <silent><leader><CR> :call <SID>REPLSendLine()<CR>
  " send visual selection
  " ('> goes to the beginning of the last line of the last selected Visual
  " area in the current buffer)
  vnoremap <silent><leader><CR> :<C-u>call <SID>REPLSendSelection()<CR>'>
