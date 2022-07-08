## lua-resty-thread
easy use to ngx.run_worker_thread, none block

## Table of Contents

- [lua-resty-thread](#lua-resty-thread)
- [Table of Contents](#table-of-contents)
- [Description](#description)
- [Public Functions](#public-functions)
  - [run()](#run)
  - [run_worker_thread()](#run_worker_thread)

## Description

wrapper `ngx.run_worker_thread` api, and support normally io api, like `file`.

## Public Functions

### run()

pass callback function to `ngx.run_worker_thread` without create a new file.
note: must function must without up values.

### run_worker_thread()

is same as `ngx.run_worker_thread`.
