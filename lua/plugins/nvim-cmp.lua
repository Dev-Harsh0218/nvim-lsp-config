return{
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",  -- LSP source for nvim-cmp
            "hrsh7th/cmp-buffer",    -- Buffer source for nvim-cmp
            "hrsh7th/cmp-path",      -- Path source for nvim-cmp
            "saadparwaiz1/cmp_luasnip", -- LuaSnip source for nvim-cmp
            "L3MON4D3/LuaSnip",       -- Snippet engine
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)  -- For expanding LuaSnip snippets
                    end,
                },
                mapping = {
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                },
                sources = {
                    { name = 'nvim_lsp' },     -- LSP source
                    { name = 'buffer' },       -- Buffer source
                    { name = 'path' },         -- Path source
                    { name = 'luasnip' },      -- Snippets source
                },
            })

            -- Enable LSP completion capabilities in nvim-cmp
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            -- You can use this capabilities object when setting up your LSP servers (example: lspconfig)
        end
}
