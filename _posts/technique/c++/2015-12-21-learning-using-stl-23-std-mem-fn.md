---
layout: post
title: "【C++ STL学习与应用总结】23: 如何使用std::mem_fn (since C++11)"
category: c++
tags: [stl]
description: ""
---

**本系列文章的目录在这里：[目录](http://blog.csdn.net/elloop/article/details/50357205). 通过目录里可以对STL总体有个大概了解**

#前言

本文总结了STL中函数适配器：`mem_fn`系列函数的用法，它们是：`mem_fun (c++98)`, `mem_fun_ref (c++98)`, `mem_fn (c++11)`. 文中给出了它们各自的使用范围及代码示例，提到了mem_fn的使用限制，使用bind来解决这个限制。

#基本用法

从名字也能看出个大概，`mem_fn`里面的mem就是指类的成员member, 而fn就是指function, 加在一起就是说member function，即`mem_fn`是用来适配类的成员函数的，下面从代码里来看一下它们的区别：

<!--more-->

**mem_fn_and_mem_fun.cpp**是我写的一个测试文件，从注释里看，并列的3个部分，分别是：
1. mem_fun 
2. mem_fun_ref
3. mem_fn

{% highlight c++ %}
#include "gtest/gtest.h"
#include "inc.h"
#include <functional>
#include <algorithm>

NS_BEGIN(elloop);

using namespace std;
using namespace std::placeholders;


// 定义一个类Foo用来测试，适配其成员函数
// 其中函数pln(x)是输出x，并换行的意思； 
class Foo
{
public:
    // 无参数member function
    void print() { pln(a_); }   

    // 接受一个参数的member function
    void print2(int i) 
    {
        pln(a_);
        pln(i);
    }

    int a_{ 100 };
};



//----------------------- c++98 mem_fun and c++11 mem_fn -----------------------
BEGIN_TEST(FunctorTest, Mem_FunTest, @);

// 1. mem_fun is for a pointer to an obj.
// 定义一个容器，存入几个Foo*, 然后使用mem_fun来取指针并绑定到Foo的成员函数
vector<Foo*> fpv;
fpv.push_back(new Foo());
fpv.push_back(new Foo());
fpv.push_back(new Foo());
fpv.push_back(new Foo());

for_each(fpv.begin(), fpv.end(), mem_fun(&Foo::print));
cr;

// mem_fun_ref用来绑定的target应该为Foo对象，而不是指针
//for_each(fpv.begin(), fpv.end(), mem_fun_ref(&Foo::print));   // error. 

for_each(fpv.begin(), fpv.end(), bind(&Foo::print, _1));    // also can use bind
cr;

// 如果成员函数接受额外参数（不仅仅是对象本身）, 那么mem_fun就无能为力了，要用bind
//for_each(fpv.begin(), fpv.end(), mem_fun(&Foo::print2, 10));
for_each(fpv.begin(), fpv.end(), bind(&Foo::print2, _1, 10)); // must use bind


// 2. mem_fun_ref is for obj.
vector<Foo> fv;
fv.push_back(Foo());
fv.push_back(Foo());
fv.push_back(Foo());
fv.push_back(Foo());

for_each(fv.begin(), fv.end(), mem_fun_ref(&Foo::print));
cr;

// mem_fun 不能用来绑定对象.
// for_each(fv.begin(), fv.end(), mem_fun(&Foo::print));    // error.

for_each(fv.begin(), fv.end(), bind(&Foo::print, _1));      // bind也可以
cr;

// 如果成员函数接受额外参数（不仅仅是对象本身）, 那么mem_fun就无能为力了，要用bind
//for_each(fv.begin(), fv.end(), mem_fun_ref(&Foo::print2, 10));

for_each(fv.begin(), fv.end(), bind(&Foo::print2, _1, 10)); // bind可以有很多参数


// 3. mem_fn既可以用于指针、引用，还可以用于对象本身，因此在C++11中使用mem_fn可以替代mem_fun和mem_fun_ref.
for_each(fpv.begin(),   fpv.end(),  mem_fn(&Foo::print));       // ptr
for_each(fv.begin(), fv.end(), mem_fn(&Foo::print));            // obj

//for_each(fv.begin(), fv.end(), mem_fn(&Foo::print2, 10));
for_each(fv.begin(), fv.end(), bind(&Foo::print2, _1, 10)); //must use bind

Foo foo;
Foo &foo_ref = foo;
mem_fn(&Foo::print)(foo_ref);                                   // ref


// clear pointers.
for_each(fpv.begin(), fpv.end(), [&](Foo* foo)
{
    delete foo;
    foo = nullptr;
});

END_TEST;




NS_END(elloop);
{% endhighlight %}

# 总结

|**函数**|**作用**|
|---------|-------|
|`mem_fun`|把成员函数转为函数对象，使用对象指针进行绑定|
|`mem_fun_ref`|把成员函数转为函数对象，使用对象(引用)进行绑定|
|`mem_fn`|把成员函数转为函数对象，使用对象指针或对象(引用)进行绑定|
|`bind`|包括但不限于mem_fn的功能，更为通用的解决方案，详见目录里std::bind的文章|

# 源码及参考链接

- [源码：mem_fn_and_mem_fun.cpp](https://github.com/elloop/CS.cpp/blob/master/TotalSTL/functor/mem_fn_and_mem_fun.cpp)

- [mem_fun](http://www.cplusplus.com/reference/functional/mem_fun/?kw=mem_fun)

- [mem_fun_ref](http://www.cplusplus.com/reference/functional/mem_fun_ref/)

- [mem_fn](http://www.cplusplus.com/reference/functional/mem_fn/?kw=mem_fn)


---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**欢迎访问[github博客](http://elloop.github.io)，与本站同步更新**



