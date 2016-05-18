---
layout: post
title: "【重识Lua】1：从源码安装lua"
category: lua
tags: [lua]
description: ""
published: true
---

<font color="red">自从13年开始做手游接触lua，始终是边写边学，缺乏对lua更加全面系统的学习，这几篇文章开始“重识lua”, 把欠下的帐还回来。</font>

# 前言

本文以lua-5.1为例，说明如何从源代码生成二进制的lua和luac可执行文件。PC操作系统以Mac为例。

# 下载lua源代码

这里是：[lua官网各个版本的下载地址](https://www.lua.org/versions.html)

下载Lua 5.1

# 编译出lua和luac

解压下载的lua-5.1.tar.gz压缩包, 得到如下的目录结构：

{% highlight c++ %}
➜  /Users/sunyongjian1/codes/lua/lua-5.1 l
total 56
drwxr-xr-x@ 12 lina  staff   408B  2 20  2006 .
drwxr-xr-x   5 lina  staff   170B  5 18 22:46 ..
-rw-r--r--@  1 lina  staff   1.5K  1  7  2006 COPYRIGHT
-rw-r--r--@  1 lina  staff   7.7K  2 20  2006 HISTORY
-rw-r--r--@  1 lina  staff   3.7K  1 26  2006 INSTALL
-rw-r--r--@  1 lina  staff   2.2K  2 20  2006 MANIFEST
-rw-r--r--@  1 lina  staff   3.5K  2 16  2006 Makefile
-rw-r--r--@  1 lina  staff   1.3K  1 19  2006 README
drwxr-xr-x@ 11 lina  staff   374B  2 13  2006 doc
drwxr-xr-x@ 12 lina  staff   408B  2  9  2006 etc
drwxr-xr-x@ 58 lina  staff   1.9K  5 18 23:10 src
drwxr-xr-x@ 22 lina  staff   748B  8 12  2005 test
{% endhighlight %}

要编译安装lua，其实按照INSTALL操作就行了。

如果不需要安装lua到系统，仅仅是搞个lua可执行程序出来用，那仅需如下两步：

在lua-5.1为当前目录：

**第一步：在命令行敲入make**

输出如下：

{% highlight c++ %}
➜  /Users/sunyongjian1/codes/lua/lua-5.1 make
Please do
   make PLATFORM
where PLATFORM is one of these:
   aix ansi bsd generic linux macosx mingw posix solaris
See INSTALL for complete instructions.
{% endhighlight %}

找到自己的平台，即macosx

**第二步: make macosx**

可以看到开始编译lua源代码了，执行完毕并且没有报错的话，就能在lua-5.1/src目录下看到生成的lua和luac二进制程序了。

进入src目录，输入 ./lua 就可以进入交互式的lua解释程序中了。

# make install 安装到系统

如果要把lua安装到系统，那么在前两步骤的基础上，再加上第三步：

**make install**

输出如下：

{% highlight c++ %}
➜  /Users/sunyongjian1/codes/lua/lua-5.1 make install
cd src && mkdir -p /usr/local/bin /usr/local/include /usr/local/lib /usr/local/man/man1 /usr/local/share/lua/5.1 /usr/local/lib/lua/5.1
cd src && cp lua luac /usr/local/bin
cd src && cp lua.h luaconf.h lualib.h lauxlib.h ../etc/lua.hpp /usr/local/include
cd src && cp liblua.a /usr/local/lib
cd doc && cp lua.1 luac.1 /usr/local/man/man1
{% endhighlight %}

可以看到，这个操作就是把头文件、库文件、文档拷贝到系统目录中。

# 定制编译过程

lua源代码的结构很简单，定制编译过程就是修改Makefile或src/luaconf.h:

- 控制把lua安装到哪里，怎样安装lua —— 编辑Makefile

- 控制怎样编译构建lua —— 编辑src/Makefile.

- 控制lua功能特性 —— 编辑src/luaconf.h.

更多细节请参考INSTALL.

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**



