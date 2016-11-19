---
layout: post
title: "python目录操作"
category: python
tags: [python]
description: ""
---


# 前言 

本文总结了python编程中目录操作相关的知识点。

<!--more-->

## 路径相关

**os.curdir **

The constant string used by the operating system to refer to the current directory. This is '.' for Windows and POSIX. Also available via os.path.

**os.pardir **

The constant string used by the operating system to refer to the parent directory. This is '..' for Windows and POSIX. Also available via os.path.

**os.sep **

The character used by the operating system to separate pathname components. This is '/' for POSIX and '\\' for Windows. Note that knowing this is not sufficient to be able to parse or concatenate pathnames — use os.path.split() and os.path.join() — but it is occasionally useful. Also available via os.path.

**os.altsep **

An alternative character used by the operating system to separate pathname components, or None if only one separator character exists. This is set to '/' on Windows systems where sep is a backslash. Also available via os.path.

**os.extsep **

The character which separates the base filename from the extension; for example, the '.' in os.py. Also available via os.path.

**os.pathsep **

The character conventionally used by the operating system to separate search path components (as in PATH), such as ':' for POSIX or ';' for Windows. Also available via os.path.

**os.defpath **

The default search path used by exec*p*() and spawn*p*() if the environment doesn’t have a 'PATH' key. Also available via os.path.

**os.linesep **

The string used to separate (or, rather, terminate) lines on the current platform. This may be a single character, such as '\n' for POSIX, or multiple characters, for example, '\r\n' for Windows. Do not use os.linesep as a line terminator when writing files opened in text mode (the default); use a single '\n' instead, on all platforms.

**os.devnull **

---------------------------

*作者水平有限，对相关知识的理解和总结难免有错误，还望<font color="red">给予指正，非常感谢！</font>**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

---------------------------

**自问自答**

<font color="red">问： 有些知识虽然浅显易懂，为什么还要写下来, 这不是浪费时间吗？ </font>

<font color="blue">答：错，恰恰是为了节省时间! 把第一次看这些知识点的收获和感悟总结并记录下来，下次再次用到这些知识点的时候，翻出来记录便可快速把大脑的思维栈还原到第一次看完这个知识点的状态，可以将当时的收获和感悟快速投入使用，避免了因为长期不用这个知识点而重新去研究和测试这个东西造成的多次时间浪费。</font>

<font color="blue">此外，记录下自己的感悟也是暴露自己思维缺陷和错误的机会，日后自己或他人便可有机会指出错误之处，从错误中学习成长不失为一条进步的捷径。</font>

