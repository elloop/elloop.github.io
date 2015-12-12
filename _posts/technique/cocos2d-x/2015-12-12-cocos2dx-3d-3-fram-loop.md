---
layout: post
title: "【cocos2d-x 3D游戏开发】3: 游戏帧循环"
highlighter_style: solarizeddark
category: [cocos2d-x]
tags: [cocos2d-x, game]
description: ""
published: false
---

## 前言

本文将对cocos2d-x引擎中每一帧里面做了哪些事情进行介绍，总结每一帧中的几个关键操作，及它们在时间上的先后顺序。以win32环境为例，讲解一个游戏的主循环的控制流程。

<!--more-->


## 游戏的启动

<font color="red">窗口的创建及OpenGL初始化</font>

**1. wgl**


**2. glew**

OpenGL Extension Wrangler Library, a cross-platform open-source c/c++ extension loading library.
GLEW provides efficient run-time mechanisms for determining which OpenGL extensions are supported on the target platform
