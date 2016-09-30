---
layout: post
title: "【C++ STL应用与实现】17: 如何使用迭代器辅助函数"
category: c++
tags: [stl]
description: ""
---

**本系列文章的目录在这里：[目录](http://blog.csdn.net/elloop/article/details/50357205). 通过目录里可以对STL总体有个大概了解**

#前言

本文介绍了STL中的迭代器辅助函数的用法及注意事项，这些迭代器辅助函数包括：`advance`, `next` (since C++11), `prev` (since C++11), `distance`, `iter_swap`.

使用这些辅助函数需要包含头文件：`#include <iterator>`

advance, next, prev, distance这四个辅助函数使得所有迭代器都拥有类似随机访问迭代器的特性，比如advance(iter, n)可以使得前向迭代器直接向前移动n个位置，类似随机迭代器的iter+n操作。

# 使用迭代器辅助函数来实现独立于迭代器类型的代码

这四个辅助函数提供了一层新的抽象层，使得代码可以独立于迭代器的类型。使用这四个辅助函数来操作迭代器可以让我在更改容器类型和迭代器类型的时候不用修改迭代器访问的代码。如果我不使用这几个辅助函数，比如我对一个随机迭代器的操作，写成`newPos = pos + 10`, 这就要求只有随机迭代器才会通过编译。而若使用`newPos = next(pos, 10)`, 那么就不会有随机迭代器的限制。即使我中途改变了容器和迭代器的类型，也不用修改这段代码。值得一提的是，使用这几个辅助函数并不会造成性能损失，因为其内部会根据迭代器的`iterator traits`采取不同的策略来移动迭代器，对随机迭代器调用这些函数是一个常量时间的操作，对前向和双向迭代器则和自己手写循环一样，是个线性时间的操作。

# 迭代器辅助函数并不检查范围越界，需调用者自行确保迭代器的有效性

因为这些函数只接受一个迭代器参数，无法知晓这个迭代器所在容器的信息，也就无法知道是否迭代器到达了begin()之前，或者到了end(), 它只会傻傻的按照你指定的移动次数一直++iter，或者iter+n。而我们知道，对end()进行++操作是未定义的行为。因此使用这些函数的时候，全靠我们调用者自己控制迭代器的合法性。

<!--more-->

# advance

原型：

void advance(InputIterator &pos, Distance n);

从原型看到，advance没有返回值，它以引用方式来接收并修改pos，使其向前移动n个位置（或者向后, n可以是负数，但此时要保证pos至少是个双向迭代器）。

代码示例：

{% highlight c++ %}
//-----------------------  Advance  ----------------------
RUN_GTEST(AuxiliaryIterFuncTest, Advance, @);

array<int, 5> a = {1, 2, 3, 4, 5};
printContainer(a, "a: ");       // 1 2 3 4 5

auto iter = a.begin();
EXPECT_EQ(1, *iter);

advance(iter, 1);           // iter is changed.
EXPECT_EQ(2, *iter);

advance(iter, 2);
EXPECT_EQ(4, *iter);

advance(iter, -1);          // go backward 1.
EXPECT_EQ(3, *iter);

advance(iter, -2);          // go backward 2.
EXPECT_EQ(1, *iter);


iter = a.begin();
pln("advance pass the end()");
//advance(iter, 100);       // error: undefined behaviour.

//advance(iter, -100);      // error: undefined behaviour.

END_TEST;
{% endhighlight %}

# next (since C++11)

原型：

ForwardIterator next(ForwardIterator pos, Distance n = 1);

- Distance这种类型 = `std::iterator_traits<ForwardIterator>::difference_type`

- next内部调用了advance(pos, n), 这里pos是传入实参的副本，所以next不会修改实参，它返回对实参副本调用advance(pos, n)后的迭代器位置。
因为它是借助advance来实现其功能，所以上面对advance的使用限制也都适用于它，比如要想往前移动，那么就要需要pos至少是双向迭代器。

示例代码：

{% highlight c++ %}
//-----------------------  next  ----------------------
// next(pos, n) calls advance(pos, n) for an internal temporary object.
RUN_GTEST(AuxiliaryIterFuncTest, Next, @);

array<int, 5> a = { 1, 2, 3, 4, 5 };
printContainer(a, "a: ");

auto iter = a.begin();
EXPECT_EQ(1, *iter);

auto pos2 = next(iter, 1);                  // iter is not changed.
EXPECT_EQ(1, *iter);
EXPECT_EQ(2, *pos2);

auto pos3 = next(pos2);                     // default n = 1
EXPECT_EQ(2, *pos2);
EXPECT_EQ(3, *pos3);

auto pos5 = next(iter, 4);                  // iter + 4
EXPECT_EQ(5, *pos5);

auto pos4 = next(pos5, -1);
EXPECT_EQ(4, *pos4);

auto pos1 = next(pos5, -4);
EXPECT_EQ(1, *pos1);

//auto posPassEnd = next(iter, 100);          // error, undefined behaviour.
//auto posBeforeBegin = next(iter, -100);     // error, undefined behaviour.

END_TEST;
{% endhighlight %}

# prev (since C++11)

原型：

BidirectionalIterator prev(BidirectionalIterator pos, Distance n = 1);

- prev不修改pos实参的值，它在内部使用一个临时对象pos来调用advance(pos, -n), 返回pos向前移动n个位置后的位置。

- prev对参数pos的要求是：至少是一个BidirectionalIterator, 即至少是双向迭代器。

代码示例：

{% highlight c++ %}
//-----------------------  prev ----------------------
// prev(pos, n) calls advance(pos, -n) for an internal temporary object.
RUN_GTEST(AuxiliaryIterFuncTest, Prev, @);

array<int, 5> a = { 1, 2, 3, 4, 5 };
printContainer(a, "a: ");

auto last = prev(a.end());              // call prev with end() is ok.
EXPECT_EQ(5, *last);

auto last2 = prev(a.end(), 2);          // call prev with end() is ok.
EXPECT_EQ(4, *last2);

auto iter = a.begin();                  
auto pos2 = prev(iter, -1);             // move forward use prev.
EXPECT_EQ(2, *pos2);

//auto posBeforeBegin = prev(a.begin(), 1);    // error: undefined behaviour.

END_TEST;
{% endhighlight %}

# distance

原型：

Distance distance(InputIterator pos1, InputIterator pos2);

- Distance的类型是: `iterator_traits<InputIterator>::difference_type`

- pos1, pos2必须是同一个容器的迭代器

代码示例：

{% highlight c++ %}
//-----------------------  distance ----------------------
RUN_GTEST(AuxiliaryIterFuncTest, Distance, @);

array<int, 5> a = { 1, 2, 3, 4, 5 };
printContainer(a, "a: ");

auto pos2 = find(a.begin(), a.end(), 2);
auto pos5 = find(a.begin(), a.end(), 5);

//array<int, 5>::difference_type dis = distance(pos2, pos5);

auto dis = distance(pos2, pos5);
psln(dis);                              // dis = 3
EXPECT_EQ(5 - 2, dis);

auto negativeDis = distance(pos5, pos2);
psln(negativeDis);                      // negativeDis = -3
EXPECT_EQ(2 - 5, negativeDis);

END_TEST;
{% endhighlight %}

# `iter_swap`

原型：

`void iter_swap(ForwardIterator pos1, ForwardIterator pos2);`

- 交换pos1和pos2位置的元素值

- pos1和pos2可以是不同类型的迭代器，但是*pos1和*pos2的值必须是可赋值的。

代码示例：

{% highlight c++ %}
//-----------------------  iter_swap ----------------------
RUN_GTEST(AuxiliaryIterFuncTest, Iter_swap, @);

array<int, 5> a = { 1, 2, 3, 4, 5 };
printContainer(a, "a: ");               // 1 2 3

// 交换第一个元素和第二个元素
iter_swap(a.begin(), next(a.begin()));
printContainer(a, "a: ");               // 2 1 3

// 使用不同容器的迭代器

list<int> l = { 10, 11, 12};
printContainer(l, "l: ");               // l: 10 11 12

iter_swap(a.begin(), l.begin());
printContainer(a, "after swap, a: ");   // 10 1 3
printContainer(l, "after swap, l: ");   // 2 11 12

END_TEST;
{% endhighlight %}

# 源码和参考链接

- [`auxiliary_iterator_func_test.cpp`](https://github.com/elloop/CS.cpp/blob/master/TotalSTL/src/iterator/auxiliary_functions/auxiliary_iterator_func_test.cpp)

- [`advance`](http://www.cplusplus.com/reference/iterator/advance/?kw=advance)

- [next](http://www.cplusplus.com/reference/iterator/next/?kw=next)

- [`prev`](http://www.cplusplus.com/reference/iterator/prev/?kw=prev)

- [`distance`](http://www.cplusplus.com/reference/iterator/distance/?kw=distance)

- [`iter_swap`](http://www.cplusplus.com/reference/algorithm/iter_swap/?kw=iter_swap)

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**欢迎访问[github博客](http://elloop.github.io)，与本站同步更新**



