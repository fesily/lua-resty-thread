describe("check ngx thread_pool", function()
    local ngx_thread_pool = require "resty.thread.ngx_threadpool"
    it("should be not exsit", function()
        assert.is_false(ngx_thread_pool.exsit("default"))
    end)
    it("should be exsit", function()
        assert.is_true(ngx_thread_pool.exsit("testpool"))
    end)
end)
