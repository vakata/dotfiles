-- fold indicators and status before line numbers
return {
    {
        "luukvbaal/statuscol.nvim",
        opts = function()
            local builtin = require('statuscol.builtin')
            return {
                setopt = true,
                relculright = true,
                segments = {
                    { text = { '%s' }, click = 'v:lua.ScSa' },
                    { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
                    { text = { " " } },
                    {
                        text = { builtin.lnumfunc, ' ' },
                        condition = { true, builtin.not_empty },
                        click = 'v:lua.ScLa',
                    },
                },
            }
        end,
    }
}
