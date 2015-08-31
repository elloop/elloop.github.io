---
layout: post
title: "在Mac上调试lua--使用ZeroBrane Studio"
highlighter_style: solarizeddark
category: [lua]
tags: [lua]
description: ""
published: true
---
## 内容概述
这篇文章讲述了如何使用ZeroBrane Studio在Mac上调试cocosd-x游戏的lua代码。
作者机器的软件环境是：
- cocos2d-x 2.2.3, lua 5.1
- ZeroBrane Studio 1.10 (mobdebug 0.63)
- Mac 10.10.5, Xcode 6.3

## 缘起
昨天看了Rust大牛[Elton的采访](http://www.tuicool.com/articles/URzueiN)，他在被问到有什么好的建议或者工具推荐给技术人员的时候讲到了3点，第1点是:
>"政治不正确地讲，我觉得先要有一台MacBook。程序员的工作大多都对着代码，Retina屏幕对于显示文字方面实在是无可挑剔"

我觉得还挺有道理的，加上之前有几个月在Mac上的开发经验，它又是基于unix的，因此把家里的MBP拿来公司，决定正式转换到以Mac为主要工具的工作模式下。
早上刚一到公司，就把双显示器的左边那个挪到左边的小桌子上用几本大厚书把它垫到和另一个差不多的高度，中间腾出来一个24寸显示器的宽度来安置Mac。下载代码库、装企业QQ、UI编辑器、接好机械键盘，全部搞定了, 看着Retina清澈的样子，我已经迫不及待开始Coding了。可是当我刚打开vim的时候, 就突然意识到一个非常严重的问题，Mac怎么调试lua？？ (这几天要搞的功能是由lua来写) 在windows上，能用lua studio、decoda、vs的BabeLua插件。可是Mac上要怎么搞，我至少要解决两个问题：

- 在windows上可以把游戏编程win32的可执行程序，作为lua的宿主程序，那么在Mac上这个宿主程序怎么搞？用iOS模拟器来跑iOS版本的游戏还是编一个Mac版本的？
- 搞定了宿主程序的话，用什么工具能把lua代码加进去，打断点、看Stack、加Watch？

<!--more-->

于是午饭过后，我开始折腾这俩问题，我要在Mac上调试lua代码，完成功能开发！

一个一个来，第一个问题我觉得不难，因为cocos2d-x官方的示例都是很容易就能在Mac上和iOS模拟器上跑起来的，我们的Xcode工程是好几个工程组成的，并且集成了一些渠道SDK, SDK组的兄弟在维护，我折腾不明白可以找他们解决。项目组里所有的客户端开发都是windows，还没有人在Mac上调试lua，因此第二个问题是重点。

在网上随便一搜, 其实早就有解决方案了，那就是： [ZeroBrane Studio](http://studio.zerobrane.com/), 以下简称`zb`.

它是一个跨平台的lua IDE, 用lua写成, 想了解更多可以点链接进去看看。这里只要确定它可以用来在Mac上调试lua，并且是cocos2d-x的项目就ok了。

## 先在Windows上跑起来试试 
既然是跨平台的，我先在windows上试试，因为windows上有现成的可执行程序。我下载了zip包版本的zb，参考了[这篇文章](http://notebook.kulchenko.com/zerobrane/cocos2d-x-simulator-and-on-device-debugging-with-zerobrane-studio)，实现了在windows上使用zb进行lua的断点调试。要点如下：

- s1. 复制mobdebug.lua到lua代码目录(在zb/lualibs/mobdebug/下面能找到它)，在lua程序启动的地方加入下面这句代码：

    ```lua
    require("mobdebug").start()
    ```

- s2. 把luasocket和lua51.dll的路径分别添加在lua的[package.path](http://www.lua.org/manual/5.1/manual.html#pdf-package.path)和[package.cpath](http://www.lua.org/manual/5.1/manual.html#pdf-package.cpath)的搜索范围内。(这是因为zb调试用到了luasocket，进入mobdebug.lua里面就会看到，里面会require("socket"), 而luasocket用到了lua51.dll。), 以我的路径为例，我的zb解压在了 D:\zb\, 我在项目里的main.lua里面(在调用require("mobdebug")之前), 加入了如下的代码来设置lua和dll的搜索路径：

    ```lua
    local zb = "D:\\zb\\"
    package.path = package.path .. ";" .. zb .. "lualibs\\?\\?.lua;" .. zb .. "lualibs\\?.lua;"
    package.cpath = package.cpath .. ";" .. zb .. "bin\\?.dll;" .. zb .. "bin\\clibs\\?.dll;"
    ```

- s3. 启动zb，把项目中的lua源代码加入到zb，在Project菜单，勾选 "Start Debug Server"以启动调试器。找个地方设置个断点。

经过这三步，就可以在VS中，或者直接运行游戏的exe文件了，正常的话，zb中的断点就会被触发。一旦成功断点，就可以使用zb的堆栈和watch等窗口跟踪运行流程和实时查看变量的值了。

###可能会遇到的问题
- require("socket") 处报错：no module "socket.core", 这是因为lua51.dll有问题。先来分析一下到报错之前的执行流程: 

    ```lua
    require("mobdebug").start() -----> require("socket") ------> require("socket.core")
    ```

    涉及到的文件从mobdebug.lua到socket.lua, require("socket.core")这句是在socket.lua里面调用的，这说明lua解释器已经找到了mobdebug.lua并且执行到了require("socket")那一句代码(package.path的设置生效了)。为什么找不到socket.core ? 在zb\lualibs\socket\下面并没有找到core.lua, 也就是说不是package.path里, 那么到cpath里找找。在zb\bin\clibs\socket\下发现了core.dll, 看来就是加载这个dll失败了。我在cmd里面以交互的方式启动lua，并且重复了上面的操作：1 设置path和cpath；2 require("socket"), 看到了如下的报错信息，意思是我的lua没有开启加载动态链接库的功能。因此解决方案就是重编一个带加载动态库功能的lua就可以了。如果还不行，就像我一样，到LuaBinary网站下载一个编译好的lua包，解压拿来用。

## 开始在Mac上调试
通过在windows上的探索，我对zb调试的必备条件有了基本的了解：
- 拷贝mobdebug.lua到游戏目录，加入require("mobdebug").start()
- 提供lua51.dll和luasocket以实现和zb调试器的通讯

mobdebug.lua是在zb的lualibs/mobdebug/路径就能拿到，很简单。关键问题还是socket, Mac上会有对应的版本吗？加上我们在上面分析的第一个问题
我要解决如下两个问题就可以了：1. 如何提供一个宿主程序来挂接lua代码; 2. 找到合适的luasocket动态库；

### Mac上的宿主程序
我们的Xcode项目是仅针对iPhone的, 因此不能像windows上拿vs直接跑起来exe挂上lua就开调。是不是就宣告行动失败，没法调试了呢？好在zb还支持模拟器和真机调试。我不想搞个真机来还要签名什么的，于是我把项目在iOS模拟器上跑了起来，只差最后一步了，怎么把它和zb的调试器关联起来呢?

## 在游戏里集成luasocket扩展
zb在真机和模拟器上的调试叫做远程调试，还是通过luasocket来通信。因此这一步的本质还是集成luasocket，cocos2d-x


# 遇到的问题
- 在windows上程序退出后，触发断言失败： _CrtIsValidHeapPointer assertion failure ?

When doing Lua embedding, sometimes if you didn't clean the stack correctly, it might cause a _CrtIsValidHeapPointer assertion failure.
As the comment of the function _CrtIsValidHeapPointer says: "verify pointer is not only a valid pointer but also that it is from the 'local' heap. Pointers from another copy of the C runtime (even in the same process) will be caught."

Let's check the details of the 'invalid pointer'. When lua_open() return a lua_State* L, it's with a stack of default size 45. If you make some fault not clear the return values of function, that garbage will finally pile up on the stack and crash the stack memory block. When a new op needs to increase the stack size, a realloc will happen, and the CRT will find that the old pointer is invalid and this will lead a _CrtIsValidHeapPointer failure.

To fix, just carefully check your code (using lua_gettop(L) to check the stack size) and clean the unused slot on the stack.

For the 'non local heap' one, please check and make sure Lua lib doesn't have a separate copy of CRT.
