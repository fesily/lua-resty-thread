local upvalues = require "resty.thread.upvalues"
local _M = {}

function _M:run(fn, arg1, ...)
    return fn(arg1, ...)
end

function _M:run_with_upvalues(fn, arg1, ...)
    return fn(arg1, ...)
end

function _M:run_worker_thread(fn, arg1, ...)
    return fn(arg1, ...)
end

function _M.set_upvalues_maxlimit(n)
    return upvalues.set_upvalues_maxlimit(n)
end

function _M.new(tablepool_name)
    return setmetatable({ threadpool_name = tablepool_name }, { __index = _M })
end

return _M
