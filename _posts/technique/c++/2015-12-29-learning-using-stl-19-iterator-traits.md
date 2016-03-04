---
layout: post
title: "【C++ STL学习与应用总结】19: 迭代器特性-iterator traits"
category: c++
tags: [stl]
description: ""
---

**本系列文章的目录在这里：[目录](http://blog.csdn.net/elloop/article/details/50357205). 通过目录里可以对STL总体有个大概了解**

#前言

本文介绍了STL中的迭代器相关的类型和特性，它们用来定义和区分不同的迭代器类型。如iterator tag作为迭代器的“标签”用来区分迭代器的类型；iterator traits定义了所有类型的迭代器都应该有的公共信息。那标准库为什么提供这些东西呢？答案是我们可以根据这些信息来编写泛型代码，在泛型代码里根据iterator traits来判定迭代器的类型以做相应处理、可以自己定义迭代器实现自定义的迭代器操作。

# iterator tag

下面的代码描述了五中类型的迭代器的“标签”，其中有几种类型的继承关系, 这包含了面向对象的“IS A”的含义。例如，从`forward_iterator_tag`和`bidirectional_terator_tag`的继承关系可知，它们分别对应的迭代器类型，Bidirectional Iterator “IS A” Forward Iterator. 意味着可以用Forward Iterator 的地方，丢一个Bidirectional Iterator过去也是可以的。

<!--more-->

{% highlight c++ %}
namespace std
{
    struct output_iterator_tag {};

    struct input_iterator_tag {};

    struct forward_iterator_tag : public input_iterator_tag {};

    struct bidirectional_iterator_tag : public forward_iterator_tag {};

    struct random_access_iterator_tag : public bidirectional_iterator_tag {};
}
{% endhighlight %}

# iterator traits

iterator traits ：迭代器特性，定义了所有迭代器都有的公共类型信息:

{% highlight c++ %}
namespace std
{
    template <typename T>
    struct iterator_traits
    {
        typedef typename T::iterator_category   iterator_category;
        typedef typename T::value_type          value_type;
        typedef typename T::difference_type     difference_type;
        typedef typename T::pointer             pointer;
        typedef typename T::reference           reference;
    };
}
{% endhighlight %}

有了`iterator_traits`, 我就可以这样, 定义一个迭代器(类型为T)所指向的值类型的变量：

`std::iterator_traits<T>::value_type val;`

# 使用iterator traits来编写泛型代码

## 使用迭代器定义的数据类型, 如 `value_type`

在算法内部使用迭代器定义的数据类型`value_type`

{% highlight c++ %}
template <typename T>
void shift_left(T beg, T end)
{
    typedef typename std::iterator_traits<T>::value_type value_type;

    if (beg != end) 
    {
        value_type temp(*beg);
        // other operations...
    }
}
{% endhighlight %}

## 使用迭代器分类 `iterator_category`

分两步：

1. 在定义的模板函数f内部，调用另一个以`iterator_category`作为额外参数的函数f, 完成差异化处理；

2. 实现第一步中重载的f，使用不同类型的`iterator_category`参数以针对特殊类型迭代器做特殊处理。

{% highlight c++ %}
template <typename Iterator>
void f(Iterator beg, Iterator end)
{
    f(beg, end, std::iterator_traits<Iterator>::iterator_category());
}

// special f for random-access iterators.
template <typename RandomIterator>
void f(RandomIterator beg, RandomIterator end, std::random_access_iterator_tag)
{
    //...
}

// special f for bidirectional terators.
template <typename BidirectionalIterator>
void f(BidirectionalIterator beg, BidirectionalIterator end, std::bidirectional_iterator_tag)
{
    // ...
}
{% endhighlight %}

上面两个特殊的重载版本的f分别针对随机迭代器和双向迭代器做特殊处理。由于前面介绍的iterator tag的继承关系，可以只针对某个父类定义一个f，该父类的所有子类都可以共用同一个f。比如下面的例子:

distance() 函数的实现：

{% highlight c++ %}
// 第一步，定义一个模板函数，接受一对迭代器, 使用`iterator_category`来转发给重载函数。
template <typename Iterator>
typename std::iterator_traits<Iterator>::difference_type distance(Iterator pos1, Iterator pos2)
{
    return distance(pos1, pos2, std::iterator_traits<Iterator>::iterator_category());
}

// 第二步，实现重载的特殊版本函数
// 1. for random-access iterators.
template <typename RandomIterator>
typename std::iterator_traits<RandomIterator>::difference_type
distance(RandomIterator pos1, RandomIterator pos2, std::random_access_iterator_tag)
{
    return pos2 - pos1;
}

// 2. for other iterators.
template <typename InputIterator>
typename std::iterator_traits<InputIterator>::difference_type
distance(InputIterator pos1, InputIterator pos2, std::input_iterator_tag)
{
    typename std::iterator_traits<InputIterator>::difference_type d;
    for (d=0; pos1 != pos2; ++pos1, ++d) { }
    return d;
}
{% endhighlight %}

从distance()的实现可以看出，随机迭代器将使用迭代器的算术运算pos2-pos1搞定问题；第二个版本的distance()则能够同时针对Input Iterator, Forward Iterator和Bidirectional Iterator三类迭代器起作用，这正是由开篇给出的iterator tag的继承关系决定的。

# 自定义迭代器

从前面的介绍可知，要自己写一个迭代器, 需要提供`iterator_traits`里的五个类型。可以通过两种办法来实现这一需求：

1. 在我的迭代器类型内，定义`iterator_traits`里需要的五个东西。

2. 特化或者偏特化模板`iterator_traits`, 就像`iterator_traits`的数组特化版本那样。

下面使用《c++标准库》里面的一个例子，来说明使用第一种方法来实现自定义迭代器。

C++标准提供了一个特殊的基类：`iterator<>`, 它帮我们完成了五个类型的定义，我们只需要继承这个基类，并指定它需要的类型参数即可, 例如如下定义：

{% highlight c++ %}
class MyIterator : public std::iterator<std::forward_iterator_tag, type, std::ptrdiff_t, type*, type&)
{
    // ...
};
{% endhighlight %}

