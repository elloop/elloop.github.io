---
layout: post
title: "【C++ STL应用与实现】1: STL概览和分类"
category: c++
tags: [stl]
description: ""
---

**本系列文章的目录在这里：[目录](http://blog.csdn.net/elloop/article/details/50357205). 通过目录里可以对STL总体有个大概了解**

#前言

本文从整体上对STL的内容和功能做了一个概览，并根据其组成部分功能的不同对STL的组件进行分类。

在后续的文章中会对每个分类中的组件进行展开说明。

<!--more-->

# 容器-container

**1. 序列式容器(sequence containers)**

- [array(since c++11)](http://www.cplusplus.com/reference/array/array/) : 定长数组, 编译时确定长度，对内置数组[]的封装，让其可以当做标准容器来使用. 也可以被当做tuple.

- [vector](http://www.cplusplus.com/reference/vector/vector/) : 动态数组, 较array，容量可扩展、缩小. 随机访问，顺序存储。插入删除较链表低效.

- [`vector<bool>`](http://www.cplusplus.com/reference/vector/vector-bool/) : vector的bool特化版本，优化存储空间占用.

- [forward_list(since c++11)](http://www.cplusplus.com/reference/forward_list/) : 单链表, 纯粹从效率角度设计，甚至没有size函数，较list占用存储空间小，插入删除也略快.

- [list](http://www.cplusplus.com/reference/list/list/) : 双向链表, 较list，可双向遍历，较顺序存储容器，插入删除效率更高.

- [deque](http://www.cplusplus.com/reference/queue/queue/) : 双端动态数组, 较vector，支持push_front(), pop_front()

**2. 关联式容器(associative containers)**

- [set(multiset)](http://www.cplusplus.com/reference/set/) : 有序集合， key == value, 不可修改. 

- [map(multimap)](http://www.cplusplus.com/reference/map/) : 有序集合， paire(key, value), key不可修改

**3. 哈希表(hash table)** (since c++11)

- [unordered_set(unordered_multiset)(since c++11)](http://www.cplusplus.com/reference/unordered_set/) : 无序集合，key == value, 特性与unordered_map类似

- [unordered_map(unordered_multimap)(since c++11)](http://www.cplusplus.com/reference/unordered_map/) : 无序集合，单独访问某个元素较快，从头到尾遍历效率会低于map

**4. 容器适配器(container adapters)**

- [stack](http://www.cplusplus.com/reference/stack/stack/) : 栈 

- [queue](http://www.cplusplus.com/reference/queue/) : 队列

- [priority_queue](http://www.cplusplus.com/reference/queue/priority_queue/) : 优先队列

- [bitset](http://www.cplusplus.com/reference/queue/priority_queue/) : 优先队列

# 迭代器-iterator

迭代器是一种表示容器位置信息的对象。

## 前向迭代器 (forward iterator) : forward_list::iterator, unorderd associative containers at least support forward iterator.

## 双向迭代器 (bidirectional iterator) : iterators of list , set, multiset, map, multimap.

## 随机迭代器 (random-access iterator) : iterators of vector, deque, array, strings.

## 迭代器辅助函数

## 迭代器适配器


# 算法-algorithm

## 非变动类算法(nonmodifying algorithms)

## 变动类算法(modifying algorithms)

## 移除类算法(removing algorithms)

## 变序类算法(mutating algorithms)

## 排序类算法(sorting algorithms)

## 已序区间类算法(sorted range algorithms)

## 数值类算法(numerci algorithms)

# 函数对象-function objects (or functors for short)

## 预定义函数对象 (predefined function objects)

|**Expression**|**Actions**|
|---|---|
|`negate<T>()`|-arg|
|`plus<T>()`|arg1 + arg2|
|`minus<T>()`|arg1 - arg2|
|`multiplies<T>()`|arg1 * arg2|
|`divides<T>()`|arg1 / arg2|
|`modulus<T>()`|arg1 % arg2|
|`equal_to<T>()`|arg1 == arg2|
|`not_equal_to<T>()`|arg1 != arg2|
|`less<T>()`|arg1 < arg2|
|`greater<T>()`|arg1 > arg2|
|`less_equal<T>()`|arg1 <= arg2|
|`greater_equal<T>()`|arg1 >= arg2|
|`logical_not<T>()`|!arg1|
|`logical_and<T>()`|arg1 && arg2|
|`logical_or<T>()`|arg1 || arg2|
|`bit_and<T>()`|arg1 & arg2|
|`bit_or<T>()`|arg1 | arg2|
|`bit_xor<T>()`|arg1 ^ arg2|


## 函数组合的概念 (concept of functional composition) (according to the composite pattern in [GoF: DesignPatterns])

函数组合是STL灵活性的体现，通过函数适配器，我们可以把各种预定义functors，自定义functors，全局函数，成员函数，lambda表达式以及各种值组合起来使用.

## 函数适配器与Binders (function adapters)

|**Expression**|**Actions**|
|---|---|
|bind(fn, args...)|binds args to fn|
|mem_fn(fn)|calls fn() as a member function for an obj or ptr of obj|
|not1(fn)|unary negation: !fn(arg)|
|not2(fn)|binary negation: !fn(arg1, arg2)|


由于C++11推出了bind以及lambda表达式等强大特性, 这些特性使得函数组合操作更加方便，因此C++98中的一些用于实现函数组合的函数适配器已经deprecated. 它们包括：


|**Expression**|**Actions**|
|---|---|
|bind1st(fn, arg)|calls fn(arg, param), arg是bind1st里提供的数值，param是调用者传来的|
|bind2nd(fn, arg)|calls fn(param, arg), arg是bind2nd里提供的数值，param是调用者传来的|
|ptr_fun(fn)|calls *fn(param) or *fn(param1, param2), ptr_fun用来包装函数指针, 因为大多数标准库设施不直接支持函数指针|
|mem_fun(fn)|calls fn() as a member function for a ptr to an obj|
|mem_fun_ref(fn)|calls fn() as a member function for an obj|
|not1(fn)|!fn(param)|
|not2(fn)|!fn(param1, param2)|


从C++11起，我们应该尽量多使用bind和lambda来与STL的其它组件协同完成开发任务，这样写出来的代码更好理解也便于维护。后面的文章中将对bind的用法、lambda的用法及限制等方面进行展开，同时给出这方面的代码示例。

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**欢迎访问[github博客](http://elloop.github.io)，与本站同步更新**


