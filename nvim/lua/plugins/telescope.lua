return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
        { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
        { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
        { "<leader>fc", "<cmd>Telescope colorscheme<cr>", desc = "Colorschemes" },
        { "<leader>/",  "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy search buffer" },
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },
    config = function()
        local telescope = require("telescope")
        local actions = require("telescope.actions")

        telescope.setup({
            defaults = {
                prompt_prefix = " ",
                selection_caret = " ",
                path_display = { "truncate" },
                sorting_strategy = "ascending",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.55,
                    },
                },
                mappings = {
                    i = {
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                        ["<Esc>"] = actions.close,
                    },
                },
            },
        })

        telescope.load_extension("fzf")
    end,
}
