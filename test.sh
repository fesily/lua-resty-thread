#!/usr/bin/env bash
resty --main-conf="thread_pool testpool threads=100;" -e "require 'busted.runner' ({ standalone = false })"
