-- -- yank highlight
-- vim.api.nvim_create_autocmd('TextYankPost', {
--     desc = 'Highlight when yanking (copying) text',
--     group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
--     callback = function()
--         vim.highlight.on_yank()
--     end,
-- })

vim.api.nvim_create_autocmd("VimEnter", {
    group = vim.api.nvim_create_augroup("Persistence", { clear = true }),
    callback = function()
        if vim.fn.argc() == 0 and not vim.g.started_with_stdin then
            local Config = require("persistence.config")
            local uv = vim.uv or vim.loop
            local sessions = require('persistence').list()
            local items = {}
            local have = {} ---@type table<string, boolean>
            local open = false
            items[#items + 1] = "Create new session for current folder"
            for _, session in ipairs(sessions) do
                if uv.fs_stat(session) then
                    local file = session:sub(#Config.options.dir + 1, -5)
                    local dir, branch = unpack(vim.split(file, "%%", { plain = true }))
                    dir = dir:gsub("%%", "/")
                    if jit.os:find("Windows") then
                        dir = dir:gsub("^(%w)/", "%1:/")
                    end
                    if not have[dir] then
                        if dir:gsub("/$","") == uv.cwd():gsub("/$","") then
                            open = true
                        end
                        have[dir] = true
                        items[#items + 1] = dir
                    end
                end
            end
            if open then
                require('persistence').load()
                -- require('mini.map').open()
            else
                local opts = {}
                opts.prompt = 'Sessions> '
                opts.actions = {
                    ['default'] = function(selected)
                        if selected[1] == "Create new session for current folder" then
                            require('persistence').start()
                            require('snacks').dashboard.open()
                        else
                            vim.fn.chdir(selected[1])
                            require('persistence').load()
                            require('persistence').start()
                            -- require('mini.map').open()
                        end
                    end,
                    ['esc'] = function ()
                        require('persistence').stop()
                        -- require('mini.map').open()
                        require('snacks').dashboard.open()
                    end
                }
                require('fzf-lua').fzf_exec(items, opts)
            end
        else
            require('persistence').stop()
            -- require('mini.map').open()
        end
    end,
    nested = true
})

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        opts = opts or {}
        local patterns = opts.patterns or {
            "Float", "Pmenu", "Popup", "Hover", "Signature",
            "Telescope", "WhichKey", "Cmp", "Noice", "Dressing",
            "Fzf", "FzfLua", "Notify", "Saga", "Outline", "Overseer",
        }
        local border_keys = opts.border_keys or { "Border", "Separator", "Title" }

        -- Helper: does `name` match any needle (substring or Lua pattern)
        local function matches_any(name, needles)
            for _, n in ipairs(needles) do
                if name:find(n) then return true end
            end
            return false
        end

        -- Use Normal fg for borders so they’re visible on any theme
        local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
        local border_fg = normal and normal.fg or nil

        -- Get all highlight groups defined right now
        local groups = vim.fn.getcompletion("", "highlight")

        for _, g in ipairs(groups) do
            if matches_any(g, patterns) then
                -- Transparent background for anything popup-ish
                local spec = { bg = "NONE" }
                if matches_any(g, border_keys) then
                    spec.fg = border_fg
                end
                -- Don’t nuke selection contrast in menus unless you want to:
                if g == "PmenuSel" then
                    -- keep PmenuSel visible; comment next line if you want it transparent too
                    goto continue
                end
                pcall(vim.api.nvim_set_hl, 0, g, spec)
            end
            ::continue::
        end
        vim.api.nvim_set_hl(0, 'LspSignatureActiveParameter', {
            fg = '#C586C0',
            bold = true,
        })

        vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelpActiveParameter', {
            link = 'LspSignatureActiveParameter',
        })
        vim.api.nvim_set_hl(0, 'CursorColumn', { bg = '#202537' })
        -- colors
        -- gray
        vim.api.nvim_set_hl(0, 'CmpItemAbbrDeprecated', { bg='NONE', strikethrough=true, fg='#808080' })
        -- blue
        vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { bg='NONE', fg='#569CD6' })
        vim.api.nvim_set_hl(0, 'CmpItemAbbrMatchFuzzy', { link='CmpItemAbbrMatch' })
        -- light blue
        vim.api.nvim_set_hl(0, 'CmpItemKindVariable', { bg='NONE', fg='#9CDCFE' })
        vim.api.nvim_set_hl(0, 'CmpItemKindInterface', { link='CmpItemKindVariable' })
        vim.api.nvim_set_hl(0, 'CmpItemKindText', { link='CmpItemKindVariable' })
        -- pink
        vim.api.nvim_set_hl(0, 'CmpItemKindFunction', { bg='NONE', fg='#C586C0' })
        vim.api.nvim_set_hl(0, 'CmpItemKindMethod', { link='CmpItemKindFunction' })
        -- front
        vim.api.nvim_set_hl(0, 'CmpItemKindKeyword', { bg='NONE', fg='#D4D4D4' })
        vim.api.nvim_set_hl(0, 'CmpItemKindProperty', { link='CmpItemKindKeyword' })
        vim.api.nvim_set_hl(0, 'CmpItemKindUnit', { link='CmpItemKindKeyword' })
        -- floats
        vim.api.nvim_set_hl(0, "NormalFloat", { fg = "none", bg = "none" })
        -- vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "#202537" })
        -- vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "#202537" })
        vim.api.nvim_set_hl(0, "TreesitterContextSeparator", { fg = "#444444" })
        vim.api.nvim_set_hl(0, "NonText", { fg = "#50556C" })
        vim.api.nvim_set_hl(0, "SatelliteSearchCurrent", { fg = "#FFDD8D" })
        vim.api.nvim_set_hl(0, "SatelliteSearch", { fg = "#FEBBE5" })
        vim.api.nvim_set_hl(0, "FloatBorder", { bg = "NONE", fg = vim.api.nvim_get_hl_by_name("Normal", true).foreground })

        vim.api.nvim_set_hl(0, 'BlinkCmpLabelDeprecated', { link = 'CmpItemAbbrDeprecated', }) 
        vim.api.nvim_set_hl(0, 'BlinkCmpLabelMatch', { link = 'CmpItemAbbrMatch', }) 
        vim.api.nvim_set_hl(0, 'BlinkCmpKindVariable', { link = 'CmpItemKindVariable', }) 
        vim.api.nvim_set_hl(0, 'BlinkCmpKindInterface', { link = 'CmpItemKindVariable', })
        vim.api.nvim_set_hl(0, 'BlinkCmpKindText', { link = 'CmpItemKindVariable', }) -- Pink
        vim.api.nvim_set_hl(0, 'BlinkCmpKindFunction', { link = 'CmpItemKindFunction', })
        vim.api.nvim_set_hl(0, 'BlinkCmpKindMethod', { link = 'CmpItemKindFunction', }) -- Foreground/default
        vim.api.nvim_set_hl(0, 'BlinkCmpKindKeyword', { link = 'CmpItemKindKeyword', })
        vim.api.nvim_set_hl(0, 'BlinkCmpKindProperty', { link = 'CmpItemKindKeyword', })
        vim.api.nvim_set_hl(0, 'BlinkCmpKindUnit', { link = 'CmpItemKindKeyword', }) -- Blink popup itself
        vim.api.nvim_set_hl(0, 'BlinkCmpMenu', { bg = 'NONE', })
        vim.api.nvim_set_hl(0, 'BlinkCmpMenuBorder', { link = 'FloatBorder', })
        vim.api.nvim_set_hl(0, 'BlinkCmpDoc', { bg = 'NONE', })
        vim.api.nvim_set_hl(0, 'BlinkCmpDocBorder', { link = 'FloatBorder', })
        vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelp', { bg = 'NONE', })
        vim.api.nvim_set_hl(0, 'BlinkCmpSignatureHelpBorder', { link = 'FloatBorder', })



        -- The two canonical float groups:
        pcall(vim.api.nvim_set_hl, 0, "NormalFloat", { bg = "NONE" })
        pcall(vim.api.nvim_set_hl, 0, "FloatBorder", { bg = "NONE", fg = border_fg })
    end
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = "php",
    callback = function()
        vim.schedule(function()
            vim.opt_local.autoindent = true
        end)
    end,
})
