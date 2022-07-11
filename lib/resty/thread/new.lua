local th = require "resty.thread"
local _M = {}

function _M:run(fn, arg1, ...)
    return th.run(self.threadpool_name, fn, arg1, ...)
end

function _M:run_with_upvalues(fn, arg1, ...)
    return th.run_with_upvalues(self.threadpool_name, fn, arg1, ...)
end

function _M:run_worker_thread(fn, arg1, ...)
    return th.run_worker_thread(self.threadpool_name, fn, arg1, ...)
end

_M.set_upvalues_maxlimit = th.set_upvalues_maxlimit

function _M.new(tablepool_name)
    return setmetatable({ threadpool_name = tablepool_name }, { __index = _M })
end

return _M
