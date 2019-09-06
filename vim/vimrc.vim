" General Vim settings
	syntax on
	let mapleader=","
	set dir=/tmp/
	set relativenumber 
	set number

" ============= Tab Stuff ============

filetype plugin indent on
" On pressing tab, insert 2 spaces
set expandtab
" show existing tab with 2 spaces width
set tabstop=2
" set softtabstop=2
" when indenting with '>', use 2 spaces width
set shiftwidth=0
" set autoindent


	autocmd Filetype html setlocal sw=2 expandtab
	" autocmd Filetype javascript setlocal sw=4 expandtab

	set cursorline

	set hlsearch
	nnoremap <C-l> :nohl<CR><C-l>:echo "Search Cleared"<CR>
	
	" Things from: https://items.sjbach.com/319/configuring-vim-right
	set number     " Line numbers
	set visualbell " No sounds
	set autoread   " Reload files changed outside vim
	nnoremap ' `
    nnoremap ` '
	set ignorecase 
	set smartcase
	set title

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo') && isdirectory(expand('~').'/.vim/backups')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

" Redo with U instead of Ctrl+R
noremap U <C-R>


set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points


	nnoremap n nzzzv
	nnoremap N Nzzzv

	nnoremap H 0
	nnoremap L $
	nnoremap J G
	nnoremap K gg

	map <tab> %


	set backspace=indent,eol,start

	nnoremap <Space> za
	nnoremap <leader>z zMzvzz

	nnoremap vv 0v$

	set listchars=tab:\|\ 
	nnoremap <leader><tab> :set list!<cr>
	set clipboard=unnamed

	set pastetoggle=<F2>
	set mouse=a
	set incsearch

" AG Shortcuts
nmap ,ag :Ag 
nmap ,af :AgFile 


" move up/down quickly by using Cmd-j, Cmd-k
" which will move us around by functions
nnoremap <silent> <D-j> }
nnoremap <silent> <D-k> {
autocmd FileType ruby map <buffer> <D-j> ]m
autocmd FileType ruby map <buffer> <D-k> [m
autocmd FileType rspec map <buffer> <D-j> }
autocmd FileType rspec map <buffer> <D-k> {
autocmd FileType javascript map <buffer> <D-k> }
autocmd FileType javascript map <buffer> <D-j> {

autocmd FileType typescript map <buffer> <D-k> }
autocmd FileType typescript map <buffer> <D-j> {

" Use numbers to pick the tab you want (like iTerm)

map <silent> <D-1> :tabn 1<cr>
map <silent> <D-2> :tabn 2<cr>
map <silent> <D-3> :tabn 3<cr>
map <silent> <D-4> :tabn 4<cr>
map <silent> <D-5> :tabn 5<cr>
map <silent> <D-6> :tabn 6<cr>
map <silent> <D-7> :tabn 7<cr>
map <silent> <D-8> :tabn 8<cr>
map <silent> <D-9> :tabn 9<cr>


" Command-/ to toggle comments
map <D-/> :TComment<CR>
imap <D-/> <Esc>:TComment<CR>i
" gcc to comment a line, gcp to comment a paragraph
nmap <silent> gcp <c-_>p

" alias yw to yank the entire word 'yank inner word'
" even if the cursor is halfway inside the word
" FIXME: will not properly repeat when you use a dot (tie into repeat.vim)
nnoremap ,yw yiww

" ,ow = 'overwrite word', replace a word with what's in the yank buffer
" FIXME: will not properly repeat when you use a dot (tie into repeat.vim)
nnoremap ,ow "_diwhp

" ," Surround a word with "quotes"
map ," ysiw"
vmap ," c"<C-R>""<ESC>

" ,' Surround a word with 'single quotes'
map ,' ysiw'
vmap ,' c'<C-R>"'<ESC>

" ,) or ,( Surround a word with (parens)
" The difference is in whether a space is put in
map ,( ysiw(
map ,) ysiw)
vmap ,( c( <C-R>" )<ESC>
vmap ,) c(<C-R>")<ESC>

" ,[ Surround a word with [brackets]
map ,] ysiw]
map ,[ ysiw[
vmap ,[ c[ <C-R>" ]<ESC>
vmap ,] c[<C-R>"]<ESC>

" ,{ Surround a word with {braces}
map ,} ysiw}
map ,{ ysiw{
vmap ,} c{ <C-R>" }<ESC>
vmap ,{ c{<C-R>"}<ESC>

"(v)im (r)eload
nmap <silent> <leader>vr :so $MYVIMRC<CR>


" Scroll behavior
	set scrolloff=8 
	nnoremap <C-e> 3<C-e>
	nnoremap <C-y> 3<C-y>

" This mapping makes macros even easier to remember: hit qq to record, q to stop recording, and Q to apply.
nnoremap Q @q
vnoremap Q :norm @q<cr>

" Shift + L / H to switch tabs
noremap <S-l> gt
noremap <S-h> gT

noremap <S-j> 10j
noremap <S-k> 10k


" Language Specific
	" Tabs
		so ~/.dotfiles/vim/tabs.vim

	" General
		inoremap <leader>for <esc>Ifor (int i = 0; i < <esc>A; i++) {<enter>}<esc>O<tab>
		inoremap <leader>if <esc>Iif (<esc>A) {<enter>}<esc>O<tab>

	" Java
		inoremap <leader>sys <esc>ISystem.out.println(<esc>A);
		vnoremap <leader>sys yOSystem.out.println(<esc>pA);

	" Java
		inoremap <leader>con <esc>Iconsole.log(<esc>A);
		vnoremap <leader>con yOconsole.log(<esc>pA);

	" C++
		inoremap <leader>cout <esc>Istd::cout << <esc>A << std::endl;
		vnoremap <leader>cout yOstd::cout << <esc>pA << std:endl;

	" C
		inoremap <leader>out <esc>Iprintf(<esc>A);<esc>2hi
		vnoremap <leader>out yOprintf(, <esc>pA);<esc>h%a

	" Typescript
		autocmd BufNewFile,BufRead *.ts set syntax=typescript
		" autocmd BufNewFile,BufRead *.js set syntax=typescript
		autocmd BufNewFile,BufRead *.tsx set syntax=typescript

	" Markup
		inoremap <leader>< <esc>I<<esc>A><esc>yypa/<esc>O<tab>


" File and Window Management 
	inoremap <leader>x <ESC>:x<CR>
	nnoremap <leader>x :x<CR>

	nnoremap <leader>e :Ex<CR>
	nnoremap <leader>t :tabnew<CR>:Ex<CR>
	nnoremap <leader>v :vsplit<CR>:w<CR>:Ex<CR>
	nnoremap <leader>s :split<CR>:w<CR>:Ex<CR>

" Open new split panes to right and bottom, which feels more natural than Vim’s default
set splitbelow
set splitright


	" Use Ctrl+[direction] to navigate split panes
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>


" Return to the same line you left off at
	augroup line_return
		au!
		au BufReadPost *
			\ if line("'\"") > 0 && line("'\"") <= line("$") |
			\	execute 'normal! g`"zvzz' |
			\ endif
	augroup END

