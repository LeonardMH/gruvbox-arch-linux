return {
    -- Auto-close brackets, quotes, etc. (treesitter-aware)
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {
            check_ts = true,
            ts_config = {
                -- Don't auto-pair inside strings in these languages
                lua = { "string" },
                python = { "string" },
            },
        },
        config = function(_, opts)
            local autopairs = require("nvim-autopairs")
            autopairs.setup(opts)
            -- Wire autopairs into nvim-cmp so confirmed completions get paired too
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },

    -- Surround text objects: ys, cs, ds (ysiw", cs"', ds")
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        opts = {},
    },
}
