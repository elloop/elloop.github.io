---
layout: post
title: "《Lua游戏开发实践指南》笔记 1：lua语法"
category: lua
tags: [lua]
description: ""
published: true
---

# 前言

本文记录《Lua游戏开发实践指南》lua语法部分内容。


<!--more-->

1. 变长参数函数

```lua
function f(...)
    print(string.format("arg n: %d", arg.n))
    for i=1, arg.n do
        print(i, arg[i])
    end
end
```


2. 四舍五入

```lua
function myRound(n)
    return math.floor(n + 0.5)
end
```

3. math.max, math.min

```lua
-- 把要求大小的值拼成：math.max(a, b, c, d, e, ...)形似的字符串，然后loadstring(...).
```
---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**