" Auto load
	" Triger `autoread` when files changes on disk
	" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
	" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
	autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
	set autoread 
	" Notification after file change
	" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
	autocmd FileChangedShellPost *
	  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

"""
" Auto Reload vimrc
"""

if has ('autocmd') " Remain compatible with earlier versions
	augroup myvimrc
	    au!
	    au BufWritePost .vimrc,_vimrc,vimrc,.gvimrc,_gvimrc,gvimrc so $MYVIMRC | if has('gui_running') | so $MYGVIMRC | endif
	augroup END

	augroup vimrc     " Source vim configuration upon save
		autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
		autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
	augroup END
endif " has autocmd

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc Settings 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set wildignore+=**/node_modules/**
set wildignore+=**/flow-typed/**
set wildignore+=**/build/**
set wildignore+=**/dist/**


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin('~/.dotfiles/vim/plugins')


Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-unimpaired' " Vim bracket shortcuts 
Plug 'tpope/vim-obsession' " Vim session management
Plug 'tpope/vim-surround' " Vim session management
Plug 'tpope/vim-fugitive' " the ultimate git helper
Plug 'tomtom/tcomment_vim' " alternative to vim-commentary
Plug 'ctrlpvim/ctrlp.vim' " fuzzy find files
Plug 'scrooloose/nerdtree' " file drawer, open with :NERDTreeToggle
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf.vim'
Plug 'jiangmiao/auto-pairs'

" --------------------
" Autocomplete Plugins
" --------------------
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/denite.nvim'
Plug 'tbodt/deoplete-tabnine', { 'do': './install.sh'  }
Plug 'mattn/emmet-vim' " Emmet for HTML, CSS, and JSX

" --------------------
" Syntax Plugins
" --------------------
Plug 'HerringtonDarkholme/yats.vim' " TS Syntax
" Plug 'leafgarland/typescript-vim' " TS Syntax - not as thorough as yats
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
Plug 'pangloss/vim-javascript' " JS Syntax
" Plug 'mxw/vim-jsx' " JSX Syntax
Plug 'peitalin/vim-jsx-typescript' " The least buggy of the three
" Plug 'maxmellon/vim-jsx-pretty' " JSX Syntax

" TODO: styled-components + vim-css3 is looking weird
Plug 'styled-components/vim-styled-components', { 'branch': 'main' }
Plug 'hail2u/vim-css3-syntax'
Plug 'jparise/vim-graphql'
Plug 'elzr/vim-json' " JSON syntax

" --------------------
" Filetype Plugins
" --------------------
Plug 'reedes/vim-pencil' " Markdown

" --------------------
" Theme Plugins
" --------------------
" Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'liuchengxu/space-vim-dark'

call plug#end()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Theme & Syntax Settings 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype plugin indent on    " required
syntax on

" color dracula 

color space-vim-dark


augroup VimCSS3Syntax
  autocmd!

  autocmd FileType css setlocal iskeyword+=-
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Misc Settings 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set rtp+=~/.dotfiles/submodules/fzf " Enable fzf
let g:vim_json_syntax_conceal = 0 " Disable vim-json quote concealing

let g:user_emmet_leader_key='<C-e>'
let g:user_emmet_settings = {
\ 'javascript.jsx': {
\   'extends': 'jsx',
\ },
\}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Markdown Editing 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:pencil#wrapModeDefault = 'soft'   " default is 'hard'
let g:pencil#textwidth = 80

augroup pencil
  autocmd!
  autocmd FileType markdown,mkd call pencil#init()
  autocmd FileType text         call pencil#init()
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Camel Case Motion 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" map w <Plug>CamelCaseMotion_w
" map b <Plug>CamelCaseMotion_b
" map e <Plug>CamelCaseMotion_e


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NERDTree Settings 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" close NERDTree after a file is opened
let g:NERDTreeQuitOnOpen=0
" show hidden files in NERDTree
let NERDTreeShowHidden=1
" Toggle NERDTree
nmap <silent> <leader>b :NERDTreeToggle<cr>
" expand to the path of the file in the current buffer
nmap <silent> <leader>B :NERDTreeFind<cr>
let NERDTreeIgnore=['node_modules', 'dist', 'build', '_working']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => NVIM-Typescript Settings 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" autocmd FileType typescript.tsx setlocal commentstring=//\ %s
" let g:context#commentstring#table['typescript.jsx'] = {
" 			\ 'jsComment' : '// %s',
" 			\ 'jsImport' : '// %s',
" 			\ 'jsxStatment' : '// %s',
" 			\ 'jsxRegion' : '{/*%s*/}',
" \}

