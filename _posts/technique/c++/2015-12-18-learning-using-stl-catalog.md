---
layout: post
title: "【C++ STL应用与实现】目录"
category: c++
tags: [stl]
description: ""
---

#前言

这篇文章是《STL应用与实现》系列的目录, 也是这系列文章的写作计划。STL的总结主要分成四大块：容器、迭代器、函数对象和算法。

每个大块细分成的每个叶子节点就对应着一篇文章，文章标题在目录里以超链接的形式展现，作为一个索引。

已经完成的文章，我会在后面加上<font color="green">【完成】</font>标识。<font>跳转不过去的就是未完成的文章，作为写作计划</font>。

下面的“目录”很多是用表格的形式，这样也便于一目了然看到某个大块下有哪些子节点，比如算法这一块，就用表格比较直观，采用《C++标准程序库》的分类方式，每个算法类别是一个表。

目录里的文章不定期更新，用到了哪个特性或是有空的时候就写一点。

# 缘起、概览

| **类型**    | **文章链接**                                                                                                                                     |
| --------    | ------------                                                                                                                                     |
| `beginning` | [【C++ STL应用与实现】0: 感恩STL——STL, ACM和年轻的我们](http://blog.csdn.net/elloop/article/details/50340623)<font color="green">【完成】</font> |
| `概览`      | [【C++ STL应用与实现】1: STL概览和分类](http://blog.csdn.net/elloop/article/details/50321635)<font color="green">【完成】</font>                 |


<!--more-->

# 容器 (container)

**1. 序列式容器**

| **类型**       | **文章链接**                                                                                                                                               |
| --------       | ------------                                                                                                                                               |
| `vector`       | [【C++ STL应用与实现】2: 如何使用std::vector](http://blog.csdn.net/elloop/article/details/54780873)<font color="green">【完成】</font>                     |
| `vector<bool>` | [【C++ STL应用与实现】3: 如何使用`std::vector<bool>`]()                                                                                                    |
| `deque`        | [【C++ STL应用与实现】4: 如何使用std::deque]()                                                                                                             |
| `array`        | [【C++ STL应用与实现】5: 如何使用std::array (since c++11)](http://blog.csdn.net/elloop/article/details/50390870)<font color="green">【完成】</font>        |
| `list`         | [【C++ STL应用与实现】6: 如何使用std::list]()                                                                                                              |
| `forward_list` | [【C++ STL应用与实现】7: 如何使用std::forward_list (since c++11)](http://blog.csdn.net/elloop/article/details/50405783)<font color="green">【完成】</font> |


<!--more-->

**2. 关联式容器(associative containers)**


| **类型**        | **文章链接**                                                |
| --------        | ------------                                                |
| `set(multiset)` | [【C++ STL应用与实现】8: 如何使用std::set和std::multiset]() |
| `map(multimap)` | [【C++ STL应用与实现】9: 如何使用std::map和std::multimap]() |


**3. 哈希表(hash table)** (since c++11)


|**类型**|**文章链接**|
|--------|------------|
|`unordered_set(unordered_multiset)`|[【C++ STL应用与实现】10: 如何使用unordered_set和unordered_multiset (since c++11)]()|
|`unordered_map(unordered_multimap)`|[【C++ STL应用与实现】11: 如何使用unordered_map和unordered_multimap (since c++11)]()|


**4. 容器适配器(container adapters)**


|**类型**|**文章链接**|
|--------|------------|
|`stack`|[【C++ STL应用与实现】12: 如何使用std::stack]()|
|`queue and priority_queue`|[【C++ STL应用与实现】13: 如何使用std::queue和std::priority_queue]()|
|`bitset`|[【C++ STL应用与实现】14: 如何使用std::bitset]()|


# std::string 


|**类型**|**文章链接**|
|--------|------------|
|`std::string`|[【C++ STL应用与实现】15: 使用std::string]()|


# 迭代器-iterator


|**类型**|**文章链接**|
|--------|------------|
|`迭代器综述`|[【C++ STL应用与实现】16: 迭代器综述](http://blog.csdn.net/elloop/article/details/50414538)<font color="green">【完成】</font>|
|`迭代器辅助函数`|[【C++ STL应用与实现】17: 使用迭代器辅助函数](http://blog.csdn.net/elloop/article/details/50410765)<font color="green">【完成】</font>|
|`iterator adapter`|[【C++ STL应用与实现】18: 使用迭代器适配器](http://blog.csdn.net/elloop/article/details/50423589)<font color="green">【完成】</font>|
|`iterator traits`|[【C++ STL应用与实现】19: 迭代器特性iterator traits](http://blog.csdn.net/elloop/article/details/50430920)<font color="green">【完成】</font>|


# 函数对象-function objects (or functors for short)


|**类型**|**文章链接**|
|--------|------------|
|`functors`|[【C++ STL应用与实现】20: 函数对象综述]()|
|`predefined functors`|[【C++ STL应用与实现】21: 如何使用预定义的函数对象, C++98&C++11]()|
|`functional composition - bind`|[【C++ STL应用与实现】22: 函数组合之1：如何使用std::bind (since C++11))](http://blog.csdn.net/elloop/article/details/50323113)<font color="green">【完成】</font>|
|`functional composition - mem_fn`|[【C++ STL应用与实现】23: 函数组合之2：如何使用std::mem_fn (since C++11))](http://blog.csdn.net/elloop/article/details/50375820)<font color="green">【完成】</font>|
|`unary compose function object adapters`|[【C++ STL应用与实现】24: 一元组合函数适配器]()|
|`binary compose function object adapters`|[【C++ STL应用与实现】25: 二元组合函数适配器]()|


# 算法-algorithm


**1. 非变动类算法(nonmodifying algorithms)**


|**类型**|**文章链接**|
|--------|------------|
|`for_each`|[【C++ STL应用与实现】26: 如何使用std::for_each](http://blog.csdn.net/elloop/article/details/50383478)<font color="green">【完成】</font>|
|`count`|[【C++ STL应用与实现】27: 如何使用std::count]()|
|`count_if`|[【C++ STL应用与实现】28: 如何使用std::count_if]()|
|`min_element`|[【C++ STL应用与实现】29: 如何使用std::min_element]()|
|`max_element`|[【C++ STL应用与实现】30: 如何使用std::max_element]()|
|`find_if`|[【C++ STL应用与实现】31: 如何使用std::find_if]()|
|`search_n`|[【C++ STL应用与实现】32: 如何使用std::search_n]()|
|`search`|[【C++ STL应用与实现】33: 如何使用std::search]()|
|`find_end`|[【C++ STL应用与实现】34: 如何使用std::find_end]()|
|`find_first_of`|[【C++ STL应用与实现】35: 如何使用std::find_first_of]()|
|`adjacent_find`|[【C++ STL应用与实现】36: 如何使用std::adjacent_find]()|
|`equal`|[【C++ STL应用与实现】37: 如何使用std::equal]()|
|`mismatch`|[【C++ STL应用与实现】38: 如何使用std::mismatch]()|
|`lexicographical_compare`|[【C++ STL应用与实现】39: 如何使用std::lexicographical_compare]()|


**2. 变动类算法(modifying algorithms)**


|**类型**|**文章链接**|
|--------|------------|
|`for_each`|[【C++ STL应用与实现】26: 如何使用std::for_each](http://blog.csdn.net/elloop/article/details/50383478)<font color="green">【完成】</font>|
|`copy`|[【C++ STL应用与实现】40: 如何使用std::copy]()|
|`copy_backward`|[【C++ STL应用与实现】41: 如何使用std::copy_backward]()|
|`transform`|[【C++ STL应用与实现】42: 如何使用std::transform]()|
|`merge`|[【C++ STL应用与实现】43: 如何使用std::merge]()|
|`swap_ranges`|[【C++ STL应用与实现】44: 如何使用std::swap_ranges]()|
|`fill`|[【C++ STL应用与实现】45: 如何使用std::fill]()|
|`fill_n`|[【C++ STL应用与实现】46: 如何使用std::fill_n]()|
|`generate`|[【C++ STL应用与实现】47: 如何使用std::generate]()|
|`replace`|[【C++ STL应用与实现】48: 如何使用std::replace]()|
|`replace_if`|[【C++ STL应用与实现】49: 如何使用std::replace_if]()|
|`replace_copy`|[【C++ STL应用与实现】50: 如何使用std::replace_copy]()|
|`replace_copy_if`|[【C++ STL应用与实现】51: 如何使用std::replace_copy_if]()|


**3. 移除类算法(removing algorithms)**


|**类型**|**文章链接**|
|--------|------------|
|`remove`|[【C++ STL应用与实现】52: 如何使用std::remove]()|
|`remove_if`|[【C++ STL应用与实现】53: 如何使用std::remove_if]()|
|`remove_copy`|[【C++ STL应用与实现】54: 如何使用std::remove_copy]()|
|`remove_copy_if`|[【C++ STL应用与实现】55: 如何使用std::remove_copy_if]()|
|`unique`|[【C++ STL应用与实现】56: 使用std::unique删除重复元素](http://blog.csdn.net/elloop/article/details/7694505)<font color="green">【完成】</font>|
|`unique_copy`|[【C++ STL应用与实现】57: 如何使用std::unique_copy]()|


**4. 变序类算法(mutating algorithms)**


|**类型**|**文章链接**|
|--------|------------|
|`reverse`|[【C++ STL应用与实现】58: 如何使用std::reverse]()|
|`reverse_copy`|[【C++ STL应用与实现】59: 如何使用std::reverse_copy]()|
|`rotate`|[【C++ STL应用与实现】60: 如何使用std::rotate]()|
|`rotate_copy`|[【C++ STL应用与实现】61: 如何使用std::rotate_copy]()|
|`next_permutation`|[【C++ STL应用与实现】62: 如何使用std::next_permutation](http://blog.csdn.net/elloop/article/details/53958797)<font color="green">【完成】</font>|
|`prev_permutation`|[【C++ STL应用与实现】63: 如何使用std::prev_permutation](http://blog.csdn.net/elloop/article/details/53958797)<font color="green">【完成】</font>|
|`random_shuffle`|[【C++ STL应用与实现】64: 如何使用std::random_shuffle和shuffle (since C++11)](http://blog.csdn.net/elloop/article/details/50397618)<font color="green">【完成】</font>|
|`partition`|[【C++ STL应用与实现】65: 如何使用std::partition]()|
|`stable_partition`|[【C++ STL应用与实现】66: 如何使用std::stable_partition]()|


**5. 排序类算法(sorting algorithms)**


|**类型**|**文章链接**|
|--------|------------|
|`sort`|[【C++ STL应用与实现】67: 如何使用std::sort]()|
|`stable_sort`|[【C++ STL应用与实现】68: 如何使用std::stable_sort]()|
|`partial_sort`|[【C++ STL应用与实现】69: 如何使用std::partial_sort]()|
|`partial_sort_copy`|[【C++ STL应用与实现】70: 如何使用std::partial_sort_copy]()|
|`nth_element`|[【C++ STL应用与实现】71: 如何使用std::nth_element]()|
|`partition`|[【C++ STL应用与实现】65: 如何使用std::partition]()|
|`stable_partition`|[【C++ STL应用与实现】66: 如何使用std::stable_partition]()|
|`make_heap`|[【C++ STL应用与实现】72: 如何使用std::make_heap](http://blog.csdn.net/elloop/article/details/53402209)<font color="green">【完成】</font>|
|`push_heap`|[【C++ STL应用与实现】73: 如何使用std::push_heap](http://blog.csdn.net/elloop/article/details/53402209)<font color="green">【完成】</font>|
|`pop_heap`|[【C++ STL应用与实现】74: 如何使用std::pop_heap](http://blog.csdn.net/elloop/article/details/53402209)<font color="green">【完成】</font>|
|`sort_heap`|[【C++ STL应用与实现】75: 如何使用std::sort_heap](http://blog.csdn.net/elloop/article/details/53402209)<font color="green">【完成】</font>|


**6. 已序区间类算法(sorted range algorithms)**


|**类型**|**文章链接**|
|--------|------------|
|`binary_search`|[【C++ STL应用与实现】76: 如何使用std::binary_search]()|
|`includes`|[【C++ STL应用与实现】77: 如何使用std::includes]()|
|`lower_bound`|[【C++ STL应用与实现】78: 如何使用std::lower_bound]()|
|`upper_bound`|[【C++ STL应用与实现】79: 如何使用std::upper_bound]()|
|`equal_range`|[【C++ STL应用与实现】80: 如何使用std::equal_range]()|
|`merge`|[【C++ STL应用与实现】43: 如何使用std::merge]()|
|`set_union`|[【C++ STL应用与实现】81: 如何使用std::set_union]()|
|`set_intersection`|[【C++ STL应用与实现】82: 如何使用std::set_intersection]()|
|`set_difference`|[【C++ STL应用与实现】83: 如何使用std::set_difference]()|
|`set_symetric_difference`|[【C++ STL应用与实现】84: 如何使用std::set_symetric_difference]()|
|`inplace_merge`|[【C++ STL应用与实现】85: 如何使用std::inplace_merge]()|


**7. 数值类算法(numerci algorithms)**


|**类型** | **文章链接** |
|-------- | ------------ |
|`accumulate`|[【C++ STL应用与实现】86: 如何使用std::accumulate](http://blog.csdn.net/elloop/article/details/50349668)<font color="green">【完成】</font>|
|`inner_product`|[【C++ STL应用与实现】87: 如何使用std::inner_product]()|
|`adjacent_difference`|[【C++ STL应用与实现】88: 如何使用std::adjacent_difference]() |
|`partial_sum`|[【C++ STL应用与实现】89: 如何使用std::partial_sum]() |


# Smart Pointers


| **类型**     | **文章链接**                                                           |
| --------     | ------------                                                           |
| `auto_ptr`   | [【C++ STL应用与实现】90: 如何使用std::auto_ptr]()                 |
| `shared_ptr` | [【C++ STL应用与实现】91: 如何使用std::shared_ptr (since C++11)]() |
| `unique_ptr` | [【C++ STL应用与实现】92: 如何使用std::unique_ptr (since C++11)]() |
| `weak_ptr`   | [【C++ STL应用与实现】93: 如何使用std::weak_ptr (since C++11)]()   |


# Allocator


| **类型**        | **文章链接**                                                                                           |
| --------        | ------------                                                                                           |
| `Allocator综述` | [【C++ STL应用与实现】94: 内存分配器Allocator综述]()                                               |
| `Allocator`     | [【C++ STL应用与实现】95: 如何使用Allocator](http://blog.csdn.net/elloop/article/details/52713601)<font color="green">【完成】</font> |


---------------------------



**欢迎访问[github博客](http://elloop.github.io)，与本站同步更新**


