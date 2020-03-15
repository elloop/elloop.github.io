---
layout: post
title: "【C++ OpenGL ES 2.0编程笔记】1: OpenGL ES 2.0 渲染管线和EGL"
category: OpenGL
tags: [opengl]
description: ""
---

**作者是现在对相关知识理解还不是很深入，后续会不断完善。因此文中内容仅供参考，具体的知识点请以OpenGL的官方文档为准**

# 前言

本文介绍了OpenGL ES 2.0的渲染管线：Graphics Pipeline和作为OpenGL API和本地窗口之间接口的EGL.

# 渲染管线总览 Graphics Pipeline

![es2_pipeline.png](http://7xi3zl.com1.z0.glb.clouddn.com/es2_pipeline.png)

<!--more-->

# 顶点着色器：Vertex Shader

![vertex_shader.png](http://7xi3zl.com1.z0.glb.clouddn.com/vertex_shader.png)

# 图元装配：Primitive Assembly

# 光栅化：Rasterization

![Rasterization.png](http://7xi3zl.com1.z0.glb.clouddn.com/Rasterization.png)

# 片段着色器：Fragment Shader

![fragment_shader.png](http://7xi3zl.com1.z0.glb.clouddn.com/fragment_shader.png)

# 每片段(像素)操作：Per-Fragment Operations

![per_fragment_op.png](http://7xi3zl.com1.z0.glb.clouddn.com/per_fragment_op.png)

# 帧缓冲：Framebuffer

# EGL

# 参考

- [The OpenGL ES 2.0 programming guide / Aaftab Munshi, Dan Ginsburg, Dave Shreiner (2008)](http://book.douban.com/subject/3175883/) 

---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

