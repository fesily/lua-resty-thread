local _M = {}

function _M.create(threadpool, fn, ...)
    local s = string.dump(fn)
    return ngx.run_worker_thread(threadpool, "resty.thread.fatcory", 'load_function', s, ...)
end

function _M.load_function(func_string, ...)
    local f, err = loadstring(func_string)
    assert(f, err)
    return f(...)
end

return _M
