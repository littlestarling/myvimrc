" プラグインが実際にインストールされるディレクトリ
let s:dein_dir = expand('~/work/myvimrc/.vim/.cache/dein')
" dein.vim 本体
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein.vim がなければ github から落としてくる
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

" 設定開始
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  " プラグインリストを収めた TOML ファイル
  " 予め TOML ファイル（後述）を用意しておく
  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  " TOML を読み込み、キャッシュしておく
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  " 設定終了
  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if has('vim_starting') && dein#check_install()
  call dein#install()
endif


"" enable indent-guide
"let g:indent_guides_enable_on_vim_startup = 1

if filereadable(expand('~/.vim/recognize_charcode.vim'))
  source ~/.vim/recognize_charcode.vim
endif

filetype plugin indent on
syntax enable

set t_Co=256
set background=dark
"colorscheme xoria256
colorscheme railscasts

hi Pmenu ctermbg=4

set ambiwidth=double
set autoread
set hidden
set number
set cursorline
set ruler
set laststatus=2

set display=lastline
set pumheight=10

set showmatch
set matchtime=1
set ttymouse=xterm2
set wildmode=longest:list
set nocompatible
set scrolloff=3
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
 " 自動的にインデントする (noautoindent:インデントしない)
 set autoindent
" タブをスペースに展開しない (expandtab:展開する)
set expandtab
set smartindent
set ts=2 sw=2 sts=2
"編集に関する設定:
"タブの画面上での幅
 set tabstop=2
"インデントの設定をファイルタイプ別に行う
" (shiftwidth=スマートインデントの幅)
" (tabstop=タブの画面上での幅)
" (softtabstop=??? デフォルトは tabstop と同じらしい)

augroup vimrc
autocmd! FileType perl setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd! FileType php  setlocal shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab
autocmd! FileType js   setlocal shiftwidth=4 tabstop=4 softtabstop=4
autocmd! FileType html setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd! FileType css  setlocal shiftwidth=2 tabstop=2 softtabstop=2
autocmd! FileType ruby setlocal shiftwidth=2 tabstop=2 softtabstop=2
augroup END

 set expandtab
 " バックスペースでインデントや改行を削除できるようにする
 set backspace=indent,eol,start
 " 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
 set wrapscan
 " 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
 set showmatch
 " コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
 set wildmenu
 " テキスト挿入中の自動折り返しを日本語に対応させる
 set formatoptions+=mM

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
endfunction

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


" tags
"let g:vim_tags_project_tags_command = "/opt/brew/bin/ctags -f .tags -R . 2>/dev/null"
"let g:vim_tags_gems_tags_command = "/opt/brew/bin/ctags -R -f .Gemfile.lock.tags `bundle show --paths` 2>/dev/null"
"set tags+=.tags
"set tags+=.Gemfile.lock.tags

augroup MyAutoCmd
  autocmd!

  au BufRead,BufNewFile *.haml set ft=haml
  au BufRead,BufNewFile *.sass set ft=sass
  au BufRead,BufNewFile *.coffee  set filetype=coffee
  au BufRead,BufNewFile *.schema set ft=ruby

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
  autocmd FileType ruby map <F4> :w<CR>:!ruby -c %<CR>
augroup END

