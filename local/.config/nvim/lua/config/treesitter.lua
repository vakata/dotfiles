-- local function has_parser(lang)
--   return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", true) > 0
-- end
--
-- vim.api.nvim_create_autocmd("FileType", {
--   group = vim.api.nvim_create_augroup("NativeTreesitter", { clear = true }),
--   callback = function(args)
--     local bufnr = args.buf
--     local ft = vim.bo[bufnr].filetype
--
--     local lang = ({
--       php = "php",
--       javascriptreact = "tsx",
--       typescriptreact = "tsx",
--     })[ft] or ft
--
--     if has_parser(lang) then
--       pcall(vim.treesitter.start, bufnr, lang)
--     end
--   end,
-- })
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("NativeTreesitter", { clear = true }),
  callback = function(args)
    pcall(vim.treesitter.start, args.buf)
  end,
})
