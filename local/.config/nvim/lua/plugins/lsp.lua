-- all needed plugins for lsp
return {
    { "folke/lazydev.nvim", opts = {} },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'j-hui/fidget.nvim', opts = {} },
            -- 'hrsh7th/cmp-nvim-lsp',
            -- 'hrsh7th/cmp-nvim-lsp-signature-help',
        },
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or 'n'
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
                    end
                    map('<leader>lr', vim.lsp.buf.rename, 'Rename')
                    map('<leader>lu', vim.lsp.buf.references, 'References')
                    map('<leader>la', function() vim.lsp.buf.code_action({apply=true}) end, 'Code Action', { 'n', 'x' })
                    map('<leader>ld', vim.lsp.buf.declaration, 'Goto Declaration')
                    map('<leader>lf', vim.lsp.buf.format, 'Format')
                    map('<leader>лр', vim.lsp.buf.rename, 'Rename')
                    map('<leader>лу', vim.lsp.buf.references, 'References')
                    map('<leader>ла', function() vim.lsp.buf.code_action({apply=true}) end, 'Code Action', { 'n', 'x' })
                    map('<leader>лд', vim.lsp.buf.declaration, 'Goto Declaration')
                    map('<leader>лф', vim.lsp.buf.format, 'Format')
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    -- if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                    --     local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
                    --     vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
                    --         buffer = event.buf,
                    --         group = highlight_augroup,
                    --         callback = vim.lsp.buf.document_highlight,
                    --     })
                    --     vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
                    --         buffer = event.buf,
                    --         group = highlight_augroup,
                    --         callback = vim.lsp.buf.clear_references,
                    --     })
                    --     vim.api.nvim_create_autocmd('LspDetach', {
                    --         group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
                    --         callback = function(event2)
                    --             vim.lsp.buf.clear_references()
                    --             vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
                    --         end,
                    --     })
                    -- end
                end,
            })
            local get_intelephense_license = function ()
                local f = assert(io.open(os.getenv("HOME") .. "/intelephense/license.txt", "rb"))
                local content = f:read("*a")
                f:close()
                local key = string.gsub(content, "%s+", "")
                return key
            end
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            --capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
            capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())
            capabilities.textDocument.codeAction.documentationSupport = true
            capabilities.textDocument.foldingRange = {  dynamicRegistration = false, lineFoldingOnly = true }
            capabilities.textDocument.completion.completionItem.snippetSupport = true
            vim.lsp.config("intelephense", {
                cmd = { "intelephense", "--stdio" }, -- assumes it's in your PATH
                root_dir = function(bufnr, on_dir)
                    if vim.fs.root(bufnr, 'composer.json') then on_dir(vim.fn.getcwd()) end
                    if vim.fs.root(bufnr, 'vendor') then on_dir(vim.fn.getcwd()) end
                    if vim.fs.root(bufnr, '.git') then on_dir(vim.fn.getcwd()) end
                end,
                capabilities = capabilities,
                init_options = {
                    licenceKey = get_intelephense_license(),
                    globalStoragePath = vim.fn.stdpath("cache") .. "/intelephense"
                }
            })
            -- ZLS LSP Setup
            vim.lsp.config("zls", {
                cmd = { "zls" }, -- assumes it's in your PATH
                capabilities = capabilities,
                root_dir = function(bufnr, on_dir)
                    if vim.fs.root(bufnr, 'build.zig') then on_dir(vim.fn.getcwd()) end
                    if vim.fs.root(bufnr, '.git') then on_dir(vim.fn.getcwd()) end
                end,
            })
            vim.lsp.enable({"intelephense","zls"})
        end,
    },
    {
        "lewis6991/hover.nvim",
        config = function()
            require("hover").setup {
                init = function()
                    -- Require providers
                    require("hover.providers.lsp")
                    -- require('hover.providers.gh')
                    -- require('hover.providers.gh_user')
                    -- require('hover.providers.jira')
                    -- require('hover.providers.dap')
                    -- require('hover.providers.fold_preview')
                    -- require('hover.providers.diagnostic')
                    -- require('hover.providers.man')
                    -- require('hover.providers.dictionary')
                end,
                preview_opts = {
                    border = 'single'
                },
                -- Whether the contents of a currently open hover window should be moved
                -- to a :h preview-window when pressing the hover keymap.
                preview_window = false,
                title = true,
                mouse_providers = {
                    'LSP'
                },
                mouse_delay = 500
            }

            -- Setup keymaps
            vim.keymap.set("n", "<leader>lh", require("hover").hover, {desc = "hover.nvim"})
            vim.keymap.set("n", "<leader>лх", require("hover").hover, {desc = "hover.nvim"})
            vim.keymap.set("n", "<leader>lk", require("hover").hover, {desc = "hover.nvim"})
            vim.keymap.set("n", "<leader>лк", require("hover").hover, {desc = "hover.nvim"})
            -- vim.keymap.set("n", "gK", require("hover").hover_select, {desc = "hover.nvim (select)"})
            -- vim.keymap.set("n", "<C-p>", function() require("hover").hover_switch("previous") end, {desc = "hover.nvim (previous source)"})
            -- vim.keymap.set("n", "<C-n>", function() require("hover").hover_switch("next") end, {desc = "hover.nvim (next source)"})

            -- Mouse support
            -- vim.keymap.set('n', '<MouseMove>', require('hover').hover_mouse, { desc = "hover.nvim (mouse)" })
            -- vim.o.mousemoveevent = true
        end
    },
    {
        'Bekaboo/dropbar.nvim',
    }
}
