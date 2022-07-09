## lua-resty-thread
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

## Description

wrapper `ngx.run_worker_thread` api, and support normally io api, like `file`.

## Public Functions

### run()

pass callback function to `ngx.run_worker_thread` without create a new file.
note: function must without up values.

### run_worker_thread()

is same as `ngx.run_worker_thread`.

### run_with_upvalues()

pass callback function to `ngx.run_worker_thread` without create a new file.
note: `upvalues list` must doesn't include

- thread
- userdata
- c function

### set_upvalues_maxlimit

function `run_with_upvalues` serialize upvalues level limit.
