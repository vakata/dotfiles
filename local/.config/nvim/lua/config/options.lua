vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

vim.opt.clipboard = ''
vim.opt.cmdheight = 0
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldcolumn = '1'
vim.opt.foldtext = ''
vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 4
vim.opt.fillchars = [[eob: ,fold: ,foldopen:-,foldsep: ,foldclose:+]]
vim.opt.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.opt.number = true
-- vim.opt.relativenumber = true
vim.opt.mouse = ''
vim.opt.showmode = false
vim.opt.whichwrap = 'bs<>[]hl' -- which "horizontal" keys are allowed to travel to prev/next line
vim.opt.wrap = false -- display lines as one long line
vim.opt.linebreak = true -- companion to wrap don't split words
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.startofline = false
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = 'split'
vim.opt.scrolloff = 8
-- vim.opt.cc = '120'
vim.opt.autochdir = false
vim.opt.ruler = true
vim.opt.wildmenu = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.cursorline = true
vim.opt.encoding = 'utf-8'
vim.opt.showtabline = 2
vim.opt.termguicolors = true
vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.list = true
vim.opt.listchars = { tab = '→  ', space = '·', trail = '·', precedes = '⇠', extends = '⇢', nbsp = '×' }
vim.opt.softtabstop = 4
vim.opt.sidescrolloff = 20
vim.opt.langmap =
'аa,бb,вw,гg,дd,еe,жv,зz,иi,йj,кk,лl,мm,нn,оo,пp,рr,сs,тt,уu,фf,хh,цc,ч`,ш[,щ],ъy,ьx,ю\\,яq,АA,БB,ВV,ГG,ДD,ЕE,ЖV,ЗZ,ИI,ЙJ,КK,ЛL,МM,НN,ОO,ПP,РR,СS,ТT,УU,ФF,ХH,ЦC,Ч~,Ш{,Щ},ЪY,ЬX,Ю|,ЯQ'
vim.opt.keymap = 'bulgarian-phonetic'
vim.opt.iminsert = 0
vim.opt.imsearch = 0
vim.opt.swapfile = true
vim.opt.directory = vim.fn.stdpath("state") .. "/swap" .. "//"
vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup" .. "//"
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("state") .. "/undodir"
-- vim.opt.winborder = 'rounded'
--
vim.opt.guicursor:append("t:block-blinkon0")

-- plugins
-- vim.g['lightline#bufferline#clickable'] = 1
-- vim.g['lightline#bufferline#enable_devicons'] = 1
-- vim.g['lightline#bufferline#enable_nerdfont'] = 1
-- vim.g['lightline#bufferline#unicode_symbols'] = 1
vim.g['git_messenger_include_diff'] = 'current'
vim.g['git_messenger_always_into_popup'] = true
vim.g['git_messenger_no_default_mappings'] = true
vim.g['git_messenger_floating_win_opts'] = { border = 'single' }

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '•', -- or other icon of your choice here, this is just what my config has:
            [vim.diagnostic.severity.WARN] = '•',
            [vim.diagnostic.severity.INFO] = '•',
            [vim.diagnostic.severity.HINT] = '•',
        },
    },
    virtual_lines = {
        current_line = true
    }
})