function! VimTSCConfig()
    let g:nvim_typescript#vue_support=1
    let g:nvim_typescript#type_info_on_hold=1
    let g:nvim_typescript#diagnosticsEnable=0
    " Let ALE do linting
    let g:nvim_typescript#diagnostics_enable=0
    no <Leader>td   :TSDoc<cr>
    no <Leader>tt   :TSType<cr>
    " no <Leader>ttd   :TSTypeDef<cr>
    no <Leader>tD   :mark 1<cr>:TSDef<cr>
    no <Leader>tp   :TSDefPreview<cr>
    no <Leader>tr   :TSRefs<cr>
    no <Leader>tR   :TSRename<cr>
endfunction
call VimTSCConfig()


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => ALE Settings 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set Quickfix window to wrap words
augroup quickfix
    autocmd!
    autocmd FileType qf setlocal wrap
augroup END

let g:ale_linters = {
	\	'typescript': ['tslint', 'tsserver'],
	\ 'javascript': ['eslint']
	\}
" Use typescript-tslint-plugin instead. (install in each package and add to
" tsconfig.json)
let g:ale_linters_ignore = {'typescript': ['tslint']}
	
let g:ale_fixers = {
	\   'typescript': ['prettier'],
	\   'javascript': ['prettier'],
	\   'css': ['prettier'],
	\}


