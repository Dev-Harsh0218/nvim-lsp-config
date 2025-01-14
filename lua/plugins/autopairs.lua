return {
    "windwp/nvim-autopairs",
    dependencies = {
        -- Ensure autopairs works with treesitter
        "nvim-treesitter/nvim-treesitter"
    },
    config = function()
        -- Gain access to nvim-autopairs setup function
        local npairs = require("nvim-autopairs")

        -- Setup nvim-autopairs with desired configurations
        npairs.setup({
            check_ts = true,  -- Enable Treesitter support
            ts_config = {
                lua = {'string', 'source'},  -- Add specific languages for autopairing
                javascript = {'template_string'},
                typescript = {'template_string'},
            },
            disable_filetype = { "TelescopePrompt", "vim" },  -- Disable in certain filetypes
            map_cr = true,  -- Automatically complete when pressing Enter
            map_bs = false,  -- Automatically remove pairs on backspace
        })
    end
}

