return {
    -- LSP package manager
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = { ui = { border = "rounded" } },
    },

    -- Bridges mason and lspconfig
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            -- lua_ls is auto-installed so nvim config editing works out of the box.
            -- Add more entries here or run :MasonInstall <server> manually.
            ensure_installed = { "lua_ls" },
        },
    },

    -- LSP configuration
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local on_attach = function(_, bufnr)
                local map = function(keys, func, desc)
                    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
                end

                map("gd", vim.lsp.buf.definition, "Go to definition")
                map("gD", vim.lsp.buf.declaration, "Go to declaration")
                map("gr", vim.lsp.buf.references, "Go to references")
                map("gi", vim.lsp.buf.implementation, "Go to implementation")
                map("K", vim.lsp.buf.hover, "Hover documentation")
                map("<C-k>", vim.lsp.buf.signature_help, "Signature help")
                map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
                map("<leader>ca", vim.lsp.buf.code_action, "Code action")
                map("<leader>f", function()
                    vim.lsp.buf.format({ async = true })
                end, "Format buffer")
            end

            local default_setup = function(server_name)
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                    on_attach = on_attach,
                })
            end

            require("mason-lspconfig").setup({
                handlers = {
                    default_setup,
                    -- Silence the "vim is undefined global" warning in neovim config files
                    lua_ls = function()
                        lspconfig.lua_ls.setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                            settings = {
                                Lua = {
                                    diagnostics = { globals = { "vim" } },
                                    workspace = { checkThirdParty = false },
                                    telemetry = { enable = false },
                                },
                            },
                        })
                    end,
                },
            })

            vim.diagnostic.config({
                virtual_text = { prefix = "●" },
                signs = true,
                update_in_insert = false,
                float = { border = "rounded", source = "always" },
                severity_sort = true,
            })
        end,
    },
}
