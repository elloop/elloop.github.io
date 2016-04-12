---
layout: post
title: "【使用CMake组织C++工程】3：CMake 函数和宏"
category: tools
tags: [cmake]
description: ""
---

# 前言

这篇文章分享一下CMake中函数:function, 和宏：macro的使用。本文先从二者区别说起，由于二者区别很小，所以后文就仅对函数的用法进行讨论，因为函数有作用域的概念，适用范围更广。后文分享一个很实用的递归函数用于包含指定目录的所有子目录。

# CMake中function和macro的区别

以我现在的理解，函数和宏的区别不大，尤其是从其官方文档的描述来看，几乎看不到有什么区别：



在之前的文章中我没有使用函数也可以把工程组织起来，并且构建成功。那什么情况下需要用函数'''''''''''''

<!--more-->


# 参考链接

- [CMake Documentation(V3.0为例)](https://cmake.org/cmake/help/v3.0/)

- [CMake 变量](https://cmake.org/cmake/help/v3.0/manual/cmake-commands.7.html)

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

