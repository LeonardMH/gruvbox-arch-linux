return {
    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {
            options = {
                theme = "gruvbox",
                -- Powerline-style separators; requires a Nerd Font (JetBrains Mono is configured)
                section_separators = { left = "", right = "" },
                component_separators = { left = "", right = "" },
                globalstatus = true,
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        },
    },

    -- Git hunk decorations in the sign column
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            signs = {
                add = { text = "▎" },
                change = { text = "▎" },
                delete = { text = "" },
                topdelete = { text = "" },
                changedelete = { text = "▎" },
            },
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local map = function(mode, keys, func, desc)
                    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = desc })
                end

                map("n", "]h", gs.next_hunk, "Next hunk")
                map("n", "[h", gs.prev_hunk, "Previous hunk")
                map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
                map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
                map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
                map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
                map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
                map("n", "<leader>hb", function()
                    gs.blame_line({ full = true })
                end, "Blame line")
                map("n", "<leader>hd", gs.diffthis, "Diff this")
            end,
        },
    },

    -- Shows pending keybindings in a popup after <leader>
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            delay = 500,
            icons = { mappings = true },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            -- Register group labels so the popup is organised
            wk.add({
                { "<leader>f", group = "find (telescope)" },
                { "<leader>h", group = "git hunks" },
                { "<leader>t", group = "terminal" },
                { "<leader>b", group = "buffer" },
            })
        end,
    },

    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        main = "ibl",
        opts = {
            indent = { char = "│" },
            scope = { enabled = true, show_start = true },
            exclude = {
                filetypes = { "help", "dashboard", "lazy", "mason", "oil" },
            },
        },
    },

    -- File explorer: treats directories as editable buffers (vim-native)
    {
        "stevearc/oil.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        keys = {
            { "-", "<cmd>Oil<cr>", desc = "Open file explorer" },
        },
        opts = {
            default_file_explorer = true,
            columns = { "icon", "permissions", "size", "mtime" },
            view_options = { show_hidden = false },
            float = {
                padding = 2,
                border = "rounded",
            },
            keymaps = {
                -- Use <BS> to go up a directory (consistent with file manager muscle memory)
                ["<BS>"] = "actions.parent",
            },
        },
    },
}
