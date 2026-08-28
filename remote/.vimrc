scriptencoding utf-8

" options
set encoding=utf-8
set showmatch
set backspace=indent,eol,start
" Keep the common session options, then add newer values when supported.
set sessionoptions=blank,buffers,curdir,folds,help,tabpages,winsize,winpos
silent! set sessionoptions+=terminal
silent! set sessionoptions+=localoptions
set number
set nowrap
set whichwrap+=b,s,<,>,[,],h,l
set breakindent
set undofile
set ignorecase
set smartcase
set smartindent
set updatetime=250
set timeoutlen=300
set splitright
set splitbelow
set list
" New Vim accepts a third character for tab; older Vim only accepts two.
" Some still older builds also do not know the `space` listchar.
try
    set listchars=tab:→\ \ ,space:·,trail:·,precedes:⇠,extends:⇢,nbsp:×
catch /^Vim\%((\a\+)\)\=:E474/
    try
        set listchars=tab:→\ ,space:·,trail:·,precedes:⇠,extends:⇢,nbsp:×
    catch /^Vim\%((\a\+)\)\=:E474/
        set listchars=tab:→\ ,trail:·,precedes:⇠,extends:⇢,nbsp:×
    endtry
endtry
set scrolloff=20
set noautochdir
set ruler
set wildmenu
set tabstop=4
set shiftwidth=4
set expandtab
set cursorline
set showtabline=2
set softtabstop=4
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif
set sidescrolloff=8
set langmap=аa,бb,вw,гg,дd,еe,жv,зz,иi,йj,кk,лl,мm,нn,оo,пp,рr,сs,тt,уu,фf,хh,цc,ч`,ш[,щ],ъy,ьx,ю\\,яq,АA,БB,ВV,ГG,ДD,ЕE,ЖV,ЗZ,ИI,ЙJ,КK,ЛL,МM,НN,ОO,ПP,РR,СS,ТT,УU,ФF,ХH,ЦC,Ч~,Ш{,Щ},ЪY,ЬX,Ю\|,ЯQ
set iminsert=0
set imsearch=0
set noswapfile
set nobackup
let mapleader=" "
let maplocalleader=" "
filetype plugin indent on

" keymaps
inoremap <A-BS> <C-w>
inoremap <A-left> <S-left>
inoremap <A-right> <S-right>
nnoremap <Esc><Esc> :noh<CR>
vnoremap < <gv
vnoremap > >gv
nnoremap x "_x
nnoremap X "_X
nnoremap Q :qa!<CR>
vnoremap p "_dP
nnoremap <Tab> :bnext!<CR>
nnoremap <S-Tab> :bprevious!<CR>
inoremap <C-f> <C-^>
cnoremap <C-f> <C-^>
inoremap <C-z> <C-o>u
inoremap <C-y> <C-o><C-r>
nnoremap <leader>a gg^VG$
nnoremap <leader>v <c-v>
vnoremap <leader>v p
nnoremap <leader>x :bdelete!<CR>
nnoremap <leader>n :enew<CR>
nnoremap <leader>s :w<CR>
nnoremap <leader>h <C-^>
vnoremap <leader>h <C-^>
nnoremap <leader>wv <C-w>v
nnoremap <leader>wh <C-w>s
nnoremap <leader>q <C-w>c
nnoremap <C-k> :wincmd k<CR>
nnoremap <C-j> :wincmd j<CR>
nnoremap <C-h> :wincmd h<CR>
nnoremap <C-l> :wincmd l<CR>
nnoremap <leader>w<up> :wincmd k<CR>
nnoremap <leader>w<down> :wincmd j<CR>
nnoremap <leader>w<left> :wincmd h<CR>
nnoremap <leader>w<right> :wincmd l<CR>
nnoremap <leader>wk :wincmd k<CR>
nnoremap <leader>wj :wincmd j<CR>
nnoremap <leader>wh :wincmd h<CR>
nnoremap <leader>wl :wincmd l<CR>
" Terminal mode exists only in newer Vim. On old Vim the earlier <C-l>
" window-navigation mapping remains in effect.
if exists(':terminal') && exists(':tnoremap')
    nnoremap <c-l> :term<CR>
    tnoremap <c-l> <C-\><C-n>:q!<CR>
    nnoremap <c-@> :term<CR>
    tnoremap <c-@> <C-\><C-n>:q!<CR>
endif

" maps in cyrillic
inoremap <C-ъ> <C-o><C-r>
inoremap <C-з> <C-o>u
nnoremap <leader>а gg^VG$
nnoremap <leader>ж <c-v>
vnoremap <leader>ж p
nnoremap <leader>ь :bdelete!<CR>
nnoremap <leader>н :enew<CR>
nnoremap <leader>с :w<CR>
nnoremap <leader>х <C-^>
vnoremap <leader>х <C-^>
nnoremap <leader>вж <C-w>v
nnoremap <leader>вх <C-w>s
nnoremap <leader>я <C-w>c
nnoremap <C-к> :wincmd k<CR>
nnoremap <C-й> :wincmd j<CR>
nnoremap <C-х> :wincmd h<CR>
nnoremap <C-л> :wincmd l<CR>
nnoremap <leader>в<up> :wincmd k<CR>
nnoremap <leader>в<down> :wincmd j<CR>
nnoremap <leader>в<left> :wincmd h<CR>
nnoremap <leader>в<right> :wincmd l<CR>
nnoremap <leader>рк :wincmd k<CR>
nnoremap <leader>вй :wincmd j<CR>
nnoremap <leader>вх :wincmd h<CR>
nnoremap <leader>вл :wincmd l<CR>
if exists(':terminal') && exists(':tnoremap')
    nnoremap <c-л> :term<CR>
    tnoremap <c-л> <C-\><C-n>:q!<CR>
endif
nnoremap Я :qa!<CR>

" searching
set path+=**
set wildignore+=*/vendor/*
set wildignore+=*/node_modules/*
set wildignore+=*/.git/*
if executable('grep')
    set grepprg=grep\ -RIn\ --exclude-dir=vendor\ --exclude-dir=node_modules\ --exclude-dir=.git
    set grepformat=%f:%l:%m
endif
function! ProjectGrep()
    let l:query = input('Search: ')
    if empty(l:query)
        return
    endif
    execute 'silent grep! ' . shellescape(l:query) . ' .'
    copen
endfunction
nnoremap <leader>o :find **<Left>
nnoremap <leader>о :find **<Left>
nnoremap <leader>f :call ProjectGrep()<CR>
nnoremap <leader>ф :call ProjectGrep()<CR>
nnoremap - :Explore<CR>

" Quickfix
function! ToggleQuickfix()
    for i in range(1, winnr('$'))
        let l = getwinvar(i, '&buftype')
        if l ==# 'quickfix'
            cclose
            return
        endif
    endfor
    copen
endfunction
nnoremap <leader>zz :call ToggleQuickfix()<CR>
nnoremap <leader>зз :call ToggleQuickfix()<CR>
noremap <leader>zj :cnext<CR>zz
noremap <leader>zk :cprev<CR>zz
noremap <leader>зй :cnext<CR>zz
noremap <leader>зк :cprev<CR>zz

" clipboard
function! Osc52Copy(text)
  let l:b64 = system('base64 | tr -d "\n"', a:text)
  let l:seq = "\e]52;c;" . l:b64 . "\x07"

  if exists('$TMUX')
    let l:seq = "\ePtmux;\e" . substitute(l:seq, "\e", "\e\e", 'g') . "\e\\"
  endif

  call writefile([l:seq], '/dev/tty', 'b')
endfunction
vnoremap <leader>c y:call Osc52Copy(@")<CR>
vnoremap <leader>ц y:call Osc52Copy(@")<CR>
vnoremap <M-c> y:call Osc52Copy(@")<CR>
vnoremap <Esc>c y:call Osc52Copy(@")<CR>

" tabs
set showtabline=2
function! BufferTabLine()
    let s = ''
    " buflisted()/bufnr() work on Vim 7.4; getbufinfo() is newer.
    for bnr in range(1, bufnr('$'))
        if !buflisted(bnr)
            continue
        endif
        let current = bnr == bufnr('%')
        let s .= current ? '%#TabLineSel#' : '%#TabLine#'
        let s .= '%' . bnr . ''
        let name = fnamemodify(bufname(bnr), ':t')
        if empty(name)
            let name = '[No Name]'
        endif
        let s .= '  ' . name
        if getbufvar(bnr, '&modified')
            let s .= ' +'
        endif
        let s .= ' '
        let s .= '%X'
    endfor
    let s .= '%#TabLineFill#%T'
    return s
endfunction
set tabline=%!BufferTabLine()

" theme
set background=dark
highlight clear
if exists("syntax_on")
    syntax reset
endif
syntax enable
highlight Normal       guifg=#cad3f5 guibg=#24273a ctermfg=189 ctermbg=NONE
highlight NormalNC     guifg=#cad3f5 guibg=#24273a ctermfg=189 ctermbg=NONE
highlight LineNr       guifg=#5b6078 guibg=#24273a ctermfg=60 ctermbg=NONE
highlight FoldColumn   guifg=#5b6078 guibg=#24273a ctermfg=60 ctermbg=NONE
highlight SignColumn   guifg=#5b6078 guibg=#24273a ctermfg=60 ctermbg=NONE
highlight VertSplit    guifg=#363a4f guibg=#24273a ctermfg=237 ctermbg=NONE
highlight EndOfBuffer guifg=#24273a guibg=#24273a ctermfg=235 ctermbg=NONE

" highlight Normal         guifg=#cad3f5 guibg=#24273a ctermfg=189 ctermbg=235
" highlight NormalNC       guifg=#cad3f5 guibg=#24273a ctermfg=189 ctermbg=235
highlight CursorColumn   guibg=#2b2f45 ctermbg=236
highlight ColorColumn    guibg=#1e2030 ctermbg=234
highlight CursorLine   guibg=#2b2f45 gui=NONE ctermbg=236 cterm=NONE
highlight CursorLineNr guifg=#eed49f guibg=NONE gui=bold ctermfg=222 ctermbg=NONE cterm=bold
" highlight LineNr         guifg=#5b6078 guibg=#24273a ctermfg=60 ctermbg=235
" highlight FoldColumn     guifg=#5b6078 guibg=#24273a ctermfg=60 ctermbg=235
" highlight SignColumn     guifg=#5b6078 guibg=#24273a ctermfg=60 ctermbg=235
highlight Folded         guifg=#a5adcb guibg=#1e2030 ctermfg=146 ctermbg=234
highlight NonText        guifg=#494d64 guibg=NONE ctermfg=239
highlight SpecialKey     guifg=#494d64 guibg=NONE ctermfg=239
" highlight EndOfBuffer    guifg=#24273a guibg=#24273a ctermfg=235 ctermbg=235
highlight TabLine      guifg=#a5adcb guibg=NONE gui=NONE cterm=NONE term=NONE ctermfg=146 ctermbg=NONE
highlight TabLineSel   guifg=#24273a guibg=#8aadf4 gui=bold ctermfg=235 ctermbg=111 cterm=bold
highlight TabLineFill guifg=#24273a guibg=NONE gui=NONE cterm=NONE term=NONE
highlight StatusLine     guifg=#cad3f5 guibg=#363a4f gui=bold ctermfg=189 ctermbg=237 cterm=bold
highlight StatusLineNC   guifg=#6e738d guibg=#1e2030 ctermfg=243 ctermbg=234
" highlight VertSplit      guifg=#363a4f guibg=#24273a ctermfg=237 ctermbg=235
highlight Visual         guibg=#494d64 ctermbg=239
highlight Search         guifg=#24273a guibg=#eed49f ctermfg=235 ctermbg=222
highlight IncSearch      guifg=#24273a guibg=#f5a97f ctermfg=235 ctermbg=216
highlight MatchParen     guifg=#f5bde6 guibg=#494d64 gui=bold ctermfg=218 ctermbg=239 cterm=bold
highlight Pmenu          guifg=#cad3f5 guibg=#1e2030 ctermfg=189 ctermbg=234
highlight PmenuSel       guifg=#24273a guibg=#8aadf4 ctermfg=235 ctermbg=111
highlight WildMenu       guifg=#24273a guibg=#eed49f ctermfg=235 ctermbg=222
highlight ErrorMsg       guifg=#ed8796 guibg=NONE ctermfg=210
highlight WarningMsg     guifg=#eed49f guibg=NONE ctermfg=222
highlight ModeMsg        guifg=#a6da95 guibg=NONE ctermfg=150
highlight MoreMsg        guifg=#8aadf4 guibg=NONE ctermfg=111
highlight Question       guifg=#8aadf4 guibg=NONE ctermfg=111
highlight Comment        guifg=#6e738d gui=italic ctermfg=243
highlight Constant       guifg=#f5a97f ctermfg=216
highlight String         guifg=#a6da95 ctermfg=150
highlight Character      guifg=#a6da95 ctermfg=150
highlight Number         guifg=#f5a97f ctermfg=216
highlight Boolean        guifg=#f5a97f ctermfg=216
highlight Float          guifg=#f5a97f ctermfg=216
highlight Identifier     guifg=#8aadf4 ctermfg=111
highlight Function       guifg=#8aadf4 ctermfg=111
highlight Statement      guifg=#c6a0f6 ctermfg=183
highlight Conditional    guifg=#c6a0f6 ctermfg=183
highlight Repeat         guifg=#c6a0f6 ctermfg=183
highlight Label          guifg=#c6a0f6 ctermfg=183
highlight Operator       guifg=#91d7e3 ctermfg=116
highlight Keyword        guifg=#c6a0f6 ctermfg=183
highlight Exception      guifg=#c6a0f6 ctermfg=183
highlight PreProc        guifg=#f5bde6 ctermfg=218
highlight Include        guifg=#c6a0f6 ctermfg=183
highlight Define         guifg=#c6a0f6 ctermfg=183
highlight Macro          guifg=#f5bde6 ctermfg=218
highlight Type           guifg=#8bd5ca ctermfg=116
highlight StorageClass   guifg=#8bd5ca ctermfg=116
highlight Structure      guifg=#8bd5ca ctermfg=116
highlight Typedef        guifg=#8bd5ca ctermfg=116
highlight Special        guifg=#f5bde6 ctermfg=218
highlight SpecialChar    guifg=#f5bde6 ctermfg=218
highlight Todo           guifg=#24273a guibg=#eed49f gui=bold ctermfg=235 ctermbg=222 cterm=bold
highlight Error          guifg=#ed8796 guibg=NONE ctermfg=210

" cursor
if &term =~ '256color'
    let &t_SI = "\<Esc>[6 q"
    let &t_EI = "\<Esc>[2 q"
endif

