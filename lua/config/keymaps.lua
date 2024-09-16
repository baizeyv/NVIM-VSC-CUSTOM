local map = function(modes, lhs, rhs, opts)
    if #modes > 0 then
        opts = opts or {}
        opts.silent = opts.silent ~= false
        vim.keymap.set(modes, lhs, rhs, opts)
    end
end

local keys = require("config.keys")

local map_specific = function(name)
    for lhs, cfg in pairs(keys[name]) do
        if lhs ~= cfg[1] then
            map(cfg[2], lhs, cfg[1], cfg[3])
        end
    end
end

map_specific("Generic")
map_specific("Other1")
map_specific("Other2")
map_specific("Extra")
map_specific("Tabs")
map_specific("LSP")
map_specific("CMP")
map_specific("Search")

vim.api.nvim_exec_autocmds("User", {
    pattern = "VSC_NVM_KEYMAP",
    modeline = false
})
