local M = {}

--- try catch function (on_error is the catch func)
---@param fn function
---@param opts string | {msg:string, on_error:fun(msg)}
M.try = function(fn, opts)
    opts = type(opts) == 'string' and {msg = opts} or opts or {}
    -- error message
    local msg = opts.msg;
    -- error handler
    local error_handler = function(err)
        msg = (msg and (msg .. "\n\n") or "") .. err .. M.pretty_trace()
        if opts.on_error then
            opts.on_error(msg)
        else
            vim.schedule(function() M.error(msg) end)
        end
        return err
    end

    local ok, result = xpcall(fn, error_handler)
    return ok and result or nil
end

---@param opts? { level?: number }
M.pretty_trace = function(opts)
    opts = opts or {}
    local trace = {}
    local level = opts.level or 2

    while true do
        local info = debug.getinfo(level, 'Sln')
        if not info then break end
        if info.what ~= "C" and rc.debug then -- is not `c` code
            local source = info.source:sub(2) -- info.source -> @example.lua
            source = vim.fn.fnamemodify(source, ":p:~:.")
            local line = "  - " .. source .. ":" .. info.currentline
            if info.name then
                line = line .. " _in_ **" .. info.name .. "**"
            end
            table.insert(trace, line)
        end
        level = level + 1
    end
    return
        #trace > 0 and ("\n\n# stacktrack:\n" .. table.concat(trace, "\n")) or
            ""
end

---NOTIFY
---@param msg string|string[]
---@param opts? {lang?:string, title?:string, level?:number, once?:boolean, stacktrack?:boolean, stacklevel?:number}
M.notify = function(msg, opts)
    if vim.in_fast_event() then
        return vim.schedule(function() M.notify(msg, opts) end)
    end

    opts = opts or {}
    if type(msg) == "table" then
        msg = table.concat(vim.tbl_filter(function(line)
            return line or false
        end, msg), "\n")
    end
    if opts.stacktrack then
        msg = msg .. M.pretty_trace({level = opts.stacklevel or 2})
    end
    if (vim.g.vscode) then
        local vsc = require("vscode")
        local vsc_notify = vsc.notify
        if opts.level == vim.log.levels.ERROR then
            vsc.eval([[
            vscode.window.showErrorMessage(args.message);
            ]], {args = {message = msg}})
        elseif opts.level == vim.log.levels.WARN then
            vsc.eval([[
                vscode.window.showWarningMessage(args.message);
                ]], {args = {message = msg}})
        else
            vsc_notify(msg)
        end
    else
        local n = opts.once and vim.notify_once or vim.notify
        local lang = opts.lang or "markdown"
        n(msg, opts.level or vim.log.levels.INFO, {
            on_open = function(win)
                vim.wo[win].conceallevel = 3
                vim.wo[win].concealcursor = ''
                vim.wo[win].spell = false
                local buf = vim.api.nvim_win_get_buf(win)
                vim.bo[buf].filetype = lang
                vim.bo[buf].syntax = lang
            end,
            title = opts.title or "Meowody"
        })
    end

end

---error notify
---@param msg string|string[]
---@param opts? {lang?:string, title?:string, level?:number, once?:boolean, stacktrack?:boolean, stacklevel?:number}
M.error = function(msg, opts)
    opts = opts or {}
    opts.level = vim.log.levels.ERROR
    M.notify(msg, opts)
end

---info notify
---@param msg string|string[]
---@param opts? {lang?:string, title?:string, level?:number, once?:boolean, stacktrack?:boolean, stacklevel?:number}
M.info = function(msg, opts)
    opts = opts or {}
    opts.level = vim.log.levels.INFO
    M.notify(msg, opts)
end

---warn notify
---@param msg string|string[]
---@param opts? {lang?:string, title?:string, level?:number, once?:boolean, stacktrack?:boolean, stacklevel?:number}
M.warn = function(msg, opts)
    opts = opts or {}
    opts.level = vim.log.levels.WARN
    M.notify(msg, opts)
end

return M
