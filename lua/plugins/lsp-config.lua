return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "ts_ls", "jdtls", "tailwindcss", "kotlin_language_server", "gopls" },
            })
        end
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = { "java-debug-adapter", "java-test", "delve" }
            })
        end
    },
    {
        "jay-babu/mason-null-ls.nvim",
        config = function()
            require("mason-null-ls").setup({
                ensure_installed = { "gofumpt", "golangci-lint" },
            })
        end
    },
    {
        "mfussenegger/nvim-jdtls",
        dependencies = {
            "mfussenegger/nvim-dap",
        }
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")

            -- Lua language server setup
            lspconfig.lua_ls.setup({})

            -- TypeScript language server setup
            lspconfig.ts_ls.setup({})

            -- Tailwind CSS language server setup
            lspconfig.tailwindcss.setup({
                settings = {
                    tailwindCSS = {
                        experimental = {
                            classRegex = {
                                { "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                                { "classnames\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                            }
                        }
                    }
                }
            })

            -- Pylsp setup for Python
            lspconfig.pylsp.setup({
                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = {
                                enabled = true,
                                maxLineLength = 100,
                            },
                            pyflakes = { enabled = true },
                            pylint = { enabled = false },
                            jedi_completion = { enabled = true },
                        }
                    }
                }
            })

            -- gopls (Go Please) setup
            lspconfig.gopls.setup({
                settings = {
                    gopls = {
                        usePlaceholders = true,
                        completeUnimported = true,
                        staticcheck = true,
                        analyses = {
                            unusedparams = true,
                            unreachable = true,
                        },
                    },
                },
            })

            --kotlin_language_server setup 
            lspconfig.kotlin_language_server.setup({
                cmd = { "kotlin-language-server" },
                root_dir = function(fname)
                    local project_root = lspconfig.util.root_pattern(
                        "settings.gradle",
                        "settings.gradle.kts",
                        "build.gradle",
                        "build.gradle.kts",
                        ".git"
                    )(fname)

                    if not project_root then
                        return vim.fn.fnamemodify(fname, ':h')
                    end

                    return project_root
                end,
                init_options = {
                    storagePath = vim.fn.expand("~/.cache/kotlin-language-server"),
                    clientInfo = {
                        name = "nvim",
                        version = "0.9.0"
                    }
                },
                settings = {
                    kotlin = {
                        compiler = {
                            jvm = {
                                target = "17"
                            }
                        },
                        checkBuildScripts = false,
                        completion = {
                            snippets = {
                                enabled = true
                            }
                        },
                        debugAdapter = {
                            enabled = true
                        },
                        traces = {
                            server = "verbose"
                        }
                    }
                }
            })

            -- HTML language server setup (for Intellisense)
            lspconfig.html.setup({
                filetypes = { "html","htmldjango","php","ejs"},
                settings={
                    html={
                        suggest={
                            html5 = true, --Enable HTML5 Intellisense
                            angular1 = true,
                            angular2 = true,
                        }
                    }
                }
            })

            -- Set keybindings for LSP features
            vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { desc = "[C]ode [H]over Documentation" })
            vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "[C]ode Goto [D]efinition" })
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions" })
            vim.keymap.set("n", "<leader>cr", require("telescope.builtin").lsp_references, { desc = "[C]ode Goto [R]eferences" })
            vim.keymap.set("n", "<leader>ci", require("telescope.builtin").lsp_implementations, { desc = "[C]ode Goto [I]mplementations" })
            vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, { desc = "[C]ode [R]ename" })
            vim.keymap.set("n", "<leader>cD", vim.lsp.buf.declaration, { desc = "[C]ode Goto [D]eclaration" })
            ------------------------------------------------------------------------------------------------------
            -- Show diagnostics in a floating window
            vim.keymap.set("n", "<leader>cds", vim.diagnostic.open_float, { desc = "[C]ode [D]iagnostic [S]how" })

            -- Go to next diagnostic
            vim.keymap.set("n", "<leader>cdn", vim.diagnostic.goto_next, { desc = "[C]ode [D]iagnostic [N]ext" })

            -- Go to previous diagnostic
            vim.keymap.set("n", "<leader>cdp", vim.diagnostic.goto_prev, { desc = "[C]ode [D]iagnostic [P]revious" })

            -- Set location list with all diagnostics
            vim.keymap.set("n", "<leader>cdl", vim.diagnostic.setloclist, { desc = "[C]ode [D]iagnostic [L]ist" })
        end
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.gofumpt,
                    null_ls.builtins.diagnostics.golangci_lint,
                }
            })
        end
    }
}
