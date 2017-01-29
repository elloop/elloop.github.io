---
layout: post
title: "如何使用vsprintf, vsnprintf等函数"
category: c++
tags: [stl]
description: ""
---

# 前言

在一些c++的框架中，有很多小的util函数，通常每个框架里都会有一个log函数，用法类似于`printf(fmt, ...)`, 比如cocos2d-x的log函数用法大概像下面这样:

`log("size is %d, %d", w, h);`

它们的实现就是借助于vsnprintf族函数。本质在于格式化一个字符串。

下面通过一个例子来说明如何使用vsnprintf族函数来实现一个字符串格式化函数

# 示例

这个格式化函数的用法像下面这样：

```c++
int count(10);
cout << format("count is %d\n", count);
```

# format函数实现

<!--more-->

```c++
std::string format(const char *fmt, ...) {
    va_list args, args1;
    va_start(args, fmt);
    va_copy(args1, args);

    string res(1 + vsnprintf(nullptr, 0, fmt, args1), 0);
    va_end(args1);

    vsnprintf(&res[0], res.size(), fmt, args);
    va_end(args);

    return res;
}
```

# 代码讲解

```c++
std::string format(const char *fmt, ...) {

    // 定义两个va_list 类型的变量，这种变量可以用来处理变长参数：...
    va_list args, args1;            

    // 初始化args
    va_start(args, fmt);

    // args1 是 args 的一个拷贝
    va_copy(args1, args);

    // 使用nullptr和0作为前两个参数来获取格式化这个变长参数列表所需要的字符串长度
    // 使用 string(size_t n, char c) 构造函数，构造一个长度为n的字符串，内容为n个c的拷贝
    string res(1 + vsnprintf(nullptr, 0, fmt, args1), 0);
    // args1 任务完成，将其关闭，清理。
    va_end(args1);

    // 使用args来格式化要返回的字符串res， 指定长度size
    vsnprintf(&res[0], res.size(), fmt, args);
    // args 任务完成，关闭，清理
    va_end(args);

    return res;
}
```

与vsnprintf族函数类似的，还有snprintf族函数, 用法大同小异。v开头的接受的参数类型是`va_list`, snprintf等则直接接收参数`...` 


# 参考链接

- [cppreference.com](http://en.cppreference.com/w/cpp/io/c/vfprintf)


---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**



