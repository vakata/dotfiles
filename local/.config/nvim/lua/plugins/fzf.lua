return {
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("fzf-lua").setup({
                keymap = {
                    fzf = {
                        ["ctrl-q"] = "select-all+accept",
                    },
                },
                previewers = {
                    builtin = {
                        treesitter = {
                            context = false
                        }
                    }
                }
            })
            require('fzf-lua').register_ui_select()
        end
    }
}
