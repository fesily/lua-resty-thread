
---@alias ngx.thread.arg boolean|number|integer|string|lightuserdata|table

---@param threadpool string
---@param module_name string
---@param func_name string
---@param arg1 ngx.thread.arg
---@param arg2 ngx.thread.arg
---@param ... ngx.thread.arg
---@return boolean,boolean,ngx.thread.arg,...
function ngx.run_worker_thread(threadpool, module_name, func_name, arg1, arg2, ...)
end
