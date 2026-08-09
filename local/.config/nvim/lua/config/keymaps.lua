-- navigation
vim.keymap.set('i', '<A-BS>', '<C-w>') -- delete word with alt-backspace
vim.keymap.set('i', '<A-left>', '<S-left>') -- move by word in insert mode using alt (win habit)
vim.keymap.set('i', '<A-right>', '<S-right>') -- move by word in insert mode using alt (win habit)
vim.keymap.set('i', '<C-f>', '<C-^>') -- change language in insert mode
vim.keymap.set('c', '<C-f>', '<C-^>') -- change language in command mode
vim.keymap.set('i', '<C-ф>', '<C-^>') -- change language in insert mode
vim.keymap.set('c', '<C-ф>', '<C-^>') -- change language in command mode
vim.keymap.set('i', '``', '<esc>') -- esc in insert mode
vim.keymap.set("i", "<C-s>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
    vim.schedule(function()
        require("flash").jump()
        vim.api.nvim_feedkeys("i", "n", false)
    end)
end, { noremap = true, desc = "Flash jump from insert mode" })
vim.keymap.set("i", "<C-с>", function()
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
    vim.schedule(function()
        require("flash").jump()
        vim.api.nvim_feedkeys("i", "n", false)
    end)
end, { noremap = true, desc = "Flash jump from insert mode" })
vim.keymap.set('n', '<cr>', 'o<esc>', { noremap = true, silent = true }) -- add new line below
vim.keymap.set('n', '<leader><cr>', 'O<esc>', { noremap = true, silent = true }) -- add new line above
vim.keymap.set('n', '<leader>j', 'J', { noremap = true, silent = true }) -- add new line above
vim.keymap.set('n', 'J', 'j', { noremap = true, silent = true }) -- add new line above
vim.keymap.set('n', 'K', 'k', { noremap = true, silent = true }) -- add new line above
vim.keymap.set('n', 'L', 'l', { noremap = true, silent = true }) -- add new line above
vim.keymap.set('n', 'H', 'h', { noremap = true, silent = true }) -- add new line above
-- Allow moving the cursor through wrapped lines with j, k
-- vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
-- vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- session
vim.keymap.set("n", "<leader>ys", function() require("persistence").start() end, { desc = "Start a session" })
vim.keymap.set("n", "<leader>yx", function() require("persistence").stop() end, { desc = "Stop a session" })
vim.keymap.set("n", "<leader>yl", function()
    local Config = require("persistence.config")
    local uv = vim.uv or vim.loop
    local sessions = require('persistence').list()
    local items = {}
    local have = {} ---@type table<string, boolean>
    for _, session in ipairs(sessions) do
        if uv.fs_stat(session) then
            local file = session:sub(#Config.options.dir + 1, -5)
            local dir, branch = unpack(vim.split(file, "%%", { plain = true }))
            dir = dir:gsub("%%", "/")
            if jit.os:find("Windows") then
                dir = dir:gsub("^(%w)/", "%1:/")
            end
            if not have[dir] then
                have[dir] = true
                items[#items + 1] = dir
            end
        end
    end
    local opts = {}
    opts.prompt = 'Sessions> '
    opts.actions = {
        ['default'] = function(selected)
            require("persistence").stop()
            vim.fn.chdir(selected[1])
            require('persistence').load()
            require('persistence').start()
        end
    }
    require('fzf-lua').fzf_exec(items, opts)
end, { desc = "Load a session" })
-- FZF
vim.keymap.set("n", "<leader>m", function () require("fzf-lua").marks() end, { desc = "Marks" })
vim.keymap.set("n", "<leader>f", function () require("fzf-lua").live_grep() end, { desc = "Fzf Grep" })
vim.keymap.set("n", "<leader>r", function () require("fzf-lua").resume() end, { desc = "Fzf Resume" })
vim.keymap.set("n", "<leader>F", function () require("fzf-lua").live_grep({ no_ignore = true, hidden = true }) end, { desc = "Fzf Grep" })
vim.keymap.set("n", "<leader>b", function () require("fzf-lua").buffers() end, { desc = "Fzf Buffers" })
vim.keymap.set("n", "<leader>o", function () require("fzf-lua").git_files() end, { desc = "Git Files" })
vim.keymap.set("n", "<leader>O", function () require("fzf-lua").files({ no_ignore = true }) end, { desc = "Fzf Files" })
vim.keymap.set("n", "<leader>k", function () require("fzf-lua").blines() end, { desc = "Buffer lines" })
vim.keymap.set("n", "<leader>м", function () require("fzf-lua").marks() end, { desc = "Marks" })
vim.keymap.set("n", "<leader>ф", function () require("fzf-lua").live_grep() end, { desc = "Fzf Grep" })
vim.keymap.set("n", "<leader>р", function () require("fzf-lua").resume() end, { desc = "Fzf Resume" })
vim.keymap.set("n", "<leader>Ф", function () require("fzf-lua").live_grep({ no_ignore = true, hidden = true }) end, { desc = "Fzf Grep" })
vim.keymap.set("n", "<leader>б", function () require("fzf-lua").buffers() end, { desc = "Fzf Buffers" })
vim.keymap.set("n", "<leader>о", function () require("fzf-lua").git_files() end, { desc = "Git Files" })
vim.keymap.set("n", "<leader>О", function () require("fzf-lua").files({ no_ignore = true }) end, { desc = "Fzf Files" })
vim.keymap.set("n", "<leader>к", function () require("fzf-lua").blines({sort_lastused = false}) end, { desc = "Buffer lines" })
-- GIT
vim.keymap.set("n", "<leader>gg", function () require("snacks").lazygit.open() end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gc", function () require("fzf-lua").git_bcommits() end, { desc = "Browse File Commits" })
vim.keymap.set("n", "<leader>gs", function () require("fzf-lua").git_status() end, { desc = "Git Status" })
vim.keymap.set("n", "<leader>gb", function () require("fzf-lua").git_branches() end, { desc = "Git Branches" })
vim.keymap.set("n", "<leader>gu", function () require("fzf-lua").git_blame() end, { desc = "Git Blame" })
vim.keymap.set("n", "<leader>gl", ':GitMessenger<CR>', { desc = "Git Line" })
vim.keymap.set("n", "<leader>gd", ':DiffviewOpen<CR>', { desc = "Git diffview" })
vim.keymap.set("n", "<leader>gx", ':DiffviewClose<CR>', { desc = "Git diffview" })
vim.keymap.set("n", "<leader>гг", function () require("snacks").lazygit.open() end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>гц", function () require("fzf-lua").git_bcommits() end, { desc = "Browse File Commits" })
vim.keymap.set("n", "<leader>гс", function () require("fzf-lua").git_status() end, { desc = "Git Status" })
vim.keymap.set("n", "<leader>гб", function () require("fzf-lua").git_branches() end, { desc = "Git Branches" })
vim.keymap.set("n", "<leader>гу", function () require("fzf-lua").git_blame() end, { desc = "Git Blame" })
vim.keymap.set("n", "<leader>гл", ':GitMessenger<CR>', { desc = "Git Line" })
vim.keymap.set("n", "<leader>гд", ':DiffviewOpen<CR>', { desc = "Git diffview" })
vim.keymap.set("n", "<leader>гь", ':DiffviewClose<CR>', { desc = "Git diffview" })
-- LSP
vim.keymap.set("n", "<leader>lj", function () require("fzf-lua").lsp_definitions() end, { desc = "Jump to Definition" })
vim.keymap.set("n", "<leader>lx", function () require("fzf-lua").diagnostics_workspace() end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>ls", function () require('fzf-lua').lsp_document_symbols() end, { desc = "Document Symbols" })
vim.keymap.set("n", "<leader>lk", function () require("fzf-lua").lsp_references() end, { desc = "LSP References" })
vim.keymap.set("n", "<leader>лй", function () require("fzf-lua").lsp_definitions() end, { desc = "Jump to Definition" })
vim.keymap.set("n", "<leader>ль", function () require("fzf-lua").diagnostics_workspace() end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>лс", function () require('fzf-lua').lsp_document_symbols() end, { desc = "Document Symbols" })
vim.keymap.set("n", "<leader>лк", function () require("fzf-lua").lsp_references() end, { desc = "LSP References" })
-- file navigation
vim.keymap.set("n", "-", function () require('oil').open_float() end, { desc = "Open parent directory" })
vim.keymap.set('n', '<leader>e', ':NvimTreeToggle direction=float<CR>', { noremap = true, silent = false, desc = "Toggle tree" })
vim.keymap.set('n', '<leader>е', ':NvimTreeToggle direction=float<CR>', { noremap = true, silent = false, desc = "Toggle tree" })
-- clear highlights
vim.keymap.set('n', '<Esc>', ':noh<CR>', { noremap = true, silent = true, desc = "Clear highlights" })
-- Stay in indent mode
vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true })
-- moving to start and end
vim.keymap.set('n', 'gg', 'gg^', { noremap = true, silent = true, desc = "Go to top" })
vim.keymap.set('n', 'G', 'G$', { noremap = true, silent = true, desc = "Go to bottom" })
-- save file
vim.keymap.set('n', '<leader>s', '<cmd>w<CR>', { noremap = true, silent = true, desc = "Save buffer" })
vim.keymap.set('n', '<leader>с', '<cmd>w<CR>', { noremap = true, silent = true, desc = "Save buffer" })
-- undo and redo in insert mode only
vim.keymap.set('i', '<C-z>', '<C-o>u', { noremap = true, silent = true })
vim.keymap.set('i', '<C-з>', '<C-o>u', { noremap = true, silent = true })
vim.keymap.set('i', '<C-y>', '<C-o><C-r>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-ъ>', '<C-o><C-r>', { noremap = true, silent = true })
-- select all
vim.keymap.set('n', '<leader>aa', function() vim.api.nvim_win_set_cursor(0, { 1, 0 }) vim.cmd('normal! VG') end, { noremap = true, silent = true, desc = "Select all" })
vim.keymap.set('n', '<leader>аа', function() vim.api.nvim_win_set_cursor(0, { 1, 0 }) vim.cmd('normal! VG') end, { noremap = true, silent = true, desc = "Select all" })
-- avoid copying into register
vim.keymap.set({"n","v"}, 'x', '"_x', { noremap = true, silent = true })
vim.keymap.set({"n","v"}, 'X', '"_X', { noremap = true, silent = true })
-- Keep last yanked when pasting
vim.keymap.set('v', 'p', '"_dP', { noremap = true, silent = true })
-- yanky
vim.keymap.set({"n","x"}, "p", "<Plug>(YankyPutAfter)", {desc="Paste after"})
vim.keymap.set({"n","x"}, "P", "<Plug>(YankyPutBefore)", {desc="Paste before"})
vim.keymap.set({"n","x"}, "<leader>P", "<cmd>YankyRingHistory<cr>", {desc="Yank history"})
vim.keymap.set({"n","x"}, "<leader>П", "<cmd>YankyRingHistory<cr>", {desc="Yank history"})
vim.keymap.set({"n","x"}, "п", "<Plug>(YankyPutAfter)", {desc="Paste after"})
vim.keymap.set({"n","x"}, "П", "<Plug>(YankyPutBefore)", {desc="Paste before"})
vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)", {desc="Previous clipboard item"})
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)", {desc="Next clipboard item"})
vim.keymap.set("n", "<c-п>", "<Plug>(YankyPreviousEntry)", {desc="Previous clipboard item"})
vim.keymap.set("n", "<c-н>", "<Plug>(YankyNextEntry)", {desc="Next clipboard item"})
-- Buffers
vim.keymap.set('n', '<Tab>', ':bnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<A-left>', ':bprevious<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<A-right>', ':bnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', { noremap = true, silent = true, desc = "Close buffer" })
vim.keymap.set('n', '<leader>X', ':%bd <bar> e# <bar> bd#<CR> <bar> \'"', { noremap = true, silent = true, desc = "Close other buffers" })
vim.keymap.set('n', '<leader>N', '<cmd> enew <CR>', { noremap = true, silent = true, desc = "New buffer" })
vim.keymap.set('n', '<leader>n', function () require('snacks').notifier.hide() end, { noremap = true, silent = true, desc = "Close notifications" })
vim.keymap.set({ 'n', 'v' }, '<leader>h', '<C-^>', { noremap = true, silent = true, desc = "Last buffer" })
vim.keymap.set('n', '<leader>ь', ':bdelete!<CR>', { noremap = true, silent = true, desc = "Close buffer" })
vim.keymap.set('n', '<leader>ѝ', ':%bd <bar> e# <bar> bd#<CR> <bar> \'"', { noremap = true, silent = true, desc = "Close other buffers" })
vim.keymap.set('n', '<leader>н', '<cmd> enew <CR>', { noremap = true, silent = true, desc = "New buffer" })
vim.keymap.set({ 'n', 'v' }, '<leader>х', '<C-^>', { noremap = true, silent = true, desc = "Last buffer" })
-- Window management
vim.keymap.set('n', '<leader>q', '<C-w>c', { noremap = true, silent = true, desc = "Close window" })
vim.keymap.set('n', '<leader>wv', '<C-w>v', { noremap = true, silent = true, desc = "Split window vertically" })
vim.keymap.set('n', '<leader>wh', '<C-w>s', { noremap = true, silent = true, desc = "Split window horizontally" })
vim.keymap.set('n', '<leader>я', '<C-w>c', { noremap = true, silent = true, desc = "Close window" })
vim.keymap.set('n', '<leader>вж', '<C-w>v', { noremap = true, silent = true, desc = "Split window vertically" })
vim.keymap.set('n', '<leader>вх', '<C-w>s', { noremap = true, silent = true, desc = "Split window horizontally" })
-- Navigate between splits
vim.keymap.set({ 'v', 't','n' }, '<C-k>', ':wincmd k<CR>', { noremap = true, silent = true, desc = "Top window" })
vim.keymap.set({ 'v', 't','n' }, '<C-j>', ':wincmd j<CR>', { noremap = true, silent = true, desc = "Bottom window" })
vim.keymap.set({ 'v', 't','n' }, '<C-h>', ':wincmd h<CR>', { noremap = true, silent = true, desc = "Left window" })
vim.keymap.set({ 'v', 't','n' }, '<C-l>', ':wincmd l<CR>', { noremap = true, silent = true, desc = "Right window" })
vim.keymap.set({ 'n', 'v', 't' }, '<leader>w<up>', ':wincmd k<CR>', { noremap = true, silent = true, desc = "Top window" })
vim.keymap.set({ 'n', 'v', 't' }, '<leader>w<down>', ':wincmd j<CR>', { noremap = true, silent = true, desc = "Bottom window" })
vim.keymap.set({ 'n', 'v', 't' }, '<leader>w<left>', ':wincmd h<CR>', { noremap = true, silent = true, desc = "Left window" })
vim.keymap.set({ 'n', 'v', 't' }, '<leader>w<right>', ':wincmd l<CR>', { noremap = true, silent = true, desc = "Right window" })
vim.keymap.set({ 'n', 'v', 't' }, '<leader>wk', ':wincmd k<CR>', { noremap = true, silent = true, desc = "Top window" })
vim.keymap.set({ 'n', 'v', 't' }, '<leader>wj', ':wincmd j<CR>', { noremap = true, silent = true, desc = "Bottom window" })
vim.keymap.set({ 'n', 'v', 't' }, '<leader>wh', ':wincmd h<CR>', { noremap = true, silent = true, desc = "Left window" })
vim.keymap.set({ 'n', 'v', 't' }, '<leader>wl', ':wincmd l<CR>', { noremap = true, silent = true, desc = "Right window" })
vim.keymap.set({ 'v', 'n', 't' }, '<C-к>', ':wincmd k<CR>', { noremap = true, silent = true, desc = "Top window" })
vim.keymap.set({ 'v', 'n', 't' }, '<C-й>', ':wincmd j<CR>', { noremap = true, silent = true, desc = "Bottom window" })
vim.keymap.set({ 'v', 'n', 't' }, '<C-х>', ':wincmd h<CR>', { noremap = true, silent = true, desc = "Left window" })
vim.keymap.set({ 'v', 'n', 't' }, '<C-л>', ':wincmd l<CR>', { noremap = true, silent = true, desc = "Right window" })
vim.keymap.set({ 'v', 'n', 't' }, '<leader>в<up>', ':wincmd k<CR>', { noremap = true, silent = true, desc = "Top window" })
vim.keymap.set({ 'v', 'n', 't' }, '<leader>в<down>', ':wincmd j<CR>', { noremap = true, silent = true, desc = "Bottom window" })
vim.keymap.set({ 'v', 'n', 't' }, '<leader>в<left>', ':wincmd h<CR>', { noremap = true, silent = true, desc = "Left window" })
vim.keymap.set({ 'v', 'n', 't' }, '<leader>в<right>', ':wincmd l<CR>', { noremap = true, silent = true, desc = "Right window" })
vim.keymap.set({ 'v', 'n', 't' }, '<leader>вк', ':wincmd k<CR>', { noremap = true, silent = true, desc = "Top window" })
vim.keymap.set({ 'v', 'n', 't' }, '<leader>вй', ':wincmd j<CR>', { noremap = true, silent = true, desc = "Bottom window" })
vim.keymap.set({ 'v', 'n', 't' }, '<leader>вх', ':wincmd h<CR>', { noremap = true, silent = true, desc = "Left window" })
vim.keymap.set({ 'v', 'n', 't' }, '<leader>вл', ':wincmd l<CR>', { noremap = true, silent = true, desc = "Right window" })
-- terminal
-- vim.keymap.set({ 'n', 'v', 'c', 'i' }, '<C-l>', '<cmd>ToggleTerm direction=float<CR>', { noremap = true, silent = false })
-- vim.keymap.set('t', '<C-l>', function () require('toggleterm').toggle() end, { noremap = true, silent = false })
-- vim.keymap.set({ 'n', 'v', 'c', 'i' }, '<C-л>', '<cmd>ToggleTerm direction=float<CR>', { noremap = true, silent = false })
-- vim.keymap.set('t', '<C-л>', function () require('toggleterm').toggle() end, { noremap = true, silent = false })
-- vim.keymap.set({ 'n', 'v', 'c', 'i' }, '<C-space>', '<cmd>ToggleTerm direction=float<CR>', { noremap = true, silent = false, desc = "Open terminal" })
-- vim.keymap.set('t', '<C-space>', function () require('toggleterm').toggle() end, { noremap = true, silent = false, desc = "Open terminal" })
vim.keymap.set({ 'n', 'v', 'c', 'i' }, '<C-space>', function () require('snacks').terminal.toggle() end, { noremap = true, silent = false, desc = "Open terminal" })
vim.keymap.set('t', '<C-space>', function () require('snacks').terminal.toggle() end, { noremap = true, silent = false, desc = "Open terminal" })
vim.keymap.set('n', '<leader>tt', function () require('snacks').terminal.toggle() end, { noremap = true, silent = false, desc = "Open terminal" })
-- comments
vim.keymap.set('n', '<C-/>', function () require('Comment.api').toggle.linewise.current() end, { noremap = true, silent = true, desc = "Comment out" })
vim.keymap.set('v', '<C-/>', "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", { noremap = true, silent = true, desc = "Comment out" })
vim.keymap.set('n', '<leader>/', function () require('Comment.api').toggle.linewise.current() end, { noremap = true, silent = true, desc = "Comment out" })
vim.keymap.set('v', '<leader>/', "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>", { noremap = true, silent = true, desc = "Comment out" })
-- toggle
vim.keymap.set('n', '<leader>tm', '<cmd>Neominimap toggle<cr>', { noremap = true, silent = false, desc = 'toggle minimap' })
vim.keymap.set('n', '<leader>tc', '<cmd>TSContextToggle<cr>', { noremap = true, silent = false, desc = 'toggle context' })
vim.keymap.set('n', '<leader>tw', '<cmd>set wrap!<cr>', { noremap = true, silent = false, desc = 'toggle wrap' })
vim.keymap.set('n', '<leader>tl', '<cmd>ToggleNeoColumn<cr>', { noremap = true, silent = false, desc = 'toggle column' })
vim.keymap.set('n', '<leader>ts', function () vim.opt.list = not vim.opt.list:get() end, { noremap = true, silent = false, desc = 'toggle whitespace' })
-- vim.keymap.set('n', '<leader>тм', function () require('mini.map').toggle() end, { noremap = true, silent = false, desc = 'toggle minimap' })
vim.keymap.set('n', '<leader>тм', '<cmd>Neominimap toggle<cr>', { noremap = true, silent = false, desc = 'toggle minimap' })
vim.keymap.set('n', '<leader>тц', '<cmd>TSContextToggle<cr>', { noremap = true, silent = false, desc = 'toggle context' })
vim.keymap.set('n', '<leader>тв', '<cmd>set wrap!<cr>', { noremap = true, silent = false, desc = 'toggle wrap' })
vim.keymap.set('n', '<leader>тл', '<cmd>ToggleNeoColumn<cr>', { noremap = true, silent = false, desc = 'toggle column' })
-- quickfix
vim.keymap.set('n', '<Leader>zz', function ()
    local windows = vim.fn.getwininfo()
    for _, win in pairs(windows) do
        if win["quickfix"] == 1 then
            vim.cmd.cclose()
            return
        end
    end
    vim.cmd.copen()
end, { desc = "Toggle Quickfix Window" })
vim.keymap.set('n', '<Leader>зз', function ()
    local windows = vim.fn.getwininfo()
    for _, win in pairs(windows) do
        if win["quickfix"] == 1 then
            vim.cmd.cclose()
            return
        end
    end
    vim.cmd.copen()
end, { desc = "Toggle Quickfix Window" })
vim.keymap.set('n', '<leader>zj', '<cmd>cnext<CR>zz', { desc = "Go to next quickfix item" })
vim.keymap.set('n', '<leader>zk', '<cmd>cprev<CR>zz', { desc = "Go to previous quickfix item" })
vim.keymap.set('n', '<leader>zx', '<cmd>call setqflist([], "r") <bar> cclose<CR>', { desc = "Clear list" })
vim.keymap.set('n', '<leader>зй', '<cmd>cnext<CR>zz', { desc = "Go to next quickfix item" })
vim.keymap.set('n', '<leader>зк', '<cmd>cprev<CR>zz', { desc = "Go to previous quickfix item" })
vim.keymap.set('n', '<leader>зь', '<cmd>call setqflist([], "r") <bar> cclose<CR>', { desc = "Clear list" })
vim.keymap.set('n', 'Q', '<cmd>q<CR>', { desc = "Quit" })
-- system clipboard (copy / paste)
vim.keymap.set("n", "<leader>c", [["+yy]], {desc="Copy line to system clipboard"})
vim.keymap.set("v", "<leader>c", [["+y]], {desc="Copy to system clipboard"})
vim.keymap.set("n", "<leader>C", [["+Y]], {desc="Copy to end of line to system clipboard"})
vim.keymap.set({"n", "v"}, "<leader>v", [["+p]], {desc="Paste from system clipboard"})
vim.keymap.set("n", "<leader>V", [["+P]], {desc="Paste before from system clipboard"})
vim.keymap.set("n", "<leader>ц", [["+yy]], {desc="Copy line to system clipboard"})
vim.keymap.set("v", "<leader>ц", [["+y]], {desc="Copy to system clipboard"})
vim.keymap.set("n", "<leader>Ц", [["+Y]], {desc="Copy to end of line to system clipboard"})
vim.keymap.set({"n", "v"}, "<leader>ж", [["+p]], {desc="Paste from system clipboard"})
vim.keymap.set("n", "<leader>Ж", [["+P]], {desc="Paste before from system clipboard"})
vim.keymap.set('n', '<leader>B', '<C-v>', { noremap = true, silent = true, desc = "Visual block mode" })
vim.keymap.set('i', '<C-g>', '<C-v>', { noremap = true, silent = true, desc = "Enter literal character" })
vim.keymap.set('i', '<C-v>', '<Esc>"+pa', { noremap = true, silent = true, desc = "Paste" })
if vim.env.SSH_TTY or vim.env.SSH_CONNECTION then
    vim.g.clipboard = {
        name = "OSC 52",
        copy = {
            ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
            ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
        },
        paste = {
            ["+"] = function() return vim.split(vim.fn.getreg(""), "\n") end,
            ["*"] = function() return vim.split(vim.fn.getreg(""), "\n") end,
        },
    }
end
vim.keymap.set("v", "<D-c>", '"+y', { desc = "Copy to system clipboard", })
vim.keymap.set("v", "<M-c>", '"+y', { desc = "Copy to system clipboard", })
-- command palette
vim.keymap.set({"n", "v"}, '<leader>p', function() require("keymap_palette").open() end, { noremap = true, silent = true, desc = "Keymap Palette" })
