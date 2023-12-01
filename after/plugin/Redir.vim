" Uso:
" R hi =>g:kiko        "  salvo tudo na variável g:kiko
" put=g:kiko           " imprimo texto gravado no arquivo corrente
"
"
"variávei:g:quickrun_config
"conteúdo: {'_': {'outputter': 'buffer_legacy', 'runner': 'system'}}
" é uma lista, logo uso string
" put=string(g:quickrun_config)
"
" Called with a command and a redirection target
"   (see `:help redir` for info on redirection targets)
" Note that since this is executed in function context,
"   in order to target a global variable for redirection you must prefix it with `g:`.
" EG call Redir('ls', '=>g:buffer_list')
funct! Redir(command, to)
  exec 'redir '.a:to
  exec a:command
  redir END
endfunct

" The last non-space substring is passed as the redirection target.
" EG
"   :R ls @">
"   " stores the buffer list in the 'unnamed buffer'
" Redirections to variables or files will work,
"   but there must not be a space between the redirection operator and the variable name.
" Also note that in order to redirect to a global variable you have to preface it with `g:`.
"   EG
"     :R ls =>g:buffer_list
"     :R ls >buffer_list.txt
command! -nargs=+ R call call(function('Redir'), split(<q-args>, '\s\(\S\+\s*$\)\@='))
