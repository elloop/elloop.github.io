---
layout: post
title: "【C++ STL应用与实现】16: 迭代器综述"
category: c++
tags: [stl]
description: ""
---

**本系列文章的目录在这里：[目录](http://blog.csdn.net/elloop/article/details/50357205). 通过目录里可以对STL总体有个大概了解**

#前言

本文介绍了STL中的迭代器的概念和五种类别的迭代器：`Output iterator`, `Input iterator`, `Forward iterator`, `Bidirectional iterator`, `Random-access iterator`.

迭代器是为了表示容器中某个元素位置这个概念而产生的，有一般到特殊("高级")可以把它分成五类，如下表所示：

|**iterator分类**|**能力**|**由谁提供**|
|----------------|--------|------------|
|Output iterator 输出迭代器|向前写|ostream, inserter|
|Input Input 输入迭代器|向前读, 每个元素只能读一次|istream|
|Forward iterator 前向迭代器|向前读|`forward_list`, unordered containers(无序容器)|
|Bidirectional iterator双向迭代器|可向前向后两个方向读取|list, set(multiset), map(multimap)|
|Random-access iterator 随机访问迭代器|随机读取|array, vector, deque, string, C风格数组|


STL中的各种算法，包括`<algorithm>`中的以及各种容器的成员函数，还有各种功能函数，比如迭代器辅助函数(advance, next, prev, distance, iter_swap)等，有很多都是以迭代器作为输入参数的，这些函数中，形参类型越是“一般”，说明其使用范围越大。这里所说的“一般”指的就是上面5类迭代器中“低级”的迭代器，比如Input iterator和Output iterator就比Forward iterator一般，Forward iterator比Bidirectional iterator一般，Bidirectional iterator又比Random-access iterator一般。

假设有两个算法，f和g，f接受Input iterator类型的参数，而g接受Random-access类型的参数，那么f的作用范围就比g大，因为所有的Forward, Bidirectional和Random-access迭代器都可以作为f的参数，而g只能使用Random-access参数。

<!--more-->

# Output iterator 输出迭代器

|**支持的操作**|**功能描述**|
|----------------|------------|
|*iter = value | 把value写入迭代器iter所指向位置的元素|
|++iter| 向前移动一个位置，返回新的位置|
|iter++| 向前移动一个位置，返回旧的位置|
|TYPE(iter)| 拷贝构造函数|


# Input iterator 输入迭代器

一个纯粹的Input iterator 类型的迭代器，只能挨个元素向前只读地访问元素. 典型示例是读取标准键盘输入的迭代器，每个元素只能读取一次，且只能向前, 只能读取，不能修改。


|**支持的操作**|**功能描述**|
|----------------|------------|
|*iter| 读取元素|
|iter->member| 访问iter出元素的成员|
|++iter| 向前移动一个位置，返回新元素位置|
|iter++| 向前移动一个位置, 不要求返回值。通常是返回旧元素位置|
|iter1 == iter2 | 判等|
|iter1 != iter2 | 判不等|
|TYPE(iter)| 拷贝构造函数|


# Forward iterator 前向迭代器

Forward iterator 是一种特殊的Input iterator, 它在Input iterator的基础上提供了额外的保证：

它保证两个指向同一个元素的迭代器pos1, pos2， pos1 == pos2 返回true，并且对pos1, pos2调用自增操作符之后，二者仍然指向相同元素。


|**支持的操作**|**功能描述**|
|----------------|------------|
|*iter| 读取元素|
|iter->member| 访问iter出元素的成员|
|++iter| 向前移动一个位置，返回新元素位置|
|iter++| 向前移动一个位置, 不要求返回值。通常是返回旧元素位置|
|iter1 == iter2 | 判等|
|iter1 != iter2 | 判不等|
|TYPE()| 使用默认构造函数创建一个iterator|
|TYPE(iter)| 拷贝构造函数|
|iter1 = iter2 | 赋值|


# Bidirectional iterator 双向迭代器

Bidirectional iterator是提供了回头访问能力的Forward iterator, 在Forward iterator支持的操作基础上，它提供了以下两个“回头”操作：


|**支持的操作**|**功能描述**|
|----------------|------------|
|--iter| 回头走一步，返回新位置|
|iter--| 回头走一步，返回旧位置|


# Random-access iterator 随机访问迭代器

Random-access iterator是功能最强大的迭代器类型，在Bidirectional iterator基础上提供了随机访问的功能，因此支持迭代器运算，类比指针运算。


|**支持的操作**|**功能描述**|
|----------------|------------|
|iter[n]| 取第n个位置的元素|
|iter += n| 移动n个位置, 向前后取决于n的符号|
|iter -= n| 移动n个位置, 向前后取决于n的符号|
|iter + n| 返回移动n个位置后的迭代器|
|iter - n| 返回移动n个位置后的迭代器|
|iter1 - iter2| 返回iter1和iter2间的距离|
|iter1 < iter2| iter1比iter2考前？|
|iter1 <= iter2| iter1不比iter2靠后？|
|iter1 > iter2| iter1比iter2靠后？|
|iter1 >= iter2| iter1不比iter2靠前？|


# 参考链接

- [`iter_swap`](http://www.cplusplus.com/reference/algorithm/iter_swap/?kw=iter_swap)

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**欢迎访问[github博客](http://elloop.github.io)，与本站同步更新**



