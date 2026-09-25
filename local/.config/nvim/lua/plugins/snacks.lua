return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        image = { enabled = false },
        dashboard = { enabled = true },
        indent = { enabled = true },
        input = { enabled = true },
        notifier = { enabled = true },
        terminal = {
            interactive = true,
            win = {
                position = "float",
                border = "rounded"
            },
        },
        scroll = { enabled = false },
        lazygit = {
            config = {
                quitOnTopLevelReturn = true,
            },
        },
    }
}
