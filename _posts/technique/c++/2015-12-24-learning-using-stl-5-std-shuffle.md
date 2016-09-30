---
layout: post
title: "【C++ STL应用与实现】64: 如何使用shuffle和random_shuffle : 洗牌 (since C++11)"
category: c++
tags: [stl]
description: ""
---

**本系列文章的目录在这里：[目录](http://blog.csdn.net/elloop/article/details/50357205). 通过目录里可以对STL总体有个大概了解**

#前言

本文介绍了STL中的变序类算法(mutating algorithm)里面的洗牌算法：std::random_shuffle和std::shuffle.

random_shuffle算法在C++11之前就已经存在，C++11之后由于右值引用的引入，它的使用范围变大了。

shuffle算法则是从C++11之后才开始出现，可以与随机数和分布库一起使用。

与本系列的其他文章一样，本文介绍该最新的使用方法，比如random_shuffle在C++11以后接收的第三个参数从左值引用改成了右值引用，使得能够传入临时对象和函数，也就是说其使用范围括大了。

<!--more-->

# shuffle的三种形式

{% highlight c++ %}
template <typename RandomAccessIterator, typename UniformRandomNumberGenerator>
  void shuffle (RandomAccessIterator first, RandomAccessIterator last, UniformRandomNumberGenerator&& g);

template <typename RandomAccessIterator>
  void random_shuffle (RandomAccessIterator first, RandomAccessIterator last);

template <typename RandomAccessIterator, typename RandomNumberGenerator>
  void random_shuffle (RandomAccessIterator first, RandomAccessIterator last,
                       RandomNumberGenerator&& gen);
{% endhighlight %}

shuffle是从C++11开始支持的，作用是使用一个随机数引擎来打乱[first, last)之间元素的顺序，关于随机数引擎需要参考`<random>`头文件及相关资料.

random_shuffle有两种形式：

第一种，使用默认的随机数生成器(比如c语言中的rand())来打乱[first, last)之间的元素顺序。默认随机数生成器和具体的编译器实现有关。

第二种，使用指定的随机器生成函数gen来打乱[first, last)之间元素的顺序。gen接受一个difference_type类型的参数n，返回一个随机数x，x的范围在[0, n)之间.

其等价的实现：

{% highlight c++ %}
template <typename RandomAccessIterator, typename UniformRandomNumberGenerator>
void shuffle (RandomAccessIterator first, 
              RandomAccessIterator last, 
              UniformRandomNumberGenerator&& g)
{
    for (auto i=(last-first)-1; i>0; --i) 
    {
        std::uniform_int_distribution<decltype(i)> d(0,i);
        swap (first[i], first[d(g)]);
    }
}

template <typename RandomAccessIterator, typename RandomNumberGenerator>
  void random_shuffle (RandomAccessIterator first, RandomAccessIterator last,
                       RandomNumberGenerator& gen)
{
    iterator_traits<RandomAccessIterator>::difference_type i, n;
    n = (last-first);
    for (i=n-1; i>0; --i) 
    {
        swap (first[i],first[gen(i+1)]);
    }
}
{% endhighlight %}

# 基本用法

如果不需要特殊的处理需求，那么使用默认的随机数生成器就能简单实现的随机洗牌效果，下面给出代码示例：

## 使用默认的随机数生成器来shuffle

{% highlight c++ %}
RUN_GTEST(ShuffleTest, Default, @);

array<int, 10> a = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
printContainer(a, "a: ");

random_shuffle(a.begin(), a.end());     // use default rand().
printContainer(a, "a: ");

sort(a.begin(), a.end());               // 恢复顺序
printContainer(a, "a: ");

default_random_engine defaultEngine;    // default engine.
shuffle(a.begin(), a.end(), defaultEngine);
printContainer(a, "a: ");

END_TEST;
{% endhighlight %}

输出：

{% highlight c++ %}
a: 1 2 3 4 5 6 7 8 9 10
a: 9 2 10 3 1 6 8 4 5 7
a: 1 2 3 4 5 6 7 8 9 10
a: 5 1 4 2 6 8 7 3 10 9
{% endhighlight %}

其中对于default_random_engine的使用，还可以指定种子seed，比如：

{% highlight c++ %}
// 使用系统时钟作为种子
unsigned seed = chrono::system_clock::now().time_since_epoch().count();
shuffle(a.begin(), a.end(), default_random_engine(seed));
{% endhighlight %}

更多的关于random engine的内容请参考`<random>`中的介绍。

基本的用法已经能满足一些对随机性要求不高的场合，对于上面默认随机数生成器只需知道，rand()和默认的随机生成器产生的随机数是服从均匀分布的(uniform distribution), 又叫做矩形分布，每个元素的概率是1/(max - min).

## 使用自定义的generator来shuffle元素

{% highlight c++ %}
// 自定义的generator, 用来random_shuffle.
class SelfGenerator
{
public:
    ptrdiff_t operator() (ptrdiff_t max)
    {
        double temp;
        temp = static_cast<double>(rand()) / static_cast<double>(RAND_MAX);
        return static_cast<ptrdiff_t>(temp * max);
    }
};

//----------------------- self-written generator  ----------------------
RUN_GTEST(ShuffleTest, ShuffleWithGenerator, @);

array<int, 10> a = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
printContainer(a, "a: ");

SelfGenerator sg;
random_shuffle(a.begin(), a.end(), sg);

printContainer(a, "a: ");

END_TEST;
{% endhighlight %}

某次执行的输出：

{% highlight c++ %}
a: 1 2 3 4 5 6 7 8 9 10
a: 9 2 7 10 4 5 1 3 8 6
{% endhighlight %}

《C++ 标准库》的作者说使用自定义的generator比直接调用rand()要好，自定义的generator是一个对象，它内部封装了自己的状态，不会像rand()那样使用一个静态变量保存其状态，rand()这样“天生就不是线程安全的，无法同时有两个独立互不干扰的随机数流”.

# shuffle的时间复杂度

因为算法内部进行n - 1次交换，所以时间复杂度为O(n).

# 源码和参考链接

- [shuffle_random_shuffle_test.cpp](https://github.com/elloop/CS.cpp/blob/master/TotalSTL/algorithm/mutating/shuffle_random_shuffle_test.cpp)

- [shuffle](http://www.cplusplus.com/reference/algorithm/shuffle/?kw=shuffle)

- [random_shuffle](http://www.cplusplus.com/reference/algorithm/random_shuffle/?kw=random_shuffle)

- [`<random>`](http://www.cplusplus.com/reference/random/)

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**欢迎访问[github博客](http://elloop.github.io)，与本站同步更新**



