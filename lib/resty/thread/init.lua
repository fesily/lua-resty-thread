local factory = require "resty.thread.factory"
local upvalues = require "resty.thread.upvalues"
local _VERSION = "0.3.0"

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

function _M.run_with_upvalues(threadpool, fn, arg1, ...)
    if type(fn) ~= "function" then
        return false, "fn is not a function"
    end
    return factory.create_with_upvalues(threadpool, fn, arg1, ...)
end

_M.run_worker_thread = ngx.run_worker_thread

local function check_result(ok, err, ...)
    if not ok then
        error(err, 3)
    end
    return err, ...
end

_M.check_error = {}

function _M.check_error.run(threadpool, fn, arg1, ...)
    return check_result(_M.run(threadpool, fn, arg1, ...))
end

function _M.check_error.run_with_upvalues(threadpool, fn, arg1, ...)
    return check_result(_M.run_with_upvalues(threadpool, fn, arg1, ...))
end

function _M.check_error.run_worker_thread(threadpool, fn, arg1, ...)
    return check_result(_M.run_worker_thread(threadpool, fn, arg1, ...))
end

function _M.set_upvalues_maxlimit(n)
    upvalues.maxlimit = n
end

return _M
