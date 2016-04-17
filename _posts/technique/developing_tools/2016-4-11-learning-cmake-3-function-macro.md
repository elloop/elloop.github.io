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

从其官方文档的描述并不会看出二者有什么大的区别，除了在function的定义中提到了Scope的概念。

下面以StackOverflow上的一个例子来直观的了解一下二者的区别:

```c++
set(var "ABC")

macro(Moo arg)
  message("arg = ${arg}")
  set(arg "abc")
  message("# After change the value of arg.")
  message("arg = ${arg}")
endmacro()
message("=== Call macro ===")
Moo(${var})

function(Foo arg)
  message("arg = ${arg}")
  set(arg "abc")
  message("# After change the value of arg.")
  message("arg = ${arg}")
endfunction()
message("=== Call function ===")
Foo(${var})
```

输出结果是：

```c++
➜  /Users/sunyongjian1/codes/local_codes/cmake_test/build cmake ..
=== Call macro ===
arg = ABC
# After change the value of arg.
arg = ABC
=== Call function ===
arg = ABC
# After change the value of arg.
arg = abc
```

可以看到，Moo这个宏的表现与C语言中的宏类似，仅仅是做字符串的替换; Foo函数里arg则是被赋值为var的值，在Foo内部可以修改这个arg变量的值。

个人感觉, 对于CMake里的函数和宏的使用原则可以以C语言里函数和宏的使用原则来作为参考。下面就着重说一下我在组织工程的时候对于function的常见用法。

# function 的使用技巧

## 如何按引用来传递参数？(在function中修改外部作用域的值)

**答：通过名字来传递变量**

例如：有一个var变量，在函数外部定义，要通过调用一个函数f1, 来修改var的值

```c++
set(var "abc")                      # 定义一个变量var，初值为abc

function(f1 arg)
    set(${arg} "ABC" PARENT_SCOPE)  # ${arg} == var, 于是相当于set(var "ABC" PARENT_SCOPE)
endfunction()

message("before calling f1, var = ${var}")
f1(var)                                     # 如果写成了 f1(${var}), 那么先计算表达式${var}, 即相当于调用f1(abc), 调用结果是在函数的父作用域定义了一个abc变量.
message("after calling f1, var = ${var}")
```

结果：

```c++
➜  /Users/sunyongjian1/codes/local_codes/cmake_test/build cmake ..
before calling f1, var = abc
after calling f1, var = ABC
```

需要注意的两点：

- 函数调用处用变量的名字var，而不是它的值${var}
 
- 在函数内部，set的时候，要加上作用域PARENT_SCOPE.

试试写成`f1(${var})`

```c++
message("before calling f1, abc = ${abc}")
f1(${var})                                     
message("after calling f1, abc = ${abc}")
```

输出是：

```c++
➜  /Users/sunyongjian1/codes/local_codes/cmake_test/build cmake ..
before calling f1, abc = 
after calling f1, abc = ABC
```

其实在了解了参数展开之后，这个问题很显而易见，本质上就是调用了一个`set(<var-name> <var-value> <var-scope>)`, 只不过如果需要通过函数来包装他的话就要注意传参传过来的东西是个变量名还是变量的值。


## 如何传递列表类型的参数？






# CMake里的函数也可以递归调用

在之前的文章中我没有使用函数也可以把工程组织起来，并且构建成功。那什么情况下需要用函数

<!--more-->


# 参考链接

- [cmake-language](https://cmake.org/cmake/help/v3.0/manual/cmake-language.7.html)

- [CMake Documentation(V3.0为例)](https://cmake.org/cmake/help/v3.0/)

- [CMake 变量](https://cmake.org/cmake/help/v3.0/manual/cmake-commands.7.html)

- [function的定义](https://cmake.org/cmake/help/v3.0/command/function.html#command:function)

- [macro的定义](https://cmake.org/cmake/help/v3.0/command/macro.html#command:macro)

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

