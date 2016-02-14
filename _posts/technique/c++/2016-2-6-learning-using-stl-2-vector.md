---
layout: post
title: "【C++ STL学习与应用总结】2: 如何使用std::vector"
category: c++
tags: [stl]
description: ""
---

**本系列文章的目录在这里：[目录](http://blog.csdn.net/elloop/article/details/50357205). 通过目录里可以对STL总体有个大概了解**

#前言

本文介绍了std::vector容器。可以vector是STL容器中最为常用的一个，它是序列式容器的代表，是对动态数组的抽象封装。


<!--more-->

# 基本用法及常识

{% highlight cpp %}
// 使用初始化列表(initializer list) since C++11
vector<int> vi {1, 2, 3};

// add elems
for (int i=4; i<10; ++i) 
{
    vi.push_back(i);
}

// random access and modify
vi[0] = 10;

// print elems
for (int elem : vi)
{
    pln(elem);
}
{% endhighlight %}

输出：

{% highlight cpp %}
10
2
3
4
5
6
7
8
9
{% endhighlight %}

由于vector是顺序式的存储结构，因此有以下的常识：

**1. 访问任意元素的时间复杂度是O(1)**

**2. 插入、删除操作的时间复杂度是O(n)**

这里对基本的用法不做过多介绍，更多的API和用法请参考[这里](http://www.cplusplus.com/reference/vector/vector/?kw=vector)。下面着重介绍一下使用vector时的一些注意事项。

# vector的容量

vector初始情况下的容量取决于对象的定义方式：

```cpp
{% highlight cpp %}
vector<int> vi;         // capacity: 0

vector<int> vi(100);    // capacity: 100
{% endhighlight %}

# 容器元素类型的限制

# copy in copy out

# 注意迭代器失效






# 源码及参考链接

- []()

- []()

- []()

# todo

{% highlight cpp %}
shrink_to_fit

data

allocator
{% endhighlight %}

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**



