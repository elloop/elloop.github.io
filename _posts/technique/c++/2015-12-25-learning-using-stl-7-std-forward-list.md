---
layout: post
title: "【C++ STL应用与实现】7: 如何使用std::forward_list 单链表 (since C++11)"
category: c++
tags: [stl]
description: ""
---

**本系列文章的目录在这里：[目录](http://blog.csdn.net/elloop/article/details/50357205). 通过目录里可以对STL总体有个大概了解**

#前言

本文介绍了STL中的序列式容器`std::forward_list`, 从它的名字就能推测出来，它是单向的，只能前进(forward). 确实如此，它其实就是对C语言风格的单链表的封装，仅提供有限的接口，相对于std::list(双向链表，并且定义很多接口)来说它节省了内存，同时又有比list更好的运行时性能；相对于自己实现的C风格的单链表(hand-written c-style linked list)而言，`forward_list`也有与其不相上下的效率表现.  

正如标准库所说的那样：

>"`forward_list`设计的目标是, 使用`forward_list`不会比使用自己手写的C风格单链表有更多的时间和空间的开销, 任何有悖于这个目标的接口和特性都会被标准拒之门外"

<!--more-->

# 先看个例子吧

{% highlight c++ %}
#include <forward_list>
#include <iostream>

using namespace std;

int main()
{
    forward_list<int> fl = {1, 2, 3, 4, 5};

    for (const auto &elem : fl)
    {
        cout << elem;
    }

    return 0;
}
{% endhighlight %}

# constructor

|**构造方式**|**说明**|
|------------|--------|
|`forward_list<T> c`|默认构造函数，构造一个空的列表。|
|`forward_list<T> c(c2)`|使用c2来拷贝构造c，c2中所有元素都被拷贝|
|`forward_list<T> c = c2`|使用c2来拷贝构造c，c2中所有元素都被拷贝|
|`forward_list<T> c(rValue)`|移动构造函数，使用右值rValue的内容来构造c。|
|`forward_list<T> c = rValue`|移动构造函数，使用右值rValue的内容来构造c。|
|`forward_list<T> c(n)`|构造一个含有n个元素的列表，每个元素使用默认构造函数创建|
|`forward_list<T> c(n, elem)`|构造一个含有n个elem元素的列表|
|`forward_list<T> c(begin, end)`|使用[begin, end)之间的元素初始化c|
|`forward_list<T> c(initiallist)`|使用初始化列表initiallist来初始化c|
|`forward_list<T> c = initiallist`|使用初始化列表initiallist来初始化c|

# 非修改类接口 nonmodifying operations.

|**API**|**说明**|
|------------|--------|
|`c.empty()`|是否是空列表|
|`c.max_size()`|最大可能的容量|
|`c1 == c2`|是否相等，内部对所有elems调用==|
|`c1 != c2`|!(c1 == c2)|
|`c1 < c2`|小于|
|`c1 > c2`|c2 < c1|
|`c1 <= c2`|!(c2 < c1)|
|`c1 >= c2`|!(c1 < c2)|

注意：因为性能方面的考虑，`forward_list`不提供size()接口，这正是标准所说的“不比手写的C风格单链表有更多的时间和空间上的开销”的设计目标的结果·

# 赋值操作 assignments

|**API**|**说明**|
|------------|--------|
|`c1 = c2`|c2所有元素赋值给c1|
|`c1 = rValue`|move rValue所有元素给c1|
|`c1 = initiallist`|initiallist所有元素赋值给c1|
|`c1.assign(initiallist)`|分配initiallist给c1|
|`c1.assign(n, elem)`|分配n个elem|
|`c1.assign(begin, end)`|分配[begin, end)给c1|
|`c1.swap(c2)`|交换c1, c2|
|`swap(c1, c2)`|交换c1, c2|

# 元素访问 element access

同样是出于简单高效的设计目标，`forward_list`只有一个直接访问元素的接口：`c.front()`.

c.front()返回第一个元素，这个接口内部并不会检查是不是存在第一个元素。如果调用了，但是元素不存在，那么导致未定义行为。

既然只有一个接口返回第一个元素，那么怎么来遍历所有元素呢？

有两种方式：

- iterators.

- range-based for loops. (其本质依然是使用iterators)


# 迭代器函数 iterator functions.

|**API**|**说明**|
|------------|--------|
|`c.begin()`|指向第一个元素的迭代器|
|`c.end()`|最后一个元素的下一个位置|
|`c.cbegin()`|const begin()|
|`c.cend()`|const end()|
|`c.before_begin()`|第一个元素前一个位置|
|`c.cbefore_begin()`|const `before_begin()`|

使用迭代器是遍历`forward_list`所有元素的方式之一, 这一点和其他类型的容器类似，不必细说，待会看代码的例子就明了了。

注意: 对end()和`before_begin()`迭代器的直接操作都是未定义的行为，有可能造成运行时错误：

{% highlight c++ %}
*c.before_begin();      // undefined behaviour
*c.end();               // undefined behaviour
{% endhighlight %}

一般没人会像上面这样写，但是有时候连我自己都不知道我会对这两个位置进行解引用，比如我从一个函数的返回值得到了一个pos，然后我没有对pos进行合法性检查就直接*pos。

# 插入、移除元素 modifying operations

|**API**|**说明**|
|------------|--------|
|`c.push_front()`|在开头插入元素|
|`c.pop_front()`|删掉开头元素|
|`c.insert_after(pos, elem)`|在pos之后插入元素, 返回新元素的位置|
|`c.insert_after(pos, n, elem)`|在pos之后插入n个元素elem, 返回第一个新元素的位置|
|`c.insert_after(pos, begin, end)`|在pos之后插入元素[begin, end), 返回第一个新元素的位置|
|`c.insert_after(pos, initiallist)`|在pos之后插入initiallist, 返回第一个新元素的位置|
|`c.emplace_after(pos, args...)`|在pos之后插入args...元素，返回第一个新元素的位置|
|`c.emplace_front(args...)`|在开头插入元素args..., 无返回值|
|`c.erase_after(pos)`|删掉pos后面那个元素|
|`c.erase_after(begin, end)`|删掉(begin, end)之间的元素|
|`c.remove(val)`|移除所有值为val的元素|
|`c.remove_if(op)`|删掉所使得op(elem)为true的元素|
|`c.resize(n)`|调整个数为n，如果变大了，那多出来的用默认构造函数来创建|
|`c.resize(n, elem)`|调整个数为n，如果变大了，那多出来的用elem的来拷贝构造|
|`c.clear()`|清除所有元素|

手写过单链表这种数据结构的人都会知道，对单链表的插入和删除操作都需要指定一个位置，并且这个位置要是被改动元素之前的位置，这是因为单链表不能够“回头”，比如我要删除第N个元素，我不仅要删掉第N个，还需要修改第N-1个元素，使它的跟第N+1个连在一起。

这个道理在`std::forward_list`上的体现就是，插入和删除`forward_list`的操作跟其他的标准容器的接口不太一样：

- **1**. `forward_list`的接口总是需要一个“位置”参数pos, 要处理的元素就是在pos的后面；

- **2**. `forward_list`的接口总是以 `_after`结尾，意思是在某个参数**之后**进行操作。

在实际的应用中，我通常要先搜索要被处理的元素，比如，在一个列表里，我要删除第一个偶数， 如果我这样来写：

{% highlight c++ %}
//----------------------- find and modify  ----------------------
RUN_GTEST(ForwardListTest, FindAndModify, @);

forward_list<int> fl = { 1, 2, 3 };
printContainer(fl, "fl: ");                 // fl: 1 2 3

// 找偶数用
auto isEven = [](int i) -> bool
{
    return (i % 2 == 0);
};

auto deletePos = find_if(fl.begin(), fl.end(), isEven);

// 接下来怎么写，不行了，我已经走过头了，deletePos虽然是我要删除元素的位置，
// 但是我要调用erase_after， 那么就要把deletePos前面的位置传给erase_after.

// 因此为了要记住deletePos之前的位置，我得这么写：

// pos是要删除的元素，posBefore是pos的前一个元素
forward_list<int>::iterator posBefore, pos;

posBefore = fl.before_begin();

for (pos = fl.begin(); pos != fl.end(); posBefore = pos, ++pos)
{
    if (*pos % 2 == 0)
    {
        // 找到了
        break;
    }
}

if (pos != fl.end())
{
    // 把pos的前一个位置传给erase
    fl.erase_after(posBefore);
    printContainer(fl, "fl: ");                 // fl: 1 3
}


// 这个过程是不是有些麻烦，要定义两个迭代器位置，
// 其实可以使用迭代器辅助函数: next(pos, n)来简化, 
// next的作用很简单，返回pos的下n个位置，n默认为1.

// 下面用next来完成查找过程：

// 把list恢复成 1 2 3
fl.insert_after(posBefore, 2);
printContainer(fl, "fl: ");                     // fl: 1 2 3

posBefore = fl.before_begin();
for (; next(posBefore) != fl.end(); ++posBefore)
{
    int i = *next(posBefore);
    if (isEven(i))
    {
        // 找到了
        break;
    }
}


if (next(posBefore) != fl.end()) 
{
    fl.erase_after(posBefore);
    printContainer(fl, "fl: ");              // fl: 1 3
}
{% endhighlight %}

使用next来找要删除或插入的位置的代码还勉强能够接受，如果要频繁重复这操作，那建议像标准库那本书里自己定义两个算法：

- `find_before(begin, end, val)` : 返回[begin, end)之间，elem == val的元素的前一个位置

- `find_before_if(begin, end, op)` : 返回[begin, end)之间，op(elem) == true 的元素的前一个位置

本文最后会给出这俩算法的实现。

# 连接(splice)和变序类操作

|**API**|**说明**|
|------------|--------|
|`c.unique()`|删除连续相同的元素|
|`c.unique(op)`|删除连续使得op(elem) == true的元素|
|`dst.splice_after(dstPos, src)`|把src里的全部元素移动到dst中的dstPos之后|
|`dst.splice_after(dstPos, src, srcPos)`|把src里的srcPos后面的一个元素移动到dst中的dstPos之后|
|`dst.splice_after(dstPos, src, srcBegin, srcEnd)`|把src里(srcBegin, srcEnd)之间的元素移动到dst中的dstPos之后|
|`c.sort()`|使用默认的`<`来给c中的元素排序|
|`c.sort(op)`|使用op来给c中的元素排序|
|`c.merge(c2)`|移动c2中的元素到c中，假定二者原来都已序，那么移动之后c仍然有序|
|`c.merge(c2, op)`|移动c2中的元素到c中，假定二者原来都按op已序，那么移动之后c仍然按op有序|
|`c.reverse()`|所有元素反序|

注意：`splice_after`中涉及到的dst, src可以是同一个`forward_list`, 此时，这个操作就是在列表内部来移动元素。`splice_after`的位置参数不要使用end(), 这将导致未定义行为。

下面给出《c++标准库》上关于`splice_after`的一个例子，书中的代码有一句是有错误的，下面给出正确的代码：

{% highlight c++ %}
//----------------------- splice ----------------------
RUN_GTEST(ForwardListTest, SpliceTest, @);

forward_list<int> fl1 = { 1, 2, 3, 4, 5 };
forward_list<int> fl2 = { 97, 98, 99 };

printContainer(fl1, "fl1: ");       // 1 2 3 4 5
printContainer(fl2, "fl2: ");       // 97 98 99

auto pos1 = fl1.before_begin();                 
for ( ; next(pos1) != fl1.end(); ++pos1 )
{
    if ( *next(pos1) == 3 )         // find 3, pos1 is position before 3.
    {
        break;
    }
}

auto pos2 = fl2.before_begin();
for ( ; next(pos2) != fl2.end(); ++pos2 )
{
    if ( *next(pos2) == 99 )        // find 99, pos2 is position before 99.
    {
        break;
    }
}


// 书中原始代码为：
// fl1.splice_after(pos2, fl2,         // destination
//                  pos1);             // source

// 可能是这个函数之前的作用和现在标准发布的用法不一致，
// 作者的代码用反了source和destination. 我运行这段代码程序报错了。
// 结合书中对splice_after函数的解释，正确的用法 应该是下面这样：

// 把fl1中pos1后面的一个元素，移动到fl2中pos2后面。
fl2.splice_after(pos2,              // 目的地
                 fl1, pos1);        // 源

// 要移动到fl2中，那么fl2是目标，所以要用fl2来调用splice_after.
// pos2是fl2中的位置，它是目的地，应该作为第一个参数；
// fl1是源，作为第二个参数；
// pos1则是源fl1中的具体位置，作为第三个参数。


printContainer(fl1, "fl1: ");       // 1 2 4 5
printContainer(fl2, "fl2: ");       // 97 98 3 99
END_TEST;
{% endhighlight %}

# `find_before` 和 `find_before_if`的实现

{% highlight c++ %}
// 返回(begin, end)之间，值等于val的元素的前一个位置pos. 开区间，不包括begin和end
template <typename ForwardIter, typename T>
ForwardIter find_before(ForwardIter beg, ForwardIter end, const T &val)
{
    auto posBefore = beg;
    while (beg != end)
    {
        if (*beg == val) 
        {
            return posBefore;
        }
        posBefore = beg;
        ++beg;
    }
    return end;
}

// 返回(begin, end)之间，满足op(elem) == true的元素的前一个位置pos. 注意是开区间，不包括begin和end
template <typename ForwardIter, typename Pred>
ForwardIter find_before_if(ForwardIter beg, ForwardIter end, Pred op)
{
    auto posBefore = beg;
    ++beg;
    while (beg != end)
    {
        if (op(*beg))
        {
            return posBefore;
        }
        posBefore = beg;
        ++beg;
    }
    return end;
}
{% endhighlight %}

使用示例：

{% highlight c++ %}
//----------------------- test find_before  ----------------------
RUN_GTEST(ForwardListTest, FindBefore, @);

forward_list<int> fl = { 1, 2, 3 };
printContainer(fl, "original fl: ");                 // 1 2 3

//------------------ find_before -----------------------
auto posBefore2 = find_before(fl.begin(), fl.end(), 2);
if (posBefore2 != fl.end()) 
{
    fl.erase_after(posBefore2);
    printContainer(fl, "delete 2: ");                 // 1 3
}


//------------------ find_before_if -----------------------
auto isEven = [](int i) -> bool
{
    return (i % 2 == 0);
};

// recover fl contents to 1 2 3.
fl.clear();
fl.insert_after(fl.before_begin(), {1, 2, 3});
printContainer(fl, "original fl: ");                 // 1 2 3


posBefore2 = find_before_if(fl.begin(), fl.end(), isEven);
if (posBefore2 != fl.end()) 
{
    fl.erase_after(posBefore2);
    printContainer(fl, "delete first even: ");      // 1 3
}

END_TEST;
{% endhighlight %}

# 源码和参考链接

- [`forward_list_test.cpp`](https://github.com/elloop/CS.cpp/blob/master/TotalSTL/container/sequence/forward_list_test.cpp)

- [`forward_list`](http://www.cplusplus.com/reference/forward_list/forward_list/?kw=forward_list)

- [next](http://www.cplusplus.com/reference/iterator/next/?kw=next)

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**欢迎访问[github博客](http://elloop.github.io)，与本站同步更新**



