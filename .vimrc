set nocompatible
filetype off
set rtp+=~/.vim/vundle.git
call vundle#rc()

if filereadable(expand('~/.vim/recognize_charcode.vim'))
  source ~/.vim/recognize_charcode.vim
endif

Bundle 'git-commit'
Bundle 'YankRing.vim'
Bundle 'EasyMotion'
Bundle 'vimwiki'
Bundle 'Rename'
Bundle 'wincent/Command-T'
Bundle 'jade.vim'
Bundle 'newspaper.vim'
Bundle 'xoria256.vim'
Bundle 'vim-ruby/vim-ruby'
Bundle 'tsukkee/unite-help'
Bundle 'kana/vim-textobj-user'
Bundle 'kana/vim-textobj-fold'
Bundle 'kana/vim-textobj-indent'
Bundle 'kana/vim-textobj-lastpat'

Bundle 'Shougo/neocomplcache'
Bundle 'Shougo/vimfiler'
Bundle 'Shougo/unite.vim'
Bundle 'h1mesuke/vim-alignta'
Bundle 'h1mesuke/unite-outline'

Bundle 'tpope/vim-haml'
Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-cucumber'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-markdown'

Bundle 'suan/vim-instant-markdown'

Bundle 'nelstrom/vim-textobj-rubyblock'
Bundle 'basyura/unite-rails'
Bundle 'scrooloose/nerdtree'

Bundle 'jpo/vim-railscasts-theme'

filetype plugin indent on
filetype indent on
syntax on

set t_Co=256
set background=dark
"colorscheme xoria256
colorscheme railscasts

hi Pmenu ctermbg=4

set ambiwidth=double
set autoread
set hidden
set number
set showmatch
set ttymouse=xterm2
set wildmode=longest:list
set nocompatible

set directory-=.

"backup
set nobackup

"encoding
set enc=utf-8
set fenc=utf-8
set fencs=utf-8,iso-2022-jp,euc-jp,cp932
set fileformats=unix,dos,mac

if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " checking iconv applied eucJP-ms
  if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\cad\ccb"
    let s:enc_uec = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencodings = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  unlet s:enc_euc
  unlet s:enc_jis
endif

if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif

if exists('&ambiwidth')
  set ambiwidth=double
endif

"Tab
set expandtab
set smartindent
set ts=2 sw=2 sts=2

"search
set nohlsearch
set ignorecase
set smartcase
set incsearch

"statusline
set laststatus=2
set statusline=%<%f\ %y\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%=%l,%3c

" keymap
nnoremap j gj
nnoremap k gk

nnoremap wh <C-w>h
nnoremap wj <C-w>j
nnoremap wk <C-w>k
nnoremap wl <C-w>l

nnoremap Y y$

nnoremap <Space>. :<C-u>edit $MYVIMRC<CR>
nnoremap <Space>s. :<C-u>source $MYVIMRC<CR>

cnoremap <C-a> <Home>
cnoremap <C-x> <C-r>=expand('%:p:h')<CR>/
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'

nmap <Leader>n :NERDTreeToggle<CR>

" 全角空白と行末の空白の色を変える
highlight WideSpace ctermbg=blue guibg=blue
highlight EOLSpace ctermbg=red guibg=red

function! s:HighlightSpaces()
  match WideSpace /　/
  match EOLSpace /\s\+$/
endf

function! s:remove_dust()
  let cursor = getpos(".")
  %s/\s\+$//ge
  %s/\t/  /ge
  call setpos(".", cursor)
  unlet cursor
endfunction
autocmd BufWritePre * call <SID>remove_dust()

" clipboard
set clipboard+=unnamed

" <Leader>
inoremap <Leader>date <C-R>=strftime('%Y/%m/%d(%a)')<CR>
inoremap <Leader>time <C-R>=strftime('%H:%M:%S')<CR>

" git-commit.vim
let git_diff_spawn_mode = 1

" neocomplcache
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_camel_case_completion = 0
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_min_syntax_length = 3

" unite.vim
nnoremap <silent> ,uf :<C-u>Unite file<CR>
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
nnoremap <silent> ,uo :<C-u>Unite outline<CR>
nnoremap <silent> ,uh :<C-u>Unite help<CR>

" vimwiki
let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki'}]

let g:EasyMotion_leader_key = '<Leader>m'

" vimfiler
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_safe_mode_by_default = 0

" yankring
let g:vimfiler_as_default_explorer = 1
let g:yankring_manual_clipboard_check = 0

augroup MyAutoCmd
  autocmd!

  au BufRead,BufNewFile *.haml set ft=haml
  au BufRead,BufNewFile *.sass set ft=sass

  autocmd BufRead * call s:HighlightSpaces()
  autocmd WinEnter * call s:HighlightSpaces()

  autocmd InsertEnter * highlight StatusLine ctermfg=red guifg=red
  autocmd InsertLeave * highlight StatusLine ctermfg=white guifg=white

  "自動的に QuickFix リストを表示する
  autocmd QuickfixCmdPost make,grep,grepadd,vimgrep,vimgrepadd cwin
  autocmd QuickfixCmdPost lmake,lgrep,lgrepadd,lvimgrep,lvimgrepadd lwin

  autocmd BufRead,BufNewFile COMMIT_EDITMSG set filetype=git
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  autocmd BufWritePost $MYVIMRC source $MYVIMRC | if has('gui_running') | source $MYGVIMRC
  autocmd BufWritePost $MYGVIMRC if has('gui_running') | source $MYGVIMRC
augroup END
