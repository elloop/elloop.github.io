---
layout: post
title: "【C++ STL学习与应用总结】18: 如何使用迭代器适配器"
category: c++
tags: [stl]
description: ""
---

**本系列文章的目录在这里：[目录](http://blog.csdn.net/elloop/article/details/50357205). 通过目录里可以对STL总体有个大概了解**

#前言

本文介绍了STL中的迭代器适配器(iterator adapter)的概念及其使用方法示例。迭代器适配器可以和标准库中的算法配合使用，达到一些特殊的效果。

迭代器适配器分为以下几类：

- reverse iterator : 反向迭代器

- insert iterator : 插入型迭代器

- stream iterator : 流迭代器

- move iterator : 移动型迭代器

<!--more-->

# reverse iterator 反向迭代器

顾名思义，reverse就是反其道而行之。正常的迭代器是从前往后的方向递增，而反向迭代器则是从后向前递增的。支持双向迭代的容器通常都有rbegin(), rend()这对接口，它们的返回值就是reverse iterator。使用这对反向迭代器来遍历容器就会实现从后向前的效果。

{% highlight c++ %}
vector<int> v = { 1, 2, 3};
auto rbeg = v.rbegin();
while (rbeg != v.rend())
{
    cout << *rbeg << endl;
    ++rbeg;
}
{% endhighlight %}

{% highlight c++ %}
//----------------------- reverse iterator  ----------------------
RUN_GTEST(IteratorAdapter, ReverseIterator, @);

array<int, 5> a = {1, 2, 3, 4, 5};
printContainer(a, "a: ");

auto pos1 = find(a.begin(), a.end(), 5);

// rpos1 是pos1的反向迭代器
array<int, 5>::reverse_iterator rpos1(pos1);

// 对rpos1提取值，会发现与pos1中的值不一样，这是bug吗 ？
EXPECT_EQ(4, *rpos1);

// 不，不是bug，标准库是故意这样设计的，它的设计是：
// 从一个迭代器pos1构造其反向迭代器rpos1, 两者在“物理”上是不变的，即指向同一个地方。
// 但是在取迭代器指向的值的时候（我们叫它“逻辑”地址），二者的解释是不一样的，即逻辑地址不一样。
//
// pos1:                              physically(logically)
//                                       |
//                                       |
// 1        2      3        4            5
//                          ^            ^
//                          |            |
//                          |            |
// rpos1:                 logically   physically
//
// 对于pos1，其逻辑地址与物理地址一致，其逻辑值是5;
// 而对于rpos1, 其逻辑地址在物理地址的前一个位置，所以其逻辑值是4.
// 这样设计的原因是由于正向迭代器的半开区间特性造成的，正向迭代器的end是最后一个元素的下一个位置，
// 反向迭代器里并没有超过第一个位置的前一个位置这个概念, 
// 标准库就使用了逻辑地址和物理地址独立这种设计，实现了反向的迭代，
// 反向迭代器和正向迭代器的物理位置是一样的，只不过在取值的时候往前一位来取，
// 当物理位置到达第一个位置的时候，就已经取不到值了，也就代表反向迭代器的结束。
// 这种设计的好处是对于区间的反向操作很简单：

array<int, 5>::reverse_iterator rEnd(a.end());
// rEnd also point to physical location: a.end(), 
// but its logical location is a.end() - 1, so equal to 5.
EXPECT_EQ(5, *rEnd);                    


// reverse range.
auto posA = find(a.begin(), a.end(), 2);
auto posB = find(a.begin(), a.end(), 5);
pln("in normal order: ");
copy(posA, posB, ostream_iterator<int>(cout, " "));
cr;

array<int, 5>::reverse_iterator rPosA(posA);
array<int, 5>::reverse_iterator rPosB(posB);
pln("in reverse order: ");
copy(rPosB, rPosA, ostream_iterator<int>(cout, " "));
cr;


// 使用base()函数来把一个反向迭代器转为正向迭代器
auto recoverPos = rpos1.base();
EXPECT_EQ(5, *recoverPos);

END_TEST;
{% endhighlight %}

# insert iterator 插入型迭代器

插入型迭代器可以使标准库中算法对元素进行赋值操作的语义转化为对元素的插入操作语义。因为它们会改变容器，它们需要使用一个容器来初始化，如下面的代码所示： 

插入型迭代器分为以下三种：

## `back_insert_iterator` or back inserter. 在后面插入型迭代器

会对初始化它的容器调用`push_back`以完成后面插入元素的操作。

{% highlight c++ %}
//----------------------- inserter ----------------------
RUN_GTEST(IteratorAdapter, InserterTest, @);

array<int, 5> a = { 1, 2, 3, 4, 5 };
vector<int> v = {};

//------------- 1. back inserter ----------------
// 1. back_inserter(con) : call con.push_back().

// 创建一个`back_insert_iterator`的第一种方式
back_insert_iterator<vector<int>>  backInserter(v);

*backInserter = 1;
++backInserter;                 // do nothing, can skip this
*backInserter = 2;
++backInserter;                 // do nothing, can skip this

printContainer(v, "v: ");       // 1 2

// 创建一个back_insert_iterator的第二种方式
back_inserter(v) = 3;
back_inserter(v) = 4;
printContainer(v, "v: ");       // 1 2 3 4


copy(a.begin(), a.end(), back_inserter(v));
printContainer(v, "v: ");       // 1 2 3 4 1 2 3 4 5

END_TEST;
{% endhighlight %}

## `front_insert_iterator` or front inserter. 在前面插入型迭代器

与`back_insert_iterator`类似，此迭代器调用容器的`push_front`来完成在前面插入元素的操作。

{% highlight c++ %}
//------------- 2. front inserter ----------------
// front_inserter(con): call con.push_front().
list<int> l = {};

// 第一种创建front_insert_iterator的方式
front_insert_iterator<list<int>> frontInserter(l);

*frontInserter = 1;
++frontInserter;
*frontInserter = 2;
++frontInserter;
printContainer(l, "l: ");       // 2 1

// 第二种创建front_insert_iterator的方式
front_inserter(l) = 3;
front_inserter(l) = 4;
printContainer(l, "l: ");       // 4 3 2 1 


copy(a.begin(), a.end(), front_inserter(l));
printContainer(l, "l: ");       // 5 4 3 2 1 4 3 2 1
{% endhighlight %}

## `insert_iterator` or general inserter. 通用型插入迭代器

最后这种插入型迭代器是最通用的迭代器, 它对容器调用insert(value, pos)方法。使得没有`push_back`, `push_front`操作的容器，比如关联式容器能够使用这种迭代器。它相对于前两种适配器，需要一个额外的参数pos以指示插入位置。

{% highlight c++ %}
//------------- 3. general inserter ----------------
// inserter(con, pos) : call con.insert(), and return new valid pos.
set<int> s = {};
insert_iterator<set<int>> generalInserter(s, s.begin());
*generalInserter = 5;
++generalInserter;
*generalInserter = 1;
++generalInserter;
*generalInserter = 4;
printContainer(s, "s: ");       // 1 4 5

inserter(s, s.end()) = 3;
inserter(s, s.end()) = 2;
printContainer(s, "s: ");       // 1 2 3 4 5

list<int> copyS;
copy(s.begin(), s.end(), inserter(copyS, copyS.begin()));
printContainer(copyS, "copyS: ");       // 1 2 3 4 5
{% endhighlight %}

# stream iterator 流迭代器

分为：`ostream_iterator`和`istream_iterator`.

## `ostream_iterator` 输出流迭代器

{% highlight c++ %}
//----------------------- stream iterator  ----------------------
RUN_GTEST(IteratorAdapter, StreamIterator, @);

// 输出迭代器示例
//------------- 1. ostream iterator ----------------
// ostream_iterator(stream, delim)

// 指定一个流类型变量和分隔符来创建一个流迭代器
ostream_iterator<int> outputInt(cout, "\n");

*outputInt = 1;             // output 1 \n
++outputInt;
*outputInt = 2;             // output 2 \n
++outputInt;
cr;

array<int, 5> a = {1, 2, 3, 4, 5};
copy(a.begin(), a.end(), ostream_iterator<int>(cout));  // no delim, 12345
cr;

string delim("-->");
copy(a.begin(), a.end(), ostream_iterator<int>(cout, delim.c_str())); 
cr;                                             // 1-->2-->3-->4-->5-->
{% endhighlight %}


## `istream_iterator` 输入流迭代器

{% highlight c++ %}
// 3. 输入流迭代器示例：
//------------- 2. istream iterator ----------------
// istream_iterator(stream)

pln("input some char, end with EOF");
// 创建一个输入流迭代器，注意创建的时候即已读取一个元素。
istream_iterator<char> charReader(cin);

// 输入流的结束位置
istream_iterator<char> charEof;

while (charReader != charEof)
{
    pln(*charReader);
    ++charReader;
}
cin.clear();

//------------- 3. istream & ostream & advance ----------------
pln("input some string, end with EOF");
istream_iterator<string> strReader(cin);
ostream_iterator<string> strWriter(cout);

while (strReader != istream_iterator<string>())
{
    advance(strReader, 1);
    if (strReader != istream_iterator<string>()) 
    {
        *strWriter++ = *strReader++;
    }
}
cr;

END_TEST;
{% endhighlight %}

# move iterator 

since C++11, 移动语义的提出大大提高了一些涉及到转发参数的函数调用过程之中(perfect forwarding完美转发)参数传递的效率，通过把元素内部底层的东西移动到新的元素来避免拷贝开销。因为这个原因也提供了移动的迭代器适配器以实现需要移动语义的场合，下面是一段示意的代码:

{% highlight c++ %}
//----------------------- move iterator  ----------------------

list<string> l = {"hello", "tom", "jerry"};

vector<string> v(l.begin(), l.end());              // copy l.

vector<string> v2(make_move_iterator(l.begin()),   // move l.
        make_move_iterator(l.end()));    
{% endhighlight %}

# 源码与参考链接

- [`iterator_adapter_test.cpp.cpp`](https://github.com/elloop/CS.cpp/blob/master/TotalSTL/iterator/iterator_adapter/iterator_adapter_test.cpp)

- [`reverse_iterator`](http://www.cplusplus.com/reference/iterator/reverse_iterator/?kw=reverse_iterator)

- [`back_insert_iterator`](http://www.cplusplus.com/reference/iterator/back_insert_iterator/?kw=back_insert_iterator)

- [`front_insert_iterator`](http://www.cplusplus.com/reference/iterator/front_insert_iterator/?kw=front_insert_iterator)

- [`insert_iterator`](http://www.cplusplus.com/reference/iterator/insert_iterator/?kw=insert_iterator)

- [`istream_iterator`](http://www.cplusplus.com/reference/iterator/istream_iterator/?kw=istream_iterator)

- [`ostream_iterator`](http://www.cplusplus.com/reference/iterator/ostream_iterator/?kw=ostream_iterator)

- [`make_move_iterator`](http://www.cplusplus.com/reference/iterator/make_move_iterator/?kw=make_move_iterator)


---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**欢迎访问[github博客](http://elloop.github.io)，与本站同步更新**



