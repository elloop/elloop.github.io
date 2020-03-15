---
layout: post
title: "【C++ STL应用与实现】6: 如何使用std::list"
category: c++
tags: [stl]
description: ""
---

**本系列文章的目录在这里：[目录](http://blog.csdn.net/elloop/article/details/50357205). 通过目录里可以对STL总体有个大概了解**

#前言

list是stl对链表数据结构的一种支持，其通常被实现为双向链表。本文介绍了list的基本用法以及在使用list时需要注意的一些问题。

# list 是什么

list是一个class template，要用它需包含`#include <list>`

# 基本用法示例

下面的代码改编自《The C++ Standard Library》第二版

{% highlight c++ %}

// 定义两个int list
list<int> list1, list2;

// 插入元素
for (int i=0; i<6; ++i) {
    list1.push_back(i);
    list2.push_front(i);
}

printList(list1, "after push, list1: ");             
printList(list2, "after push, list2: ");            


// 把list1全部移到list2中，位置是list2中第一个等于3的元素之前
list2.splice(find(begin(list2), end(list2), 3), list1);
printList(list1, "list1, after splice: ");                        // empty
printList(list2, "list2, after splice: ");   

// 把list2的第一个元素移到其末尾
list2.splice(end(list2), list2, begin(list2));
printList(list2, "list2, move begin to end: ");   

// list的成员函数sort
list2.sort();
list1 = list2;
list2.unique();     // 去掉重复

printList(list1, "list1, after assign: ");             
printList(list2, "list2, after sort & unique: ");            

list1.merge(list2);  // 合并两个链表
printList(list1, "list1, after merge: ");
printList(list2, "list2, after merge: ");

auto printList = [](const list<int> &l, const string &info="") {
    p(info);
    for (auto &i : l) {
        p(i); p(" ");
    }
    cr;
};

{% endhighlight %}

<!--more-->

输出：

{% highlight c++ %}
after push, list1: 0 1 2 3 4 5
after push, list2: 5 4 3 2 1 0
list1, after splice:
list2, after splice: 5 4 0 1 2 3 4 5 3 2 1 0
list2, move begin to end: 4 0 1 2 3 4 5 3 2 1 0 5
list1, after assign: 0 0 1 1 2 2 3 3 4 4 5 5
list2, after sort & unique: 0 1 2 3 4 5
list1, after merge: 0 0 0 1 1 1 2 2 2 3 3 3 4 4 4 5 5 5
list2, after merge:
{% endhighlight %}

# list需要注意的点

## 0. 由于其链表特性，实现同样的操作，相对于stl中的通用算法， list的成员函数通常有更高的效率，内部仅需做一些指针的操作，因此尽可能选择list成员函数。

## 1. 正如你选择数组或链表来完成任务的理由一样，原则同样适用于vector和list的选择，包括常见操作的时间复杂度、需随机访问的算法的支持等。


# 源码及参考链接

- [std::list](http://en.cppreference.com/w/cpp/container/list)

- [`list_test.cpp`](https://github.com/elloop/CS.cpp/blob/master/TotalSTL/src/container/sequence/list_test.cpp)

---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

