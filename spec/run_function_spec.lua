describe("resty.thread", function()
    local th = require "resty.thread"
    describe("run", function()
        it("hello", function()
            local s = th.run('testpool', function(d)
                return d
            end, "hello")
            assert.is_equal(s, 'hello')
        end)
        it("should be function", function()
            local ok, err = th.run('testpool', 'dd')
            assert.is_false(ok)
            assert.is_equal(err, "fn is not a function")
        end)
        it('should not have up values', function()
            local ok, err = th.run('testpool', function(d)
                return th.run
            end)
            assert.is_false(ok)
            assert.is_equal(err, "fn must not have up values:1")
        end)
    end)
    describe("run with upvalues", function()
        it("hello", function()
            local hello = 'hello'
            local s = th.run_with_upvalues('testpool', function()
                return hello
            end)
            assert.is_equal(s, 'hello')
        end)
        it("should be function", function()
            local ok, err = th.run_with_upvalues('testpool', 'dd')
            assert.is_false(ok)
            assert.is_equal(err, "fn is not a function")
        end)
    end)
    describe("run with error",function()
        it("catch error",function()
            local ok, err = th.run_with_upvalues('testpool', function()
                error("")
            end)
            assert.is_false(ok)
            assert.is_equal(err, "spec/run_function_spec.lua:40: ")
        end)
        it("not catch error", function()
            assert.has_error(function ()
                th.check_error.run('testpool', function()
                    error("")
                end)
            end)
        end)
    end)
end)
