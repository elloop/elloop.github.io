---
layout: post
title: "使用ZeroBraneStudio调试lua"
highlighter_style: solarizeddark
category: [lua]
tags: [lua]
description: ""
published: true
---
## 缘起
昨天看了Rust大牛[Elton的采访](http://www.tuicool.com/articles/URzueiN)，他在被问到有什么好的建议或者工具推荐给技术人员的时候讲到了3点，第1点是:
>"政治不正确地讲，我觉得先要有一台MacBook。程序员的工作大多都对着代码，Retina屏幕对于显示文字方面实在是无可挑剔"

我看了觉得很有道理，因此把家里的MBP拿来公司，决定正式转换到以Mac为主要工具的工作模式下。
早上刚一到公司，就把双显示器的左边那个挪到左边的小桌子上用几本大厚书把它垫到和另一个差不多的高度，中间腾出来一个24寸显示器的宽度来安置Mac。下载代码库、装企业QQ、UI编辑器、接好机械键盘，全部搞定了, 看着Retina清澈的样子，我已经迫不及待开始Coding了。可是当我刚打开vim的时候, 就突然意识到一个非常严重的问题，Mac怎么调试lua？？ (这几天要搞的功能是由lua来写) 在windows上，能用lua studio、decoda、vs的BabeLua插件。可是Mac上要怎么搞，我至少要解决两个问题：

- 在windows上可以把游戏编程win32的可执行程序，作为lua的宿主程序，那么在Mac上这个宿主程序怎么搞？用iOS模拟器来跑iOS版本的游戏还是编一个Mac版本的？
- 搞定了宿主程序的话，用什么工具能把lua代码加进去，打断点、看Stack、加Watch？

于是午饭过后，我开始折腾这俩问题，我要在Mac上调试lua代码，完成功能开发！

一个一个来，第一个问题我觉得不难，因为cocos2d-x官方的示例都是很容易就能在Mac上和iOS模拟器上跑起来的，我们的Xcode工程是好几个工程组成的，并且集成了一些渠道SDK, SDK组的兄弟在维护，我折腾不明白可以找他们解决。项目组里所有的客户端开发都是windows，还没有人在Mac上调试lua，因此第二个问题是重点。

在网上随便一搜, 其实早就有解决方案了，那就是： ZeroBrane Studio.

它是一个跨平台的lua调试工具，并且可以结合luasocket实现远程调试cocos2d-x的lua代码。


## 遇到的问题
What to do when a _CrtIsValidHeapPointer assertion failure happens?

When doing Lua embedding, sometimes if you didn't clean the stack correctly, it might cause a _CrtIsValidHeapPointer assertion failure.
As the comment of the function _CrtIsValidHeapPointer says: "verify pointer is not only a valid pointer but also that it is from the 'local' heap. Pointers from another copy of the C runtime (even in the same process) will be caught."

Let's check the details of the 'invalid pointer'. When lua_open() return a lua_State* L, it's with a stack of default size 45. If you make some fault not clear the return values of function, that garbage will finally pile up on the stack and crash the stack memory block. When a new op needs to increase the stack size, a realloc will happen, and the CRT will find that the old pointer is invalid and this will lead a _CrtIsValidHeapPointer failure.

To fix, just carefully check your code (using lua_gettop(L) to check the stack size) and clean the unused slot on the stack.

For the 'non local heap' one, please check and make sure Lua lib doesn't have a separate copy of CRT.
