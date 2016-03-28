---
layout: post
title: "Visual Studio常用的预定义环境变量(以Visual Studio 2013为例)"
category: tools
tags: [visual studio]
description: ""
---

# 前言 #

本文总结了Visual Studio中常见的环境变量及其在组织解决方案、工程中的作用。

注：本文使用的是Visual Studio 2013，由于作者主要从事c/c++开发，所以是以Visual C++的工作环境配置来描述。

# 什么vs的环境变量？

先看图吧，图中以美元符号$开头 + 一对括号，这样进行引用的就是我所谓的环境变量，举几个例子，比如常见的：

|*环境变量名*|*含义*|
|---------------|----------------|
| $(SolutionDir) | 解决方案目录：即.sln文件所在路径 |
|$(ProjectDir)| 项目文件所在路径：即.vcproj所在路径|
|$(OutDir)|输出文件路径：`在项目属性 -> 常规 里面可以看到，并设置其值`|



# 进阶

## 如何定义、扩展VS的环境变量？


---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

