return {
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup {
                keymaps = {
                    ["<Esc>"] = "actions.close",
                    ["q"] = "actions.close",
                },
                float = {
                    border = "rounded",
                    win_options = {
                        winblend = 0,
                    }
                },
                default_file_explorer = true,
                delete_to_trash = true,
                skip_confirm_for_simple_edits = true,
                columns = { "icon", "permissions", "size" },
                view_options = {
                    show_hidden = true,
                    -- is_always_hidden = function (name, _)
                    --     return name == '..' or name == '.git' or name == '.svn'
                    -- end
                },
                win_options = {
                    wrap = true,
                }
            }
        end,
    }
}
