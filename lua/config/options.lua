vim.keymap.set("","<space>","<nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.clipboard = vim.g.vscode_clipboard

local opt = vim.opt

opt.autowrite = true -- enable auto write
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 2 -- hide * markup for bold and italic, but not markers with substitutions
opt.confirm = true -- confirm to save chanegs before exiting modified buffer
opt.cursorline = true -- enable highlighting of the current line
opt.expandtab = false -- not use spaces instead of tabs
opt.foldlevel = 99
opt.ignorecase = true -- ignore case
opt.inccommand = "nosplit"
opt.jumpoptions = "view"
opt.laststatus = 3 -- global statusline
opt.linebreak = true -- wrap lines at convenient points
opt.list = true -- show some invisible characters (tabs ...)
opt.mouse = "a" -- enable mouse mode
opt.number = true -- print line number
opt.pumblend = 10 -- popup blend
opt.pumheight = 10 -- maximum number of entries in a popup
opt.relativenumber = true -- relative line numbers
opt.scrolloff = 5 -- lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- round indent
opt.shiftwidth = 2 -- size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- dont show mode since we have a statusline
opt.sidescrolloff = 10 -- columns of context
opt.signcolumn = "yes" --  always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- dont ignore case with capitals
opt.smartindent = true -- insert indents automatically
opt.spelllang = { "en", "zh" }
opt.spelloptions:append("noplainbuffer")
opt.splitbelow = true -- put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- put new windows right of current
opt.tabstop = 4 -- number of spaces tabs count for
opt.termguicolors = true -- true color support
opt.timeoutlen = 1000
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- save swap file and trigger CursorHold
opt.virtualedit = "block" -- allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- minimum window width
opt.wrap = true -- enable line wrap
opt.smoothscroll = true