return {
    -- Main parser management plugin (nvim 0.12 rewrite — incompatible with old API)
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,  -- plugin explicitly does not support lazy-loading
        build = ":TSUpdate",
        config = function()
            -- The new API only exposes install_dir; highlight/indent are now built-in
            require("nvim-treesitter").setup({})

            -- Pre-install parsers for common languages on first run.
            -- Requires tree-sitter-cli (pacman -S tree-sitter) and a C compiler.
            require("nvim-treesitter").install({
                "bash", "c", "css", "go", "html", "javascript",
                "json", "lua", "markdown", "markdown_inline",
                "python", "rust", "toml", "typescript", "vim",
                "vimdoc", "yaml",
            })

            -- Enable built-in treesitter highlighting and indentation
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    local ok = pcall(vim.treesitter.start)
                    if not ok then
                        -- Parser not installed yet; fall back to regex highlighting
                    end
                end,
            })
        end,
    },

    -- Syntax-aware text objects (select, move) — uses updated API for nvim 0.12
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        lazy = false,
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = {
                    lookahead = true,
                    selection_modes = {
                        ["@function.outer"] = "V",
                        ["@class.outer"] = "V",
                    },
                },
                move = {
                    set_jumps = true,
                },
            })

            local to_select = require("nvim-treesitter-textobjects.select")
            local to_move = require("nvim-treesitter-textobjects.move")
            local map = vim.keymap.set

            -- Text object selections (operator-pending and visual)
            map({ "x", "o" }, "af", function()
                to_select.select_textobject("@function.outer", "textobjects")
            end, { desc = "Select outer function" })
            map({ "x", "o" }, "if", function()
                to_select.select_textobject("@function.inner", "textobjects")
            end, { desc = "Select inner function" })
            map({ "x", "o" }, "ac", function()
                to_select.select_textobject("@class.outer", "textobjects")
            end, { desc = "Select outer class" })
            map({ "x", "o" }, "ic", function()
                to_select.select_textobject("@class.inner", "textobjects")
            end, { desc = "Select inner class" })
            map({ "x", "o" }, "aa", function()
                to_select.select_textobject("@parameter.outer", "textobjects")
            end, { desc = "Select outer parameter" })
            map({ "x", "o" }, "ia", function()
                to_select.select_textobject("@parameter.inner", "textobjects")
            end, { desc = "Select inner parameter" })

            -- Navigation (normal, visual, operator-pending)
            map({ "n", "x", "o" }, "]f", function()
                to_move.goto_next_start("@function.outer", "textobjects")
            end, { desc = "Next function start" })
            map({ "n", "x", "o" }, "[f", function()
                to_move.goto_previous_start("@function.outer", "textobjects")
            end, { desc = "Previous function start" })
            map({ "n", "x", "o" }, "]c", function()
                to_move.goto_next_start("@class.outer", "textobjects")
            end, { desc = "Next class start" })
            map({ "n", "x", "o" }, "[c", function()
                to_move.goto_previous_start("@class.outer", "textobjects")
            end, { desc = "Previous class start" })
        end,
    },
}
