# lua-resty-thread

easy use to ngx.run_worker_thread, none block

## Table of Contents

- [lua-resty-thread](#lua-resty-thread)
  - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Public Functions](#public-functions)
    - [run()](#run)
    - [run_worker_thread()](#run_worker_thread)
    - [run_with_upvalues()](#run_with_upvalues)
    - [set_upvalues_maxlimit](#set_upvalues_maxlimit)
    - [new](#new)
    - [support_thread](#support_thread)
  - [check_error](#check_error)
    - [check_error.run](#check_errorrun)
    - [check_error.run_with_upvalues](#check_errorrun_with_upvalues)
    - [check_error.run_worker_thread](#check_errorrun_worker_thread)

## Description

wrapper `ngx.run_worker_thread` api, and support normally io api, like `file`.

## Public Functions

### run()

pass callback function to `ngx.run_worker_thread` without create a new file.

note: function must without up values.

### run_worker_thread()

it's same as `ngx.run_worker_thread`.

### run_with_upvalues()

pass callback function to `ngx.run_worker_thread` without create a new file.

note: `upvalues list` must doesn't include

- thread
- userdata
- c function

### set_upvalues_maxlimit

function `run_with_upvalues` serialize upvalues level limit.

### new

banding argument `threadpool_name`, all functions is same as `resty.thread` except no first argument.

note: if flag `support_thread` is false, return a wrapper object which all api will call functions in current thread

### support_thread

flag whether this function is supported

## check_error

throw error if pass invaild args. it's same as

```lua
  local th = require('resty.thread')
  local ok, re1, re2, ... = th.check_error.run(...)
  if ok then
    error(re1)
  end
  return re1, re2, ...
```

### check_error.run

it's same as `run`, just check runtime error

### check_error.run_with_upvalues

it's same as `run_with_upvalues`, just check runtime error

### check_error.run_worker_thread

it's same as `run_worker_thread`, just check runtime error
