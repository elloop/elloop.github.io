---
layout: post
title: "terminology in c++"
category: c++
tags: [stl]
description: ""
published: false
---


# 前言

- ADL: Argument-dependent name lookup, [wiki](https://en.wikipedia.org/wiki/Argument-dependent_name_lookup)

- the big three and a half

    or rule of three: [rule of three](http://stackoverflow.com/questions/4172722/what-is-the-rule-of-three)

- sfinea

- copy and swap idiom

- Exception safety 

    
There are several levels of exception safety (in decreasing order of safety):

1. No-throw guarantee, also known as failure transparency: Operations are guaranteed to succeed and satisfy all requirements even in exceptional situations. If an exception occurs, it will be handled internally and not observed by clients.

2. Strong exception safety, also known as commit or rollback semantics: Operations can fail, but failed operations are guaranteed to have no side effects, so all data retain their original values.[4]

3. Basic exception safety, also known as a no-leak guarantee: Partial execution of failed operations can cause side effects, but all invariants are preserved and there are no resource leaks (including memory leaks). Any stored data will contain valid values, even if they differ from what they were before the exception.

4. No exception safety: No guarantees are made.

<!--more-->

---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**



