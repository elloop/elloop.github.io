---
layout: post
title: "【C++学习与应用总结】12: Unscoped Enum"
category: c++
tags: [stl]
description: ""
---

#前言

本文总结了C++中的枚举类型enum在编程中的运用。从C++11开始，enum分为两种：

- Unscoped Enum: “旧式”Enum，在C++11之前直接使用enum关键字定义的枚举

- Scoped Enum: C++11开始引入的强类型枚举，使用关键字`enum class`或者`enum struct`定义的枚举

本文针对`Unscoped Enum`的使用来总结，不会涉及基本的语法细节。

<!--more-->

# 基本用法小技巧

**1. enum元素的个数**

在实际开发中经常需要知道一个enum中有多少个元素，可以通过在enum最后加上一个名为`Count`的枚举，它就是enum元素的个数。

示例代码如下：

{% highlight cpp %}

// 枚举元素的命名风格采用了Google C++风格
enum Color
{
    kRed,
    kGreen,
    kBlue,
    kYellow,
    kPink,
    kPurple,
    kColorCount,
};

RUN_GTEST(EnumClassTest, Unscoped, @);

// 定义并初始化一个枚举数组，每个分量取值enum中不同的值
Color colors[kColorCount];

for (int i=0; i<kColorCount; ++i) 
{
    colors[i] = static_cast<Color>(i);
}

// 检查colors中每个枚举的取值是否是Color中对应元素的值
for (int i=0; i<kColorCount; ++i) 
{
    Color color_i = static_cast<Color>(kRed + i);
    assert(colors[i] == color_i);
}

END_TEST;
{% endhighlight %}

理论基础是：Unscoped Enum的基本类型是int，且默认第一个元素的初值是0，某个枚举元素E(n)的值如果不显式指定，那么E(n)的值就等于E(n-1) + 1.

# the enum hack

enum hack是旧式枚举的经典用法，它是把枚举元素用做一个编译时整型常量来用，在C++ TMP中特别常用。

这个概念我最早是在Effective C++中见到(Item2)：

旧式枚举的经典用法，

{% highlight cpp %}
class GamePlayer
{
private:
    enum { NumTurns = 5};

    int scores[NumTurns];       // NumTurns被当做一个编译时常量使用

}
{% endhighlight %}

the enum hack 用到了C++中的一个语法规则：enum的成员可以隐式转换为int.

# enum类型转换

**1. enum与int转换**

从上面两段代码中可以看到，

- enum转int是自动的。可以看到上面在定义数组时，直接使用枚举元素作为数组的长度。

- int转enum需要显示类型转换。第一段代码中在给`colors[i]`赋值的时候，使用了`static_cast<Color>`的静态类型转换操作符。

# enum 算数运算

enum类型的变量和int进行运算，运算结果是什么类型呢？

{% highlight cpp %}
RUN_GTEST(EnumClassTest, Arithmetic, @);

Color red = kRed;
psln(typeid(red).name());   // 打印red的类型名称

int i = 1;
bool same = std::is_same<decltype(i), decltype(i + red)>::value;    // 假定i和red运算的结果类型和i的类型一致
EXPECT_TRUE(same);

END_TEST;
{% endhighlight %}

输出：

{% highlight cpp %}
[ RUN      ] EnumClassTest.Arithmetic
@@@@@@@@@@ EnumClassTest ---> Arithmetic @@@@@@@@@@
typeid(red).name() = enum elloop::enum_class::Color
[       OK ] EnumClassTest.Arithmetic (3 ms)
{% endhighlight %}

从测试结果可以看到：

- red的类型名叫`enum_class::Color`, 前面的elloop是我自定义的命名空间; 

- `EXPECT_TRUE(same)`的测试通过，这意味着enum和int运算的结果类型是int类型。

如果把i的类型改为long类型，那么测试依然能够通过。enum的类型会被提升为与i一样的类型，有点像内置数据类型的算数运算法则：“低精度的会转为较高精度的类型然后参与运算，结果也是较高精度的类型”



# 源码及参考链接

- [cppreference.com](http://en.cppreference.com/w/cpp/language/enum)

- [enumtest.cpp](https://github.com/elloop/CS.cpp/blob/master/TrainingGround/grammar/enum_class_test.cpp)

---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

