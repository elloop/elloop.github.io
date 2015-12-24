---
layout: post
title: "【C++ STL学习与应用总结】5: 如何使用std::array (since C++11)"
category: c++
tags: [stl]
description: ""
---

**本系列文章的目录在这里：[目录](http://blog.csdn.net/elloop/article/details/50357205). 通过目录里可以对STL总体有个大概了解**

#前言

本文总结了STL中的序列式容器array的用法及注意事项。array的出现代表着C++的代码更进一步“现代化”，就像std::string的出现代替了c风格字符串并且能和STL配合工作一样，array的出现则将取代语言内置的数组以及c风格的数组字符串，它提供了data()接口，使得能够获得内部数组的首地址，它提供了size(), 能够得其固定的长度，使得C++的数组也可以像Java等语言那样知道自己的length；它提供了begin(), end()等接口使得“数组”也可以和STL血脉相容；它还提供了tuple接口，可以当做tuple来使用；更重要的一点是，array有并不比原生数组差的性能表现。

<!--more-->

# array的概念

array是STL中的一个序列式容器，它包装了一个c风格的数组，但在外部接口来看，提供了STL容器的常用接口。它的长度是固定的，正如普通的c风格数组那样，一旦创建完成，长度即确定，不能扩大也不能缩小。

它的原型就像这样, 是一个模板类：

```c++
namespace std
{
    template <typename T, size_t N>
    class array;
}
```

第一个模板参数T指明了array中存放的数据类型；

第二个`非类型模板参数`指明了array的固定大小。

# array的接口

## constructors

|**构造函数**|**说明**|
|------------|--------|
|`arrary<T, N> c`|默认构造函数，N个元素全部使用“默认初始化行为”来构造。|
|`arrary<T, N> c(other)`|拷贝构造函数，拷贝所有other的元素到c来构造。|
|`arrary<T, N> c = other`|拷贝构造函数，拷贝所有other的元素到c来构造。|
|`arrary<T, N> c(rValue)`|移动构造，使用右值rValue里的元素来初始化c。|
|`arrary<T, N> c = rValue`|移动构造，使用右值rValue里的元素来初始化c。|
|`arrary<T, N> c = initlist`|使用初始化列表初始化元素|


**注意**： 由于默认构造函数是对每一个元素使用“默认构造”行为来初始化，这意味着对于基本类型的数据其初始值是未定义的。

array 被要求是一个“aggregate”: 没有用户自定义的构造函数、没有非静态的private和protected类型的成员、没有基类、没有虚函数.

因此不支持这样的构造方法：`array<int, 3> a({1, 2, 4})`;

初始化array最常用的方法是使用赋值运算符和初始化列表：

```c++
array<int, 3> a = {1, 2, 3};

array<int, 100> b = {1, 2, 3};  // a[0] ~ a[2] = 1, 2, 3; a[3] ~ a[99] = 0, 0, 0 ... 0;

array<int, 3> c;                // c[0] ~ c[2] 未初始化，是垃圾值.
```

## assignment 


|**形式**|**说明**|
|------------|--------|
|`c = other`|把other的全部元素复制一份给c。|
|`c = rValue`|rValue全部元素被移动到c|
|`c.fill(val)`|用val给每个元素赋值|
|`c.swap(c2)`|交换c和c2的所有元素|
|`swap(c, c2)`|交换c和c2的所有元素|


**注意** ：array的swap操作通常代价比较高：是一个O(n)的操作。

## begin(), end()等迭代器位置及属性获取操作

- begin() (cbegin())

- end() (cend())

- rbegin() (crbegin())

- rend() (crend())

- empty()

- size()

- max_size()

- [index]

- at(index)

- front()
-
- back();

## tuple接口

```c++
array<string, 3> a = {"hello", "hwo", "are"};
tuple_size<a>::value;
tuple_element<1, a>::type;  // string
get<1>(a);                  
```

# 把array当做c风格的数组来用

```c++
//----------------------- array as c-style array ----------------------
RUN_GTEST(ArrayTest, CStyleArray, @);

// use array<char> as a fix sized c-string.
array<char, 100> str = {0};           // all elements initialized with 0.

char *p = str.data();

strcpy(p, "hello world");
printf("%s\n", p);              // hello world


END_TEST;
```

上面这个例子让我想起了std::string, 它有一个c_str()方法，同样是返回内部的c风格字符串，同样string也是STL的容器。

这让我想到，array的出现也是像string那样，是为了取代旧的c-风格字符串和内置数组，并且添加了标准容器的一些接口使得数组可以和STL其他组件和谐工作。

# 综合示例

```c++
//----------------------- normal example ----------------------
RUN_GTEST(ArrayTest, NormalExample, @);

array<int, 5> a = { 1, 2, 3 };
psln(a.size());                     // a.size() = 5;
psln(a.max_size());                 // a.max_size() = 5;
EXPECT_FALSE(a.empty());            // empty() is false.

printContainer(a, "array: ");       // array: 1 2 3 0 0

a[a.size() - 1] = 5;                // change last one
printContainer(a, "array: ");       // array: 1 2 3 0 5

a.at(a.size() - 2) = 4;
printContainer(a, "array: ");       // array: 1 2 3 4 5

int sum;
sum = accumulate(a.begin(), a.end(), 0);
psln(sum);                          // sum = 15

try
{
    int i = a.at(5);                // throw.
}
catch ( ... )
{
    pln("exception catched");
}

try
{
    //int i = a[5];                   // won't throw exception.
}
catch ( ... )
{
    pln("exception catched");       
}

// ------------------ copy ------------------
array<int, 5> a2 = a;                   // copy constructor.
printContainer(a2, "a2: ");             // a2: 1 2 3 4 5

array<int, 5> a3(a2);                   //copy ctor.
printContainer(a3, "a3: ");             // a3: 1 2 3 4 5


// ------------------ assign ------------------
array<int, 5> a4;
a4 = a3;                                // assignment operator.
printContainer(a4, "a4: ");             // a4: 1 2 3 4 5


array<int, 4> b = {};
//b = a;                                // error, b is not array<int, 5>!!


// ------------------ fill ------------------
array<int, 5> a5;
a5.fill(5);
printContainer(a5, "a5: ");             // a5: 5 5 5 5 5

// ------------------ move ------------------

// ------------------ array with class objects. ------------------


END_TEST;
```


# 注意事项

- swap的代价：O(n)

- 基本类型的默认构造是垃圾值，用初始化列表来避免

```c++
array<int, 3> a;            // no.
array<int, 3> a = {};       // good.
```



---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**欢迎访问[github博客](http://elloop.github.io)，与本站同步更新**



