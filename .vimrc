scriptencoding utf-8
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
imap { {}<Left>
imap [ []<Left>
imap ( ()<Left>
imap < <><Left>
imap "" ""<Left>
imap '' ''<Left>
imap `` ``<Left>
set lcs=tab:>-,eol:^,trail:_,extends:~
highlight IdeographicSpace cterm=underline ctermbg=DarkGreen guibg=DarkGreen
au VimEnter,WinEnter * match IdeographicSpace /　/

function! RTrim()
  let s:cursor = getpos(".")
  %s/\s\+$//e
  %s/　\+$//e
  call setpos(".", s:cursor)
endfunction
autocmd BufWritePre *.php,*.rb,*.js,*.c,*.cpp,*.css,*.java,*.pl,*.conf call RTrim()

