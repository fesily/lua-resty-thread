describe("disable ngx.run_worker_thread", function()
    ngx.run_worker_thread = nil
    local thread = require "resty.thread"
    it("should be unsopprt", function()
        assert.is_false(thread.support_thread)
    end)
    describe("new should return wrapper api", function()
        local th = thread.new("1")
        it("set_upvalues_maxlimit", function()
            th.set_upvalues_maxlimit(5)
            assert.is_equal(require "resty.thread.upvalues".maxlimit, 5)
        end)
        it("run", function()
            local ffi = require "ffi"
            local r, r2 = th:run(function()
                return ffi, "ddd"
            end)
            assert.is_equal(ffi, r)
            assert.is_equal(r2, 'ddd')
        end)
    end)
end)
