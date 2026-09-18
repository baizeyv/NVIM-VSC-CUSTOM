if vim.fn.has("nvim-0.10.0") == 0 then
    vim.api.nvim_echo({
        { "Oops! This configuration requires Neovim >= 0.10.0\n", "ErrorMsg" },
        { "Press any key to exit", "ErrorMsg" }
    }, true, {})
    vim.fn.getchar()
    vim.cmd([[quit]])
    return {}
end

require('config').init()

return {
    { "folke/lazy.nvim", version = "*" }
}