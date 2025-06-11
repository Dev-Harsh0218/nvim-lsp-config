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
                ensure_installed = { "lua_ls", "ts_ls", "jdtls", "tailwindcss","kotlin_language_server","pylsp","pyright"},
            })
        end
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        config = function()
            require("mason-nvim-dap").setup({
                ensure_installed = { "java-debug-adapter", "java-test" }
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
            local util = require("lspconfig/util")

            -- Lua language server setup
            lspconfig.lua_ls.setup({
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })

            -- TypeScript language server setup
            lspconfig.ts_ls.setup({
                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            })

            -- Tailwind CSS language server setup
            lspconfig.tailwindcss.setup({
                settings = {
                    tailwindCSS = {
                        experimental = {
                            classRegex = {
                                -- Add any custom regex for Tailwind class detection
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
                            pyflakes = {
                                enabled = true,
                                maxLineLength = 100
                            },
                            pylint = { enabled = false },
                            --jedi_completion = {
                                --    enabled = true,
                                --    include_params = true
                                --},
                                jedi_completion = {
                                    enabled = true,
                                    include_params = true,
                                    fuzzy = true,
                                },
                                jedi_signature_help = {
                                    enabled = true,
                                },
                                jedi_hover = {
                                    enabled = true,
                                },
                            }
                        }
                    }
                })
                --
                -- Pyright setup for advanced type checking

                lspconfig.pyright.setup({
                    capabilities = require("cmp_nvim_lsp").default_capabilities(),
                    settings = {
                        python = {
                            analysis = {
                                typeCheckingMode = "basic",
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                            },
                        },
                    },
                    on_init = function(client, _)
                        local root_dir = util.root_pattern("pyrightconfig.json", ".git")(vim.fn.getcwd()) or vim.fn.getcwd()

                        local venvs = {
                            root_dir .. "/.venv/bin/python",
                            root_dir .. "/venv/bin/python",
                            root_dir .. "/env/bin/python",
                        }

                        local python_path = nil
                        for _, path in ipairs(venvs) do
                            if vim.fn.filereadable(path) == 1 then
                                python_path = path
                                break
                            end
                        end

                        python_path = python_path or vim.fn.exepath("python3") or vim.fn.exepath("python")

                        client.config.settings.python.pythonPath = python_path
                        client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                    end,
                    root_dir = util.root_pattern("pyrightconfig.json", ".git"),
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


                -- Set vim motion for <Space> + c + h to show code documentation about the code the cursor is currently over if available
                vim.keymap.set("n", "<leader>ch", vim.lsp.buf.hover, { desc = "[C]ode [H]over Documentation" })
                -- Set vim motion for <Space> + c + d to go where the code/variable under the cursor was defined
                vim.keymap.set("n", "<leader>cd", vim.lsp.buf.definition, { desc = "[C]ode Goto [D]efinition" })
                -- Set vim motion for <Space> + c + a for display code action suggestions for code diagnostics in both normal and visual mode
                vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "[C]ode [A]ctions" })
                -- Set vim motion for <Space> + c + r to display references to the code under the cursor
                vim.keymap.set("n", "<leader>cr", require("telescope.builtin").lsp_references, { desc = "[C]ode Goto [R]eferences" })
                -- Set vim motion for <Space> + c + i to display implementations to the code under the cursor
                vim.keymap.set("n", "<leader>ci", require("telescope.builtin").lsp_implementations, { desc = "[C]ode Goto [I]mplementations" })
                -- Set a vim motion for <Space> + c + <Shift>R to smartly rename the code under the cursor
                vim.keymap.set("n", "<leader>cR", vim.lsp.buf.rename, { desc = "[C]ode [R]ename" })
                -- Set a vim motion for <Space> + c + <Shift>D to go to where the code/object was declared in the project (class file)
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
                -- Keymap to manually trigger signature help
                vim.keymap.set("n", "<leader>cs", vim.lsp.buf.signature_help, { desc = "Show Signature Help" })

                -- Optional: automatically show signature help while typing
                vim.cmd [[
                autocmd CursorHoldI * lua vim.lsp.buf.signature_help()
                ]]
            end
        }
    }
