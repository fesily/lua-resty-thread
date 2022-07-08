local factory = require "resty.thread.factory"

local _VERSION = "0.1.0"

local _M = {}

function _M.run(threadpool, fn, arg1, ...)
    if type(fn) ~= "function" then
        return false, "fn is not a function"
    end
    local nups = debug.getinfo(fn, "u").nups
    if nups > 0 then
        return false, "fn must not have up values:" .. nups
    end
    return factory.create(threadpool, fn, arg1, ...)
end

_M.run_worker_thread = ngx.run_worker_thread

return _M
