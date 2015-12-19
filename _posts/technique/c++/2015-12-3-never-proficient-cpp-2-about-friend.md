---
layout: post
title: "【C++编程之杂项笔记】2: 关于类型前置声明"
category: c++
tags: c++
description: ""
published: true
---

## 前言

本文总结了c++中前置声明的写法及注意事项，列举了哪些情况可以用前置声明来降低编译依赖。

## 前置声明的概念

`前置声明`：(forward declaration), 跟普通的声明一样，就是个声明, 没有定义。之所以叫前置声明，看下面一小段代码：

```c++
class Useful;  // 对Userful类的前置声明

class Boss 
{
    Useful  *userful_;      // 实际要用到它的地方
};
```

<!--more-->

因为是在使用这个类型Userful之前告诉编译器，“哎，小编，Userful是个类，我要用它，你别管，它在某个地方是个真实的存在(也可能不存在，我就tm忽悠你的), 总之你不要管，我要用它”。这样跟编译器打过招呼之后，就能保证代码编译通过。Useful是在Boss使用它之前声明的，所以叫它`前置`声明.

作为一名c/c++程序员，合理使用前置声明可以使我们的生活更美好。因为它省去了#include的处理、降低文件之间的编译依赖，从而避免不必要的编译时间浪费。

## 使用前置声明的利弊

**优点**： 避免#include, 避免修改一个被包含的头文件，导致整个文件重新编译

**缺点**: (摘自[Google C++ 编程风格](http://zh-google-styleguide.readthedocs.org/en/latest/google-cpp-styleguide/headers/#forward-declarations) )

- 如果前置声明关系到模板，typedefs, 默认参数和 using 声明，就很难决定它的具体样子了。

- 很难判断什么时候该用前置声明，什么时候该用 #includes, 特别是涉及隐式转换运算符的时候。极端情况下，用前置声明代替 includes 甚至都会暗暗地改变代码的含义。

- 前置声明了不少来自头文件的 symbol 时，就会比单单 includes 一行冗长。

- 前置声明函数或模板有时会害得头文件开发者难以轻易变动其 API. 就像扩大形参类型，加个自带默认参数的模板形参等等。

- 前置声明来自命名空间 std:: 的 symbol 时，其行为未定义。

- 仅仅为了能前置声明而重构代码（比如用指针成员代替对象成员），后者会变慢且复杂起来。

- 还没有实践证实前置声明的优越性。

## 前置声明所包含的类型

- class(struct)
- function
- template
- typedef

## 可以使用前置声明的情形

**1. 以指针或引用的形式来引用类型**

```c++
class A;

class B 
{

    A   *pa_;   // ok
    A   &ra_;   // ok

    A* f(const A *pa);    // ok
    A& f(const A &pa);    // ok

};
```

**2. 友元**

```c++
class A;
class B 
{
    friend A;               // ok, after c++11.
    friend class A;         // ok, not tested.
};
```

**3. typedef**

```c++
class A
{
    typedef int AInt;
};

class B
{
    A::AInt     *a_;    // ok, todo: test this.
};
```


**3. 不定期持续更新**

## 不可以使用前置声明的情形

**1. 使用完成的类型来引用**

```c++
class A;

class B
{
    A   a_;         // error

    void f(A a);    // error

    A g();          // error
};
```

**2. 被当做父类时**

```c++
class A;

class B : public A      // error
{
};
```

**3. 不定期持续更新**

## 前置声明与作用域

**1. in namespace**

```c++
namespace somewhere
{
    class A;
}

class B
{
    somewhere::A    *pa_;   // ok
};
```

**2. in class**

```c++
namespace ns1 
{
    class A 
    {
        typedef vector<int> IntArray;
    };
}

class B
{
    void f(const ns1::A::IntArray &ary);    // ok. todo: test this.
};
```

## TODO

1. pimpl 方案.
2. typedef in class.
3. sample codes url.

