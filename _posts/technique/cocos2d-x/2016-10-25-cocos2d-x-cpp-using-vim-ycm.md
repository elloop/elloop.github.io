---
layout: post
title: "【cocos2d-x 学习与应用总结】使用vim编写cocos2d-x c++代码，自动补全"
category: [cocos2d-x]
tags: [cocos2d-x, game]
published: true
description: ""
---

# 前言


遇到的问题：

1. 新添加或者Classes目录下的cpp文件没有生成compile json补全信息

每个CMakeList脚本都要添加compile commands 选项

{% highlight c++ %}
set(CMAKE_EXPORT_COMPILE_COMMANDS 1)
{% endhighlight %}

<!--more-->
    

---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

