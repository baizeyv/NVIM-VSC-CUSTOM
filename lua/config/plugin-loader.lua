local key = {
  home = { "H" },
  install = { "T", "t" },
  update = { "A", "a" },
  sync = { "S" },
  clean = { "X", "x" },
  check = { "C", "c" },
  log = { "L", "l" },
  restore = { "R", "r" },
  profile = { "P" },
  debug = { "D" },
  help = { "?" },
  build = { "nil", "gb" },
}

local function load_lazy_keymap()
  local command = require("lazy.view.config").commands
  for key, value in pairs(key) do
    for idx, k in ipairs(value) do
      if idx == 1 and k ~= "nil" then
        command[key].key = k
      elseif idx == 2 then
        command[key].key_plugin = k
      end
    end
  end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local group = vim.api.nvim_create_augroup("LazyVim", {clear=true})
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "VeryLazy",
  callback=function ()
    
require("config.autocmds")
require("config.keymaps")
  end
})

require("config.options")

load_lazy_keymap()

require("lazy").setup({
  spec = {
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "catppuccin", "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
