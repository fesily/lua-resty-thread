describe("upvalues", function()
    local upvalues = require "resty.thread.upvalues"
    it("c function", function()
        local ffi = require "ffi"
        local uv, err = upvalues.serialize(function() return ffi.new end)
        assert.is_nil(uv, err)
        -- err may be 'unsupport type thread, userdata'
        assert.is_equal(err, "unable to dump given function" .. ' maybe a c function')
    end)
    it("function", function()
        local func = function() return "123" end
        local uv, err = upvalues.serialize(function() return func
        end)
        assert.is_not_nil(uv, err)
        local f, err = upvalues.deserialize(uv)
        assert.is_not_nil(f, err)
        assert.is_equal(f()(), '123')
    end)
    it("table", function()
        local t = { a = 1, b = 1.0, c = '222', d = function() end }
        local uv, err = upvalues.serialize(function() return t end)
        assert.is_not_nil(uv.__func, err)
    end)
    it('thread', function()
        local t = { a = coroutine.create(function() end) }
        local uv, err = upvalues.serialize(function() return t end)
        assert.is_nil(uv, err)
    end)
    it('lightuserdata', function()
        local id = debug.upvalueid(function() return upvalues end, 1)
        local uv, err = upvalues.serialize(function() return id end)
        assert.is_nil(uv, err)
    end)
end)
