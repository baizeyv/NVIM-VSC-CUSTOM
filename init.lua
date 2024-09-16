-- 保存原来的 vim.notify
local original_notify = vim.notify

-- 重写 vim.notify 函数
vim.notify = function(msg, log_level, opts)
    -- 使用 VS Code 通知
    local vscode_notify = require("vscode").notify

    -- 通过 VS Code 进行通知
    vscode_notify(msg)

    -- 调用原来的 vim.notify
    original_notify(msg, log_level, opts)
end

vim.keymap.set("","<Space>","<Nop>")
require("config.plugin-loader")