" General Vim settings
	syntax on
	let mapleader=","
	set autoindent
	set tabstop=4
	set shiftwidth=4
	set dir=/tmp/
	set relativenumber 
	set number

	autocmd Filetype html setlocal sw=2 expandtab
	autocmd Filetype javascript setlocal sw=4 expandtab

	set cursorline
	hi Cursor ctermfg=White ctermbg=Yellow cterm=bold guifg=white guibg=yellow gui=bold

	set hlsearch
	nnoremap <C-l> :nohl<CR><C-l>:echo "Search Cleared"<CR>
	nnoremap <C-c> :set norelativenumber<CR>:set nonumber<CR>:echo "Line numbers turned off."<CR>
	nnoremap <C-n> :set relativenumber<CR>:set number<CR>:echo "Line numbers turned on."<CR>

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
	set pastetoggle=<F2>
	set mouse=a
	set incsearch

" Scroll behavior
	set scrolloff=5 
	nnoremap <C-e> 3<C-e>
	nnoremap <C-y> 3<C-y>

" Language Specific
	" Tabs
		so ~/dotfiles/vim/tabs.vim

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
		autocmd BufNewFile,BufRead *.tsx set syntax=typescript

	" Markup
		inoremap <leader>< <esc>I<<esc>A><esc>yypa/<esc>O<tab>


" File and Window Management 
	inoremap <leader>w <Esc>:w<CR>
	nnoremap <leader>w :w<CR>

	inoremap <leader>q <ESC>:q<CR>
	nnoremap <leader>q :q<CR>

	inoremap <leader>x <ESC>:x<CR>
	nnoremap <leader>x :x<CR>

	nnoremap <leader>e :Ex<CR>
	nnoremap <leader>t :tabnew<CR>:Ex<CR>
	nnoremap <leader>v :vsplit<CR>:w<CR>:Ex<CR>
	nnoremap <leader>s :split<CR>:w<CR>:Ex<CR>

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

" Future stuff
	"Swap line
	"Insert blank below and above

" Fix for: https://github.com/fatih/vim-go/issues/1509

"""
" Auto Reload vimrc
"""

if has ('autocmd') " Remain compatible with earlier versions
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
" => Plugs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set nocompatible              " be iMproved, required
filetype off                  " required

call plug#begin('~/.local/share/nvim/plugged')


" set rtp+=~/dotfiles/vim/Vundle.vim
" call vundle#begin('~/dotfiles/vim/plugins')


Plug 'tpope/vim-unimpaired' " Vim bracket shortcuts 
Plug 'tpope/vim-obsession' " Vim session management
Plug 'zxqfl/tabnine-vim'
Plug 'ctrlpvim/ctrlp.vim' " fuzzy find files
" map fuzzyfinder (CtrlP) plugin
nmap <silent> <leader>p :CtrlP<cr>
" nmap <silent> <leader>p :CtrlPBuffer<cr>
let g:ctrlp_map='<leader>t'
let g:ctrlp_dotfiles=1
let g:ctrlp_working_path_mode = 'ra'

" CtrlP ignore patterns
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
" Open in tabs by default
let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<c-t>'],
    \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
	\}

let g:ctrlp_custom_ignore = {
            \ 'dir': '\.git$\|node_modules$\|\.hg$\|\.svn$',
            \ 'file': '\.exe$\|\.so$'
            \ }

" let g:ctrlp_working_path_mode = '' 
let g:ctrlp_working_path_mode = 'ra' 
let g:ctrlp_extensions = ['buffertag', 'tag', 'line', 'dir']

if executable('ag')
	  " Use Ag over Grep
	  set grepprg=ag\ --nogroup\ --nocolor
	  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
	  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif
  
  
  "
" NERD Tree
Plug 'scrooloose/nerdtree' " file drawer, open with :NERDTreeToggle
" close NERDTree after a file is opened
let g:NERDTreeQuitOnOpen=0
" show hidden files in NERDTree
let NERDTreeShowHidden=1
" Toggle NERDTree
nmap <silent> <leader>b :NERDTreeToggle<cr>
" expand to the path of the file in the current buffer
nmap <silent> <leader>B :NERDTreeFind<cr>

let NERDTreeIgnore=['node_modules']

Plug 'w0rp/ale'
let g:ale_linters = {
	\	'typescript': ['tslint', 'tsserver'],
	\ 	'javascript': ['eslint', 'flow-language-server']
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
" "   ~always keep the signcolumn open!!
set signcolumn=yes
augroup LanguageClient_config
  autocmd!
  autocmd User LanguageClientStarted setlocal signcolumn=yes
  autocmd User LanguageClientStopped setlocal signcolumn=yes
augroup END

" highlight ALEError ctermbg=15 cterm=underline guibg=#ED6237 guifg=#F5F5F5
" highlight ALEErrorSign ctermfg=9 ctermbg=15 guifg=#C30500 guibg=#F5F5F5
" highlight ALEWarningSign ctermfg=11 ctermbg=15 guifg=#ED6237 guibg=#F5F5F5
set rtp+=~/dotfiles/submodules/fzf

Plug 'junegunn/fzf.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'liuchengxu/space-vim-dark'
Plug 'benmills/vimux'
Plug 'tpope/vim-fugitive' " the ultimate git helper
Plug 'tpope/vim-commentary' " comment/uncomment lines with gcc or gc in visual mode
Plug 'HerringtonDarkholme/yats.vim' " TS Syntax
Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
Plug 'Shougo/deoplete.nvim'
Plug 'Shougo/denite.nvim'


" Enable deoplete at startup
let g:deoplete#enable_at_startup = 1

" let g:tsuquyomi_disable_quickfix = 1
" Plug 'Quramy/tsuquyomi'
" set ballooneval
" autocmd FileType typescript nmap <buffer> <Leader>t : <C-u>echo tsuquyomi#hint()<CR>

Plug 'pangloss/vim-javascript' " JS Syntax
Plug 'mxw/vim-jsx' " JSX Syntax
Plug 'elzr/vim-json' " JSON syntax
let g:vim_json_syntax_conceal = 0 " Disable vim-json quote concealing

" Plug 'prettier/vim-prettier' " JS Prettier
" let g:prettier#quickfix_enabled = 0

" let g:prettier#autoformat = 0
" autocmd BufWritePre,TextChanged,InsertLeave *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.yaml,*.html PrettierAsync

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Color Scheme 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



call plug#end()
" call vundle#end()            " required
filetype plugin indent on    " required

colorscheme space-vim-dark
hi Comment cterm=italic
hi Comment guifg=#5C6370 ctermfg=59

