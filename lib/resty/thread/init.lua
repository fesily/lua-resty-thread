local factory = require "resty.thread.factory"
local upvalues = require "resty.thread.upvalues"
local wrapper = require "resty.thread.wrapper"
local run_worker_thread = ngx.run_worker_thread
local _VERSION = "0.6.1"

local _M = {}

_M.support_thread = run_worker_thread ~= nil

local function check_result(ok, err, ...)
    if not ok then
        return false, err
    end
    return err, ...
end

function _M.run(threadpool, fn, arg1, ...)
    if type(fn) ~= "function" then
        return false, "fn is not a function"
    end
    local nups = debug.getinfo(fn, "u").nups
    if nups > 0 then
        return false, "fn must not have up values:" .. nups
    end
    return check_result(factory.create(threadpool, fn, arg1, ...))
end

function _M.run_with_upvalues(threadpool, fn, arg1, ...)
    if type(fn) ~= "function" then
        return false, "fn is not a function"
    end
    return check_result(factory.create_with_upvalues(threadpool, fn, arg1, ...))
end

function _M.run_worker_thread(threadpool, fn, arg1, ...)
    return check_result(run_worker_thread(threadpool,fn, arg1, ...))
end

function _M.set_upvalues_maxlimit(n)
    return upvalues.set_upvalues_maxlimit(n)
end

function _M.new(threadpool_name, no_check)
    if _M.support_thread then
        local t, err = require("resty.thread.new").new(threadpool_name)
        if t == nil and no_check then
            return wrapper.new(threadpool_name)
        end
        return t, err
    end
    return wrapper.new(threadpool_name)
end

_M.chekc_result = check_result

return _M
