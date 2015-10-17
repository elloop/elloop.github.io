---
layout: post
title: "c++中的结构体数组初始化"
category: c++
tags: [grammar]
description: ""
published: true
---

c++中结构体数组的初始化相对于c语言的结构体数组的初始化更为复杂一些。这是因为c++引入了构造函数，这意味着程序员可以自己决定每个结构体的构造方式，举个例子，一个拥有两个成员的结构体默认是需要两个成员来初始化的，而在c++中可能只需要一个成员就能完成初始化，这可以通过为该结构体定义一个接受一个值的构造函数来实现。

我将通过以下这种分类方式来讲解c++中结构体数组的初始化方法：

两种情况分类

## 只有默认构造函数的结构体
    - 简单结构体: 仅包含基本数据类型
        - 使用大括号{}
        - 不使用大括号{}

    - 复合结构体: 可能包含结构体
        - 使用大括号{}
        - 不使用大括号{}

## 带自定义构造函数的结构体
    - 使用大括号{}
    - 不使用大括号{}

请参考我的[training_ground项目中关于结构体数组初始化的测试代码]().

<!--more-->