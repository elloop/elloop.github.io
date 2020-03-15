---
layout: post
title: "How do you judge an experienced C programmer by only five questions?"
category: [c++]
tags: [c++]
description: ""
---

Given the following declaration:

int foo[10];

What is the difference between:

**foo**

and:

**&foo**

and:

**&foo[0]**

?

Hint: two of them are identical, the other is very different, but if you print them:

**printf("%p, %p, %p\n", foo, &foo, &foo[0]);**

they'll all print the same value.

<!--more-->

The first and third are both pointers to int. The second is a pointer to an array of ten ints.

They all have the same value, but if you add one to the first and third, you increment by the sizeof(int), if you add one to the second you increment by `10*sizeof(int)`

They have the same value, but they have different types.




---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**