let g:ale_fix_on_save = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_change = 'always'
let g:ale_sign_error = "◉"
let g:ale_sign_warning = "◉"
let g:ale_sign_column_always = 1
let g:ale_javascript_prettier_use_local_config = 1

" "   ~always keep the signcolumn open!!
set signcolumn=yes
augroup LanguageClient_config
  autocmd!
  autocmd User LanguageClientStarted setlocal signcolumn=yes
  autocmd User LanguageClientStopped setlocal signcolumn=yes
augroup END

nmap <silent> <leader>ak <Plug>(ale_previous_wrap)
nmap <silent> <leader>aj <Plug>(ale_next_wrap)
nmap <silent> <leader>af <Plug>(ale_fix)
nmap <leader>ad <Plug>(ale_detail)
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => CtrlP Settings 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if executable('ag')
	  " Use Ag over Grep
	  set grepprg=ag\ --nogroup\ --nocolor
	  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
	  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
 
nmap <silent> <leader>p :CtrlP<cr>
let g:ctrlp_dotfiles=1
let g:ctrlp_working_path_mode = 'ra'

" CtrlP ignore patterns
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

" Open in tabs by default
" let g:ctrlp_prompt_mappings = {
"     \ 'AcceptSelection("e")': ['<c-t>'],
"     \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
" 	\}

let g:ctrlp_custom_ignore = {
            \ 'dir': '\.git$\|node_modules$\|\.hg$\|\.svn$',
            \ 'file': '\.exe$\|\.so$'
            \ }

" let g:ctrlp_working_path_mode = '' 
let g:ctrlp_working_path_mode = 'ra' 
let g:ctrlp_extensions = ['buffertag', 'tag', 'line', 'dir']

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Deoplete Settings 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:deoplete#enable_at_startup = 1 " Enable deoplete at startup
let g:jsx_ext_required = 0 " Fix for deoplete + jsx
" let g:deoplete#auto_complete = v:false
let g:deoplete#max_list = 16
" let g:deoplete#on_text_changed_i = v:false
let g:deoplete#prev_completion_mode = 'mirror' 

" call deoplete#custom#option({
"       \ 'auto_complete': v:false
"       \ })
"
" Plugin key-mappings.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <C-e>     <Plug>(neosnippet_expand_or_jump)
smap <C-e>     <Plug>(neosnippet_expand_or_jump)
xmap <C-e>     <Plug>(neosnippet_expand_target)
"
" SuperTab like snippets behavior.
" Note: It must be "imap" and "smap".  It uses <Plug> mappings.
imap <expr><TAB>
 \ pumvisible() ? "\<C-n>" :
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
" For conceal markers,.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

let g:neosnippet#disable_runtime_snippets = {
\   '_' : 1,
\ }

let g:neosnippet#snippets_directory = '~/.dotfiles/vim/snippets'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Color Scheme Mods
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set termguicolors

" Background & Current Line
hi Normal ctermfg=231 ctermbg=235 cterm=NONE guifg=#e6e1dc guibg=#242424 gui=NONE
hi CursorLine cterm=NONE ctermbg=236 guibg=#2f2f2f

" Comment Colors
hi Comment cterm=italic
hi Comment guifg=#5f5f87 ctermfg=60

" JS/TS Syntax Types
" hi StorageClass guifg=#f26299
" hi Operator guifg=#FFFFFF
" hi Number guifg=#E5C07B
" hi Special guifg=#E5C07B
" hi Boolean guifg=#E5C07B

" JSX/TSX 
hi tsxTagName guifg=#e63682
hi tsxCloseString guifg=#e63682
hi tsxTag guifg=#07929e
hi tsxCloseTag guifg=#07929e
hi tsxAttributeBraces guifg=#809cdb
hi tsxEqual guifg=#809cdb
hi tsxTypeBraces guifg=#999999
hi tsxTypes guifg=#18a8b4


