---
layout: post
title: "【使用CMake组织C++工程】3：CMake 函数和宏"
category: tools
tags: [cmake]
description: ""
published: false
---

# 前言

这篇文章分享一下CMake中函数:function, 和宏：macro的使用。本文先从二者区别说起，由于二者区别很小，所以后文就仅对函数的用法进行讨论，因为函数有作用域的概念，适用范围更广。后文分享一个很实用的递归函数用于包含指定目录的所有子目录。

# CMake中function和macro的区别

以我现在的理解，函数和宏的区别不大，尤其是从其官方文档的描述来看，几乎看不到有什么区别。

function的文档：

>Start recording a function for later invocation as a command.</br>
function(<name> [arg1 [arg2 [arg3 ...]]])
  COMMAND1(ARGS ...)
  COMMAND2(ARGS ...)
  ...
endfunction(<name>)
Define a function named <name> that takes arguments named arg1 arg2 arg3 (...). Commands listed after function, but before the matching endfunction, are not invoked until the function is invoked. When it is invoked, the commands recorded in the function are first modified by replacing formal parameters (${arg1}) with the arguments passed, and then invoked as normal commands. In addition to referencing the formal parameters you can reference the variable ARGC which will be set to the number of arguments passed into the function as well as ARGV0 ARGV1 ARGV2 ... which will have the actual values of the arguments passed in. This facilitates creating functions with optional arguments. Additionally ARGV holds the list of all arguments given to the function and ARGN holds the list of arguments past the last expected argument.

A function opens a new scope: see set(var PARENT_SCOPE) for details.

See the cmake_policy() command documentation for the behavior of policies inside functions.

"在杭州打开:)"



在之前的文章中我没有使用函数也可以把工程组织起来，并且构建成功。那什么情况下需要用函数'''''''''''''

<!--more-->


# 参考链接

- [cmake-language](https://cmake.org/cmake/help/v3.0/manual/cmake-language.7.html)

- [CMake Documentation(V3.0为例)](https://cmake.org/cmake/help/v3.0/)

- [CMake 变量](https://cmake.org/cmake/help/v3.0/manual/cmake-commands.7.html)

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

