---
layout: post
title: "【OpenGL ES 2.0编程笔记】5: mipmap"
category: OpenGL
tags: [opengl]
description: ""
---

# 前言

本文介绍了如何使用OpenGL ES 2.0 API实现纹理图片的叠加显示效果。

>在三维计算机图形的贴图渲染中有一个常用的技术被称为Mipmapping。为了加快渲染速度和减少图像锯齿，贴图被处理成由一系列被预先计算和优化过的图片组成的文件,这样的贴图被称为 MIP map 或者 mipmap。这个技术在三维游戏中被非常广泛的使用。“MIP”来自于拉丁语 multum in parvo 的首字母，意思是“放置很多东西的小空间”。Mipmap 需要占用一定的内存空间，同时也遵循小波压缩规则 （wavelet compression）



#开发环境及相关库

- vs2013 / C++

- libEGL.lib   : windows上的OpenGL ES环境

- libGLESv2.lib : OpenGL ES 2.0 API

- d3dcompiler_47.dll : 使用DX来模拟OpenGL

- FreeImage.lib/dll : 加载纹理数据

- 代码架构： 仿cocos2d-x结构，启动点在ELAppdelegate.cpp.

# 效果图：

<!--more-->

![dog_texture.gif](http://7xi3zl.com1.z0.glb.clouddn.com/dog_texture.gif)

# 实现代码：

# shader

顶点着色器：`multi_texture_vs.glsl`

```c++
```

片段着色器：`multi_texture_fs.glsl`

```c++
```


有空的时候再来补充注释及说明，想了解更多内容请参考源码部分。

# 遇到的问题

# 完整项目源码

源码中包含

- [OpenGL-ES-2.0-cpp](https://github.com/elloop/OpenGL-ES-2.0-cpp)

如果源码对您有帮助，请帮忙在github上给我点个Star, 感谢 :)

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

