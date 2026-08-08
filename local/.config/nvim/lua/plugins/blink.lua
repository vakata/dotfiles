return {
    'saghen/blink.cmp',
    event = 'InsertEnter',
    version = '1.*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = 'none',

            -- Accept only an explicitly selected item.
            -- Otherwise Enter inserts a newline.
            ['<CR>'] = {
                'accept',
                'fallback',
            },

            ['<Tab>'] = {
                'select_next',
                'fallback',
            },

            ['<S-Tab>'] = {
                'select_prev',
                'fallback',
            },

            -- First Esc closes completion; another Esc leaves Insert mode.
            ['<Esc>'] = {
                'hide',
                'fallback',
            },

            -- ['<C-Space>'] = { 'show' },

            ['<C-b>'] = {
                'scroll_documentation_up',
                'fallback',
            },

            ['<C-f>'] = {
                'scroll_documentation_down',
                'fallback',
            },
        },

        completion = {
            list = {
                selection = {
                    preselect = false,
                    auto_insert = false,
                },
            },

            menu = {
                border = 'rounded',

                draw = {
                    columns = {
                        { 'kind_icon' },
                        { 'label', 'label_description', gap = 1 },
                        { 'source_name' },
                    },
                },
            },

            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,

                window = {
                    border = 'rounded',
                },
            },
        },

        appearance = {
            nerd_font_variant = 'mono',

            kind_icons = {
                Text = '',
                Method = '',
                Function = '',
                Constructor = '',
                Field = '',
                Variable = '',
                Class = '',
                Interface = '',
                Module = '',
                Property = '',
                Unit = '',
                Value = '',
                Enum = '',
                Keyword = '',
                Snippet = '',
                Color = '',
                File = '',
                Reference = '',
                Folder = '',
                EnumMember = '',
                Constant = '',
                Struct = '',
                Event = '',
                Operator = '',
                TypeParameter = '',
            },
        },

        sources = {
            default = {
                'lazydev',
                'lsp',
                'path',
                'buffer',
            },

            providers = {
                lazydev = {
                    name = 'LazyDev',
                    module = 'lazydev.integrations.blink',
                    score_offset = 100,
                },

                lsp = {
                    name = 'LSP',
                },

                path = {
                    name = 'Path',
                },

                buffer = {
                    name = 'Buffer',
                },
            },
        },

        signature = {
            enabled = true,

            window = {
                border = 'rounded',
            },
        },

        fuzzy = {
            implementation = 'prefer_rust_with_warning',
        },
    },

    opts_extend = {
        'sources.default',
    },
}


