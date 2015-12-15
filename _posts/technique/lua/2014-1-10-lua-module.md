---
layout: post
title: "lua模块module的使用"
category: lua
tags: [lua]
description: ""
---

<!--more-->

## 遇到的问题

### name conflict for module \<module-name\>

问题描述：有两个lua文件，一个叫test.lua, 另一个叫helper.lua, helper.lua是一个模块，test.lua里要使用helper.lua这个模块.

两个文件所在路径：./test.lua, ./module/helper.lua

文件内容： 两个文件都特别简单，只有一行内容，在test.lua里require module文件夹下的helper.lua, 代码如下：

```lua
-- ~/lua/test.lua
local helper = require("module.helper")

```

```lua
-- ~/lua/module/helper.lua
module(...)
```

在控制台运行test.lua

```lua
lua test.lua

报错如下：
lua: ./module/helper.lua:2: name conflict for module 'module.helper'
stack traceback:
        [C]: in function 'module'
        ./module/helper.lua:2: in main chunk
        [C]: in function 'require'
        test.lua:2: in main chunk
        [C]: ?  
```

暂时没有找到什么原因，一个避开这个问题的办法是把helper.lua放入package.path, 然后使用require("helper")代替require("module.helper").

修改test.lua如下:

```lua
-- ~/lua/test.lua
-- 把helper.lua放入package.path路径里
package.path = package.path .. ";./module/?.lua;"
local helper = require("helper")
```

第二种解决办法：修改helper.lua, 使用module("helper")代替module(...), 即:

```lua
-- ~/lua/module/helper.lua
module("helper")
```



