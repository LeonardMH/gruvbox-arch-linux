local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation (4-space default, overridden per filetype via treesitter/editorconfig)
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.cursorline = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.colorcolumn = "100"

-- Splits open in a natural reading direction
opt.splitright = true
opt.splitbelow = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- Performance / responsiveness
opt.updatetime = 250
opt.timeoutlen = 300

-- Persistent undo, no swap/backup clutter
opt.undofile = true
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.swapfile = false
opt.backup = false

-- Use system clipboard
opt.clipboard = "unnamedplus"

-- Completion menu behaviour
opt.completeopt = { "menu", "menuone", "noselect" }

-- Show invisible characters that matter
opt.list = true
opt.listchars = { tab = "→ ", trail = "·", nbsp = "␣" }
