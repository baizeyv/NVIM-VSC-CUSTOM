local M = {}

local utils = require('utils')

M.did_init = false

M.setup = function()
    -- autocmds can be loaded lazily when not opening a file
    local lazy_autocmds = vim.fn.argc(-1) == 0
    if not lazy_autocmds then M.load("autocmds") end

    local group = vim.api.nvim_create_augroup("Meowody", {clear = true})
    vim.api.nvim_create_autocmd("User", {
        group = group,
        pattern = "VeryLazy",
        callback = function()
            if lazy_autocmds then M.load("autocmds") end
            M.load("keymaps")
            vim.api.nvim_exec_autocmds("User", {
                pattern = "LoadPlugins",
                modeline = false
            })
        end
    })
end

M.load = function(module)
    local function _load(mod)
        utils.try(function() require(mod) end, {msg = "Failed loading " .. mod})
    end
    _load("config." .. module)
    if vim.bo.filetype == "lazy" then
        -- we may have overwritten options of the Lazy ui, so reset this here
        vim.cmd([[do VimResized]])
    end
    local pattern = "Meowody." .. module:sub(1, 1):upper() .. module:sub(2)
    vim.api.nvim_exec_autocmds("User", {pattern = pattern, modeline = false})
end

M.init = function()
    if M.did_init then return end
    M.did_init = true
    M.load("options")
    if vim.g.vscode then M.load("plug") end
end

return M

