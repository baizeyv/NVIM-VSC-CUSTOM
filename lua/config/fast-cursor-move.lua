local M = {}
local vscode = require("vscode")

local fn = vim.fn
local api = vim.api

local ACCELERATION_LIMIT = 300
local ACCELERATION_TABLE_VERTICAL = {5, 10, 15, 20, 25, 30, 40}
-- local ACCELERATION_TABLE_VERTICAL = {7, 14, 20, 26, 31, 36, 40}
local ACCELERATION_TABLE_HORIZONTAL = {5, 10, 20}
-- local ACCELERATION_TABLE_HORIZONTAL = {10, 15, 20}

local get_move_step = (function()
    -- # 上一次移动的方向
    local prev_direction
    local prev_time = 0
    local move_count = 0
    return function(direction)
        if direction ~= prev_direction then
            prev_time = 0
            move_count = 0
            prev_direction = direction
        else
            local time = vim.loop.hrtime()
            local elapsed = (time - prev_time) / 1e6
            if elapsed > ACCELERATION_LIMIT then
                move_count = 0
            else
                move_count = move_count + 1
            end
            prev_time = time
        end
        local acceleration_table =
            ((direction == "down" or direction == "up") and
                ACCELERATION_TABLE_VERTICAL or ACCELERATION_TABLE_HORIZONTAL)
        -- # calc step
        for idx, count in ipairs(acceleration_table) do
            if move_count < count then return idx end
        end
        return #acceleration_table
    end
end)()

---@param direction "left"|"right"|"up"|"down"
---@return "h"|"gj"|"gk"|"l"
local function get_move_chars(direction)
    if direction == "down" then
        return "gj"
    elseif direction == "up" then
        return "gk"
    elseif direction == "left" then
        return "h"
    else
        return "l"
    end
end

local function move(direction, cnt)
    local move_chars = get_move_chars(direction)
    if fn.reg_recording() ~= "" or fn.reg_executing() ~= "" then
        return move_chars
    end

    local is_normal = api.nvim_get_mode().mode:lower() == "n"
    local use_vscode = vim.g.vscode and is_normal and direction ~= "left" and
                           direction ~= "right"

    if vim.v.count > 0 then return move_chars end

    local step = get_move_step(direction)
    return (cnt * step) .. move_chars
end

M.setup = function()
    vim.keymap.set({"n", "x", "o"}, "e", function() return move("down", 1) end,
                   {
        expr = true,
        silent = true,
        desc = "Move Down",
        remap = true
    })
    vim.keymap.set({"n", "x", "o"}, "u", function() return move("up", 1) end,
                   {expr = true, silent = true, desc = "Move Up", remap = true})
    vim.keymap.set({"n", "o"}, "E", function() return move("down", 5) end, {
        expr = true,
        silent = true,
        desc = "Move Down",
        remap = true
    })
    vim.keymap.set({"n", "o"}, "U", function() return move("up", 5) end,
                   {expr = true, silent = true, desc = "Move Up", remap = true})
    vim.keymap.set({"x"}, "E", function() return move("down", 5) end,
                   {expr = true, silent = true, desc = "Move Down"})
    vim.keymap.set({"x"}, "U", function() return move("up", 5) end,
                   {expr = true, silent = true, desc = "Move Up"})
    vim.keymap.set({"n", "x"}, "i", function() return move("right", 1) end,
                   {expr = true, silent = true, desc = "Move Right"})
    vim.keymap.set({"n", "x", "o"}, "n", function() return move("left", 1) end,
                   {expr = true, silent = true, desc = "Move Left"})
end

return M

