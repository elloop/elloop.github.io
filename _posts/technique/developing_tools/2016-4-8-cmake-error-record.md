---
layout: post
title: "【使用CMake组织C++工程】-1：CMake 常见错误记录"
category: tools
tags: [cmake]
description: ""
---

# 前言

本文记录CMake使用中需要注意的问题。

<!--more-->

## `add_subdirectory` error specifying an out-of-tree source.

>CMake Error at CMakeLists.txt:11 (add_subdirectory):
  add_subdirectory not given a binary directory but the given source
  directory "/Users/sunyongjian1/codes/CS.cpp/include/gtest" is not a
  subdirectory of "/Users/sunyongjian1/codes/CS.cpp/Algorithm".  When
  specifying an out-of-tree source a binary directory must be explicitly
  specified.

--root

----dir1/

------CMakeLists.txt    : add_subdirectory(${CMAKE_CURRENT_LIST_DIR}../dir2)

----dir2/

------CMakeLists.txt

被包含的子目录并不真正是其子目录，如果想要包含一个不在当前工程目录树下的子项目，需要显示指定。

如上所示，dir2 并不是 dir1的子目录。

解决：目录结构不合理，重新组织CMake构建目录，确保被包含的目录确实是包含目录的子目录.

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

