---
layout: post
title: "【C++ STL学习与应用总结】1: STL概览和分类"
category: c++
tags: [stl]
description: ""
---

#前言

这篇文章是《STL学习与应用总结》系列的目录, 也是这系列文章的写作计划。STL的总结主要分成四大块：容器、迭代器、函数对象和算法。

每个大块细分成的每个叶子节点就对应着一篇文章，已经完成的文章会在目录里以超链接的形式展现，未完成则作为写作计划。

这里的“目录”有些不一样，很多是用表格的形式，这样也便于一目了然看到某个大块下有哪些子节点，比如算法这一块，就用表格比较直观，采用《C++标准程序库》的分类方式，每个算法类别是一个表。

# 容器 (container)

**1. 序列式容器**

|**类型**|**文章链接**|
|--------|------------|
|`vector`|[【C++ STL学习与应用总结】2: 如何使用std::vector]()|
|`vector<bool>`|[【C++ STL学习与应用总结】3: 如何使用`std::vector<bool>`]()|
|`deque`|[【C++ STL学习与应用总结】4: 如何使用std::deque]()|
|`array`|[【C++ STL学习与应用总结】5: 如何使用std::array (since c++11)]()|
|`list`|[【C++ STL学习与应用总结】6: 如何使用std::list]()|
|`forward_list`|[【C++ STL学习与应用总结】7: 如何使用std::forward_list (since c++11)]()|


**2. 关联式容器(associative containers)**

|**类型**|**文章链接**|
|--------|------------|
|`set and multiset`|[【C++ STL学习与应用总结】8: 如何使用std::set和std::multiset]()|
|`map and multimap`|[【C++ STL学习与应用总结】9: 如何使用std::map和std::multimap]()|


**3. 哈希表(hash table)** (since c++11)


|**类型**|**文章链接**|
|--------|------------|
|`unordered_set and unordered_multiset`|[【C++ STL学习与应用总结】10: 如何使用std::unordered_set和std::unordered_multiset (since c++11)]()|
|`unordered_map and unordered_multimap`|[【C++ STL学习与应用总结】11: 如何使用std::unordered_map和std::unordered_multimap (since c++11)]()|


**4. 容器适配器(container adapters)**


|**类型**|**文章链接**|
|--------|------------|
|`stack`|[【C++ STL学习与应用总结】12: 如何使用std::stack]()|
|`queue and priority_queue`|[【C++ STL学习与应用总结】13: 如何使用std::queue和std::priority_queue]()|
|`bitset`|[【C++ STL学习与应用总结】14: 如何使用std::bitset]()|


# std::string : [【C++ STL学习与应用总结】15: 使用std::string]()

# 迭代器-iterator

- [【C++ STL学习与应用总结】16: 迭代器综述]()

- [【C++ STL学习与应用总结】17: 使用迭代器辅助函数]()

- [【C++ STL学习与应用总结】18: 使用迭代器适配器]()

- [【C++ STL学习与应用总结】19: iterator traits]()

# 函数对象-function objects (or functors for short)

- [【C++ STL学习与应用总结】16: 迭代器综述]()


# 算法-algorithm



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


