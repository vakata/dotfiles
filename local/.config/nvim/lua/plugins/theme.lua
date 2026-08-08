return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        lazy = false,
        config = function ()
            require('catppuccin').setup({
                auto_integrations = true,
                transparent_background = true,
                flavour = 'macchiato',
                no_italic = true,
                integrations = {
                    dropbar = {
                        enabled = true,
                        color_mode = true
                    },
                    noice = true,
                    blink_cmp = {
                        style = 'bordered',
                    }
                },
                custom_highlights = function(colors)
                    return {
                        -- Matching text
                        BlinkCmpLabelMatch = {
                            fg = '#569CD6',
                            bold = true,
                        },

                        BlinkCmpLabelDeprecated = {
                            fg = '#808080',
                            strikethrough = true,
                        },

                        -- Light blue
                        BlinkCmpKindVariable = { fg = '#9CDCFE' },
                        BlinkCmpKindInterface = { fg = '#9CDCFE' },
                        BlinkCmpKindText = { fg = '#9CDCFE' },
                        BlinkCmpKindField = { fg = '#9CDCFE' },

                        -- Pink
                        BlinkCmpKindFunction = { fg = '#C586C0' },
                        BlinkCmpKindMethod = { fg = '#C586C0' },
                        BlinkCmpKindConstructor = { fg = '#C586C0' },

                        -- Normal foreground
                        BlinkCmpKindKeyword = { fg = '#D4D4D4' },
                        BlinkCmpKindProperty = { fg = '#D4D4D4' },
                        BlinkCmpKindUnit = { fg = '#D4D4D4' },

                        -- A few sensible Catppuccin colors for remaining kinds
                        BlinkCmpKindClass = { fg = colors.yellow },
                        BlinkCmpKindStruct = { fg = colors.yellow },
                        BlinkCmpKindModule = { fg = colors.yellow },

                        BlinkCmpKindEnum = { fg = colors.peach },
                        BlinkCmpKindEnumMember = { fg = colors.peach },
                        BlinkCmpKindConstant = { fg = colors.peach },

                        BlinkCmpKindSnippet = { fg = colors.mauve },
                        BlinkCmpKindFile = { fg = colors.green },
                        BlinkCmpKindFolder = { fg = colors.green },
                        BlinkCmpKindReference = { fg = colors.teal },

                        BlinkCmpKindValue = { fg = colors.peach },
                        BlinkCmpKindColor = { fg = colors.pink },
                        BlinkCmpKindEvent = { fg = colors.red },
                        BlinkCmpKindOperator = { fg = colors.sky },
                        BlinkCmpKindTypeParameter = { fg = colors.yellow },
                    }
                end
            });
            vim.cmd 'colorscheme catppuccin'
            vim.cmd 'hi TreesitterContextBottom gui=none'
            vim.cmd 'hi TreesitterContextLineNumberBottom gui=none'
            vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { bg = "NONE" })
            vim.api.nvim_set_hl(0, "TreesitterContextLineNumberBottom", { bg = "NONE" })
            vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'NONE' })
            vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'NONE' })
            -- vim.g.lightline = {
            --     colorscheme = 'catppuccin',
            --     active = {
            --         left = { { 'mode', 'paste' }, { 'readonly', 'filename', 'modified' }, { 'input' } },
            --         right = {
            --             { 'lineinfo' },
            --             { 'percent' },
            --             { 'charvaluehex', 'fileformat', 'fileencoding', 'filetype' },
            --         },
            --     },
            --     tabline = {
            --         left = { { 'buffers' } },
            --         right = { },
            --     },
            --     component = {
            --         charvaluehex = '0x%B',
            --         input = '%k',
            --     },
            --     component_expand = {
            --         buffers = 'lightline#bufferline#buffers',
            --     },
            --     component_raw = { buffers = 1 },
            --     component_type = {
            --         buffers = 'tabsel',
            --     },
            -- }
        end
    },
    -- { 'itchyny/lightline.vim' },
    -- { 'mengelbrecht/lightline-bufferline' },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {
            options = {
                theme = "auto",
                icons_enabled = true,
                section_separators = { left = '', right = '' },
                component_separators = '',
                disabled_filetypes = {
                    statusline = {},
                    winbar = { 'NvimTree' },
                },
                always_divide_middle = true,
                globalstatus = true,
            },
            sections = {
                lualine_a = {
                    { 'mode', separator = { left = '' } }
                },
                lualine_b = {
                    { 'filename',
                        symbols = {
                            modified = '●',
                            readonly = '󰌾',
                            unnamed = '[No Name]',
                            newfile = '[New]',
                        }
                    },
                    'diagnostics'
                },
                lualine_c = {
                },
                lualine_x = {
                    'lsp_status'
                },
                lualine_y = {
                    'searchcount',
                    {'filetype', colored = false},
                    { 'encoding', show_bomb = true },
                    function ()
                        return vim.bo.fileformat;
                    end
                },
                lualine_z = {
                    function ()
                        local char = vim.fn.getline('.'):sub(vim.fn.col('.'), vim.fn.col('.'))
                        if char == '' then
                            return ''
                        end
                        return string.format('U+%04X', char:byte())
                    end,
                    'progress',
                    { 'location', separator = { right = '' }, },
                },
            },
            inactive_sections = {
            },
            tabline = {
                lualine_a = {
                    {
                        'buffers',
                        max_length = vim.o.columns,
                        use_mode_colors = true,
                        buffers_color = {
                            inactive = 'lualine_b_inactive'
                        },
                        padding = 2,
                        symbols = {
                            modified = ' ●',
                            readonly = ' 󰌾',
                            alternate_file = '',
                        }
                    },
                },
            },
            winbar = {
            },
            inactive_winbar = {
            },
            extensions = {'toggleterm', 'oil'},
        }
    }
}
