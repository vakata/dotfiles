return {
    {
        'lewis6991/satellite.nvim',
        config = function()
            require('satellite').setup({
                winblend = 0,
                winborder = none,
                handlers = {
                    marks = {
                        enable = false
                    }
                }
            })
        end
    }
}
