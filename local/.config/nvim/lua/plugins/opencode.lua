return {
    "nickjvandyke/opencode.nvim",
    version = "*", -- Latest stable release
    config = function()
        ---@type opencode.Opts
        vim.g.opencode_opts = {
            -- Your configuration, if any; goto definition on the type for details
        }

        vim.o.autoread = true -- Required for `vim.g.opencode_opts.events.reload`

        -- Recommended/example keymaps
        vim.keymap.set({ "n", "x" }, "<leader>aia", function() require("opencode").ask("@this: ") end, { desc = "Ask OpenCode…" })
        vim.keymap.set({ "n", "x" }, "<leader>ais", function() require("opencode").select() end,       { desc = "Select OpenCode…" })

        vim.keymap.set({ "n", "x" }, "<leader>air",  function() return require("opencode").operator("@this ") end,        { desc = "Append range to OpenCode", expr = true })
        vim.keymap.set("n",          "<leader>ail", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Append line to OpenCode", expr = true })

        vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll OpenCode up" })
        vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll OpenCode down" })
    end,
}
-- return {}
-- return {
    --     'NickvanDyke/opencode.nvim',
    --     enabled = false,
    --     dependencies = { 'folke/snacks.nvim', },
    --     ---@type opencode.Config
    --     opts = {
        --         -- Your configuration, if any
        --     },
        --     -- stylua: ignore
        --     keys = {
            --         { '<leader>ai', function() require('opencode').toggle() end, desc = 'Toggle embedded opencode', mode = {'n', 'v'} },
            --         -- { '<leader>oa', function() require('opencode').ask() end, desc = 'Ask opencode', mode = 'n', },
            --         -- { '<leader>oa', function() require('opencode').ask('@selection: ') end, desc = 'Ask opencode about selection', mode = 'v', },
            --         -- { '<leader>op', function() require('opencode').select_prompt() end, desc = 'Select prompt', mode = { 'n', 'v', }, },
            --         -- { '<leader>on', function() require('opencode').command('session_new') end, desc = 'New session', },
            --         -- { '<leader>oy', function() require('opencode').command('messages_copy') end, desc = 'Copy last message', },
            --         -- { '<S-C-u>',    function() require('opencode').command('messages_half_page_up') end, desc = 'Scroll messages up', },
            --         -- { '<S-C-d>',    function() require('opencode').command('messages_half_page_down') end, desc = 'Scroll messages down', },
            --     },
            -- }
