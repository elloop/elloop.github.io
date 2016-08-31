---
layout: post
title: "C++正则表达式使用实例--实现一个markdown代码标记转换工具"
category: c++
tags: [tools]
description: ""
---

#前言

这个需求起源于github官方升级了Jekyll引擎到3.0，markdown引擎受到了一定的影响，比如代表标记由原来的

"```c++```"

变成了`{%highlight c++%} {%endhighlight%}`

<!--more-->

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**



