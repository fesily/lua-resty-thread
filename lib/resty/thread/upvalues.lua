local debug_getinfo = debug.getinfo
local debug_getupvalue = debug.getupvalue
local debug_setupvalue = debug.setupvalue
local table_insert = table.insert

local tab_nkeys = require "table.nkeys"
local tab_new = require "table.new"

local function debug_getupvalue_num(fn)
    return debug_getinfo(fn, "u").nups
end

local _M = {}

_M.maxlimit = 4
local serialize_upvalues
local function serialize_func(fn, limit)
    local ok, result = pcall(string.dump, fn)
    if not ok then
        return nil, result .. ' maybe a c function'
    end
    local upvalues, err = serialize_upvalues(fn, debug_getinfo(fn, "u").nups, limit)
    if not upvalues and err then
        return nil, err
    end
    return { __func = result, __upvalues = upvalues }
end

local function serialize_table(t, limit)
    if limit > _M.maxlimit then
        return nil, "too many level"
    end
    local len = #t
    local nt = tab_new(len, tab_nkeys(t) - len)
    for key, value in pairs(t) do
        local err
        if type(value) == 'thread' or type(value) == 'userdata' then
            return nil, "unsupport type thread, userdata"
        elseif (type(value) == 'function') then
            value, err = serialize_func(value, limit + 1)
            if not value then return nil, err end
        elseif type(value) == 'table' then
            value, err = serialize_table(value, limit + 1)
            if not value then return nil, err end
        end
        if key == "__upvalues" or key == "__func" then
            return nil, "unsupported table key __upvalues and __func"
        end
        nt[key] = value
    end
    return nt
end

serialize_upvalues = function(fn, nups, limit)
    if limit > _M.maxlimit then
        return nil, "too many level"
    end
    if nups == 0 then return nil end
    local t = {}
    for i = 1, nups do
        local err
        local name, v = debug_getupvalue(fn, i)
        if type(v) == "function" then
            v, err = serialize_func(v, limit + 1)
            if not v then return nil, err end
        elseif type(v) == "thread" or type(v) == "userdata" then
            return nil, "unsupport type thread, userdata"
        elseif type(v) == 'table' then
            v, err = serialize_table(v, limit + 1)
            if not v then return nil, err end
        end
        table_insert(t, v)
    end
    return t
end

function _M.serialize(fn)
    return serialize_func(fn, 1)
end

local deserialize_upvalues

local function deserialize_table(t)
    if t.__func then
        local fn, err = loadstring(t.__func)
        if fn == nil then
            return nil, err
        end

        err = deserialize_upvalues(fn, t.__upvalues)
        if err then return nil, err end
        return fn
    else
        for index, value in ipairs(t) do
            if type(value) == "table" then
                local err
                t[index], err = deserialize_table(value)
                if err then return nil, err end
            end
        end
        return t
    end
end

deserialize_upvalues = function(fn, t)
    if not t then return end
    local nups = debug_getupvalue_num(fn)
    assert(#t == nups)
    for index, value in ipairs(t) do
        if type(value) == "table" then
            local err 
            value, err = deserialize_table(value)
            if err then return err end
        end
        debug_setupvalue(fn, index, value)
    end
end

function _M.deserialize(t)
    assert(t, "deserialize table is nil")
    return deserialize_table(t)
end

return _M
