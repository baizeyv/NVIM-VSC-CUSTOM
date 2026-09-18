-- set custom notify
local native_notify = vim.notify
vim.notify = function(msg, log_level, opts)
    -- use vsc notify
    if (vim.g.vscode) then
        local vsc_notify = require("vscode").notify
        vsc_notify(msg)
    else
        native_notify(msg, log_level, opts)
    end
end

require('config').setup()
require('config.plugin-loader').load()
