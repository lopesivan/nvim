
" Move between Vim and Tmux windows
if exists('$TMUX')
  function! TmuxOrSplitSwitch(wincmd, tmuxdir)
    let previous_winnr = winnr()
    let npanses = system("tmux list-panes| wc -l")
    execute  "wincmd " . a:wincmd
    if previous_winnr == winnr()
      " The sleep and & gives time to get back to vim so tmux's focus tracking
      " can kick in and send us our ^[[O
      execute "silent !sh -c 'sleep 0.01; tmux select-pane -" . a:tmuxdir . "' &"
      redraw!
    endif
  endfunction

  let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
  let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
  let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te
  nnoremap <silent> <a-down>  :call TmuxOrSplitSwitch('j', 'D')<CR>
  nnoremap <silent> <a-up>    :call TmuxOrSplitSwitch('k', 'U')<CR>
  nnoremap <silent> <a-right> :call TmuxOrSplitSwitch('h', 'L')<CR>
  nnoremap <silent> <a-left>  :call TmuxOrSplitSwitch('l', 'R')<CR>
else
  map <a-right> <C-w>l
  map <a-left>  <C-w>h
  map <a-down>  <C-w>j
  map <a-up>    <C-w>k
endif

" vim: ft=vim ts=4
