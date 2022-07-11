local ffi = require "ffi"

ffi.cdef[[
    typedef struct ngx_cycle_s           ngx_cycle_t;
    typedef struct ngx_thread_pool_s  ngx_thread_pool_t;
    extern ngx_cycle_t  *ngx_cycle;
    ngx_thread_pool_t *ngx_thread_pool_get(ngx_cycle_t *cycle, ngx_str_t *name);
]]


local ffi_str = ffi.string
local type = type
local C = ffi.C
local NGX_ERROR = ngx.ERROR
local ngx_thread_pool_get = C.ngx_thread_pool_get
local ngx_cycle = C.ngx_cycle
assert(ngx_cycle ~= nil)
assert(ngx_thread_pool_get ~= nil)
local ngx_str_name = ffi.new("ngx_str_t[1]")

local _M ={}

function _M.exsit(name)
    local str = ngx_str_name[0]
    str.data = name
    str.len = #name
    return ngx_thread_pool_get(ngx_cycle, ngx_str_name) ~= nil
end

return _M