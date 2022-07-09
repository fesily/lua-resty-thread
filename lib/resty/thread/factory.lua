local upvalues = require("resty.thread.upvalues")
local _M = {}

function _M.create(threadpool, fn, ...)
    local s = string.dump(fn)
    return ngx.run_worker_thread(threadpool, "resty.thread.factory", 'load_function', s, ...)
end

function _M.load_function(func_string, ...)
    local f, err = loadstring(func_string)
    assert(f, err)
    return f(...)
end

function _M.create_with_upvalues(threadpool, fn, ...)
    local t, err = upvalues.serialize(fn)
    if not t then return false, err end
    return ngx.run_worker_thread(threadpool, "resty.thread.factory", 'load_function_with_upvalues', t, ...)
end

function _M.load_function_with_upvalues(t, ...)
    local f, err = upvalues.deserialize(t)
    assert(f, err)
    return f(...)
end

return _M
