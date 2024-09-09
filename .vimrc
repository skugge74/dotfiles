" Enable syntax highlighting
syntax on

" Set basic Vim settings
set nocompatible             " Disable compatibility with old-time vi
set wildmenu                 " Enhanced command-line completion
set wildmode=list:longest    " Complete the longest common match, then list all matches
set background=dark          " Dark background for colorschemes

" Enable filetype detection and plugins
filetype on
filetype plugin on
filetype indent on

" Tab and indentation settings
set expandtab                " Use spaces instead of tabs
set autoindent               " Copy indent from current line when starting a new line
set tabstop=4                " Number of spaces that a <Tab> counts for
set shiftwidth=4             " Number of spaces to use for each step of (auto)indent

" Interface settings
set title                    " Set the terminal's title
set number                   " Show line numbers
set showmode                 " Show the current mode in the command line
set visualbell t_vb=         " Disable visual bell (no blinking)

" Search settings
set incsearch                " Show matches as you type
set ignorecase               " Ignore case when searching

" Colorscheme and highlighting
colorscheme catppuccin_mocha
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

" Additional useful settings
set history=1000             " Increase command history size
set undofile                 " Save undo history to a file
set undolevels=1000          " Number of undo levels
set showmatch                " Highlight matching parentheses

" Better display for messages
set cmdheight=2              " More space for displaying messages

set termguicolors

