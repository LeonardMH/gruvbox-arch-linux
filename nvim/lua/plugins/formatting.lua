return {
    -- Formatter: runs tool-based formatters (not LSP) on save
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        keys = {
            {
                "<leader>f",
                function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                end,
                desc = "Format buffer",
            },
        },
        opts = {
            -- Falls back to LSP formatting when no formatter is configured for the filetype
            default_format_opts = { lsp_format = "fallback" },
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "ruff_format" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                html = { "prettier" },
                css = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                bash = { "shfmt" },
                sh = { "shfmt" },
                go = { "goimports", "gofmt" },
                rust = { "rustfmt" },
                c = { "clang_format" },
                cpp = { "clang_format" },
                toml = { "taplo" },
            },
        },
    },

    -- Linter: async linting independent of LSP
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPost", "BufWritePost" },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                python = { "ruff" },
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                javascriptreact = { "eslint_d" },
                typescriptreact = { "eslint_d" },
                bash = { "shellcheck" },
                sh = { "shellcheck" },
                go = { "golangcilint" },
                lua = { "luacheck" },
            }

            vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
                callback = function()
                    -- Only lint if the linter is available; avoids noisy errors for
                    -- files whose linters aren't installed yet
                    local names = lint.linters_by_ft[vim.bo.filetype] or {}
                    local available = vim.tbl_filter(function(name)
                        local ok = pcall(require, "lint.linters." .. name)
                        if not ok then return false end
                        local linter = lint.linters[name]
                        local cmd = type(linter.cmd) == "function" and linter.cmd() or linter.cmd
                        return type(cmd) == "string" and vim.fn.executable(cmd) == 1
                    end, names)
                    if #available > 0 then
                        lint.try_lint()
                    end
                end,
            })
        end,
    },
}
