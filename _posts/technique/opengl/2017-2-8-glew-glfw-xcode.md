---
layout: post
title: "【OpenGL Programming On macOS using glfw 】1: 使用Xcode, glfw, glew开发OpenGL 4.x"
category: [OpenGL]
tags: [opengl]
description: ""
---

# 前言

0. install Xquatz

1. install glew 

{% highlight bash %}
cd build
cmake ./cmake
make -j4
make install
{% endhighlight %}

2. install glfw

{% highlight bash %}
md build && cd build
cmake ..
make 
make install
{% endhighlight %}
3. create command line cpp project in Xcode

<!--more-->

4. search path

1) lib: /usr/local/lib, /opt/X11/lib

2) header: /usr/local/include, /opt/X11/include

5. link error for glfw

link with CoreFundation.Framework, IOKit, CoreVideo, ....

6. 

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

