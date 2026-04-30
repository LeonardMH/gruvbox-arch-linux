return {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,  -- load before all other plugins
    config = function()
        require("gruvbox").setup({
            -- "medium" contrast uses bg0=#282828, matching the system gruvbox palette
            contrast = "medium",
            transparent_mode = false,
            italic = {
                strings = true,
                emphasis = true,
                comments = true,
                operators = false,
                folds = true,
            },
            overrides = {
                -- Align sign column background with editor background
                SignColumn = { bg = "#282828" },
            },
        })
        vim.cmd("colorscheme gruvbox")
    end,
}
