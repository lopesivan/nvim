" alt_Gr-Gr "123
"===============
"map ¹ :BOnly<CR>
"map ² :echo 2<CR>
"map ³ :echo 3<CR>
"map £ :echo 4<CR>
"map ¢ :echo 5<CR>
"map ¬ :echo 6<CR>
"map § :echo [=/+]<CR>
"
" nnoremap ¹ ?`<.\{-1,}>`<cr>c/>`/e<cr>
" ino      ¹ <esc>?`<.\{-1,}>`<cr>c/>`/e<cr>
" nnoremap ² /`<.\{-1,}>`<cr>c/>`/e<cr>
" ino      ² <esc>/`<.\{-1,}>`<cr>c/>`/e<cr>

" ----------------------------------------------------------------------------
"alt_Gr-t
" nnoremap <silent><m-t>  :TrainTextObj<CR>
" terminal <space>st

"alt_Gr-c
" map  ©  :<C-u>Gcommit -v -q %:p<CR>
" nnoremap <silent><Leader>ci  :<C-u>Gcommit -v -q %:p<CR>

"alt_Gr-d
" map  ð  :<C-u>Gdiff<CR>

"alt_Gr-m
" map  µ  :<c-u>exe "!git merge --no-ff ".input("informe o[s] branche[s]: ")." --no-commit"<CR>

"alt_Gr-r
" map  ®  :<c-u>exe "!git rebase ".input("informe o[s] branche[s]: ")<CR>

"alt_Gr-t
" map  ŧ  :<c-u>exe "!git tag -a ".input("nome da tag ou versao: "). " -m \"".input("tag description: ")."\""<CR>

"alt_Gr-l
" map  ł  :<c-u>exe "!git gg"<CR>

"alt_Gr-f
"map  đ :<C-u>GFiles<CR>

"alt_Gr-h
"map  ħ  :<C-u>lua require'whid'.whid()<CR>
" ----------------------------------------------------------------------------

"nnoremap ¹ /`<.\{-1,}>`<cr>c/>`/e<cr>
"ino      ¹ <esc>/`<.\{-1,}>`<cr>c/>`/e<cr>
"nnoremap ² ?`<.\{-1,}>`<cr>c/>`/e<cr>
"ino      ² <esc>?`<.\{-1,}>`<cr>c/>`/e<cr>

" nnoremap ¹ /`<.\{-1,}>`<cr>c/>`/e<cr>
" ino      ¹ <esc>/`<.\{-1,}>`<cr>c/>`/e<cr>
" nnoremap ² ?`<.\{-1,}>`<cr>c/>`/e<cr>
" ino      ² <esc>?`<.\{-1,}>`<cr>c/>`/e<cr>

" nnoremap ¹ :w<CR>
" nnoremap ² :q<CR>
" nnoremap ³ :wq<CR>

"nnoremap <c-x><c-s> :w<CR>
"nnoremap <c-x><c-q> :q<CR>
"
" Alt+4
"Press '+' to expand the visual selection and '_' to shrink it.
"map £ <Plug>(expand_region_expand)
"let g:jpTemplateKey = '³'
"vmap ³ <Plug>(expand_region_shrink)

" Alt+5
"map <silent>¢ :call YMLTemplate(expand('%:e'))<cr>:vsp cheetah.yml<cr>
"map <silent> <space>1 :if !filereadable(expand("%:p:h")."/cheetah.yml")
             " \  <bar>     call YMLTemplate(expand('%:e'))
             " \  <bar>  endif
             " \  <bar>  exec "vsp ".expand("%:p:h")."/cheetah.yml"<cr>

"map <silent>¬ :e cheetah.yml<cr>
"map <silent> <space>2 :Cheetah<CR>

" Open files located in the same dir in with the current file is edited
" map <leader>cd :e <C-R>=expand("%:p:h") . "/" <CR>
" map <silent> <space>2 :exec "cd ". expand("%:p:h")
"             \ <bar> Cheetah
"             \ <bar> Cd <CR>

"nmap <m-1> <Plug>(expand_region_shrink)
"vmap <m-2> <Plug>(expand_region_shrink)
"nmap <m-2> <Plug>(expand_region_expand)
"vmap <m-2> <Plug>(expand_region_expand)
"nnoremap <silent> <m-t> :FloatermNew<CR>
" vim: ft=vim ts=4
