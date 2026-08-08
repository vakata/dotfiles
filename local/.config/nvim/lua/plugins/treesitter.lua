-- return {}
return {
    {
       'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',

        config = function()
            require('nvim-treesitter').setup {}

            require('nvim-treesitter').install {
                'lua',
                'vim',
                'vimdoc',
                'markdown',
                'markdown_inline',
                'bash',
                'c',
                'javascript',
                'css',
                'diff',
                'php',
                'phpdoc',
                'html',
                'luadoc', 
                'query',
            }
        end,
    },
    -- {
    --     'nvim-treesitter/nvim-treesitter',
    --     build = ':TSUpdate',
    --     main = 'nvim-treesitter.configs',
    --     opts = {
    --         ensure_installed = { 'bash', 'c', 'javascript', 'css', 'diff', 'php', 'phpdoc', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
    --         auto_install = true,
    --         highlight = {
    --             enable = true,
    --             additional_vim_regex_highlighting = { 'ruby' },
    --         },
    --         indent = { enable = true, disable = { 'ruby' } },
    --     },
    -- },
    {
        'nvim-treesitter/nvim-treesitter-context',
        opts = {
            separator = '·',
            multiline_threshold = 1,
            mode = 'topline',
            trim_scope = 'outer',
            max_lines = 4,
            zindex = 1
        }
    }
}