第一个参数指定了迭代器的分类：`forward_iterator_tag`, `bidirectional_iterator_tag` 或者 `random_access_iterator_tag`等等

第二个参数指定了元素类型：`value_type`

第三个参数指定了位置差类型：`difference_type`

第四个参数指定了指针类型： `pointer`, 第五个参数指定了引用类型：`reference`

最后的三个参数的默认值分别是：`ptrdiff_t`, `type*`, `type&`, 在使用时可以忽略。

下面的例子就是书中的例子，它定义了一个关联容器的inserter适配器，类似std::inserter, 相对于std::iterator, 它省去了位置参数，传入一个容器即可：

{% highlight c++ %}
//----------------------- associative container inserter ----------------------
template <typename Con>
class asso_inserter_iterator 
    : public iterator<output_iterator_tag, typename Con::value_type>
{
public:
    explicit asso_inserter_iterator(Con &con) : conRef_(con) {}

    asso_inserter_iterator<Con>& operator= (const typename Con::value_type &val)
    {
        conRef_.insert(val);
        return *this;
    }

    asso_inserter_iterator<Con>& operator * () 
    {
        return *this;
    }

    asso_inserter_iterator<Con>& operator ++ ()
    {
        return *this;
    }

    asso_inserter_iterator<Con>& operator ++ (int)
    {
        return *this;
    }

protected:
    Con     &conRef_;
};

// convenience function to create asso_inserter_iterator.
template <typename Con>
inline asso_inserter_iterator<Con> asso_inserter(Con &con)
{
    return asso_inserter_iterator<Con>(con);
}
{% endhighlight %}

用法：


{% highlight c++ %}
RUN_GTEST(UserDefinedIterator, AssoInserter, @);

set<int> uset;

asso_inserter_iterator<set<int>>  ainserter(uset);

*ainserter = 10;
++ainserter;
*ainserter = 20;
++ainserter;
*ainserter = 30;

printContainer(uset, "uset: ");     // 10 20 30

asso_inserter(uset) = 1;
asso_inserter(uset) = 2;
printContainer(uset, "uset: ");     // 1 2 10 20 30

array<int, 5> a = {11, 22, 33, 44, 55};
copy(a.begin(), a.end(), asso_inserter(uset)); // 1 2 10 11 20 22 30 33 44 55
printContainer(uset, "uset: ");

END_TEST;
{% endhighlight %}

这里的用法示例与其他的迭代器适配器的用法类似，请参考[【C++ STL学习与应用总结】18: 如何使用迭代器适配器](http://elloop.github.io/c++/2015-12-28/learning-using-stl-18-iterator-adapter/).


# 源码及参考链接

- [`user_defined_iterator.cpp`](https://github.com/elloop/CS.cpp/blob/master/TotalSTL/iterator/user_defined_iterator.cpp)

- [`iterator_category`](http://www.cplusplus.com/reference/iterator/iterator/)

- [`iterator_traits`](http://www.cplusplus.com/reference/iterator/iterator_traits/?kw=iterator_traits)

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**



