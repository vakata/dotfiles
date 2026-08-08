require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.treesitter")
require("config.lazy")

-- vim.lsp.config.intelephense = {
--     cmd = { 'intelephense', '--stdio' },
--     root_markers = {"composer.json", ".git", "vendor"},
--     filetypes = { "php" }
-- }
-- vim.lsp.enable({ 'intelephense' })
-- vim.api.nvim_create_autocmd('LspAttach', {
--     callback = function(ev)
--         local client = vim.lsp.get_client_by_id(ev.data.client_id)
--         if client:supports_method('textDocument/completion') then
--             vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
--         end
--     end,
-- })
