---
layout: post
title: "【C++ STL用法示例】1: STL概览和分类"
category: c++
tags: [stl]
description: ""
---

##前言

本文从整体上对STL的内容和功能做了一个概览，并根据其组成部分功能的不同对STL的组件进行分类。

<!--more-->

## 容器-container

**1. 序列式容器(sequence containers)**

- [array(since c++11)](http://www.cplusplus.com/reference/array/array/) : 定长数组, 编译时确定长度，对内置数组[]的封装，让其可以当做标准容器来使用. 也可以被当做tuple.

- [vector](http://www.cplusplus.com/reference/vector/vector/) : 动态数组, 较array，容量可扩展、缩小. 随机访问，顺序存储。插入删除较链表低效.

- [vector<bool>](http://www.cplusplus.com/reference/vector/vector-bool/) : vector的bool特化版本，优化存储空间占用.

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

## 迭代器-iterator



## 算法-algorithm


## 函数子-functor

