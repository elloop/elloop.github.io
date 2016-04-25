---
layout: post
title: "python目录操作相关知识"
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

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**






