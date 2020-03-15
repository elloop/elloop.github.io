---
layout: post
title: " 【C++ STL应用与实现】2: 如何使用std::vector"
category: c++
tags: [stl]
description: ""
---

**本系列文章的目录在这里：[目录](http://blog.csdn.net/elloop/article/details/50357205). 通过目录里可以对STL总体有个大概了解**

# 前言

本文介绍vector容器。vector是STL容器中最为常用的一个，它是序列式容器的代表，是对动态数组的抽象封装。

# vector 是什么

vector是一个class template，要用它需包含`#include <vector>`

# 基本用法及常识

## 创建 & 增删改查

{% highlight cpp %}

// 使用初始化列表(initializer list) since C++11
// 更多创建方式见参考链接
vector<int> vi {1, 2, 3};

// 增
for (int i=4; i<10; ++i) {
    vi.push_back(i);
}

// 打印内容
printContainer(vi, "init, vi: ");

// 查 & 改, random access and modify
vi[0] = 10;

// 删
// 删第一个元素
auto iter = vi.begin();
vi.erase(iter);
printContainer(vi, "erase begin, vi: ");

// use <algorithm> std::find to locate pos of 5 in vi.
// 删值为5的元素
iter = find(vi.begin(), vi.end(), 5);
if (iter != vi.end()) {
    pln("erase 5");
    vi.erase(iter);
}
printContainer(vi, "erase 5, vi: ");

{% endhighlight %}

<!--more-->

输出：

{% highlight cpp %}
init vi: 10 2 3 4 5 6 7 8 9
erase begin, vi: 2 3 4 5 6 7 8 9
erase 5
erase 5, vi: 2 3 4 6 7 8 9
{% endhighlight %}

以下是辅助函数printContainer的实现。

{% highlight cpp %}
#define	cr do { std::cout << std::endl; } while (0);

template <typename T>
inline void p(const T & x) {
    std::cout << x;
}

template <typename Con>
void printContainer(const Con & c, const std::string& opt = "") {
    if (!opt.empty()) {
        p(opt);
    }
    auto iter = c.begin();
    while (iter != c.end()) {
        p(*iter);
        p(" ");
        ++iter;
    }
    cr;
}
{% endhighlight %}

# vector需要注意的点

## 0. copy in copy out是所有的STL容器的工作原理(参见Effective STL)

因此，使用vector等容器的一个原则是，为了避免拷贝开销，不要直接把大的对象直接往里塞，而是使用指针。

## 1. 由于其顺序存储的特性，vector插入删除操作的时间复杂度是O(n)

## 2. vector的容量capacity

### 预先指定capacity是个好习惯

vector的capacity：即指vector最大能容纳多少元素

vector的size：即当前存入了多少元素

所以始终有size <= capacity，正如我们自己实现动态数组所考虑的一样，当size == capacity的时候，再要增加元素就要扩容，重新找一块更大的内存把元素转移过去，这种扩容操作有两个后果：

- 使得vector原来的引用、指针、迭代器失效

- 内存分配消耗了时间

<font color="red">因此，要尽可能的让这种扩容操作少发生，通常的做法是往vector中添加元素之前，预先指定一个capacity，比如：</font>

{% highlight cpp %}
vector<int> vi;         // capacity: 0

vector<int> vi(100);    // capacity: 100
// or
vi.reserve(100);

{% endhighlight %}

两种方式指定容量：1. 构造函数里；2. reserve() 函数

有些版本的vector实现里，如果用户不预先指定一个capacity，那么在第一次往容器里添加元素的时候，vector会自动分配一个指定大小（如2K）的内存块以避免频繁发生扩容。这可能导致的问题是，如果你有很多个这样的vector，每个都保存很少的数据，那么这些预先分配的内存块将是一笔很大的浪费。这又体现了自己预先指定一个capacity的必要性。

### 如何缩小容量

c++11之前，需要借助swap，像下面这个函数模板:shrinkCapacity那样。

c++11之后，调用`shrink_to_fit()`即可。

{% highlight c++ %}
template <typename T>
void shrinkCapacity(vector<T> &v) {
    vector<T> temp(v);
    temp.swap(v);
}

RUN_GTEST(VectorTest, Shrink, @@);

vector<int> vi;

vi.reserve(30);
vi.push_back(1);

psln(vi.capacity());        // 30

shrinkCapacity(vi);         // before c++11

// vi.shrink_to_fit();         // since c++ 11

psln(vi.capacity());        // 1

END_TEST;
{% endhighlight %}

## 3. vector的成员函数都不做边界检查(at方法会抛异常)，使用者要自己确保迭代器和索引值的合法性。

# 源码及参考链接

- [std::vector](http://en.cppreference.com/w/cpp/container/vector)

- [`vector_test.cpp`](https://github.com/elloop/CS.cpp/blob/master/TotalSTL/src/container/sequence/vector_test.cpp)


---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**



