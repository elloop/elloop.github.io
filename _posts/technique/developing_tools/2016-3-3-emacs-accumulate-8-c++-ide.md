---
layout: post
title: "【积水成渊-逐步定制自己的Emacs神器】6：首次变身IDE，Emacs C++ IDE"
category: tools
highlighter_style: monokai
tags: [emacs]
description: ""
---

# 前言 #

本文开始介绍如何把Emacs打造成一个C++ IDE。目标是可以在这个IDE中，可以高效地浏览Linux Kernel源代码，比如跳转到光标处的定义或引用，常见的C++ IDE中前进和后退的功能，快速访问文件，在.h/.cpp间跳转，代码语义补全，头文件补全，可视化的GDB调试环境等等。

如果想直接尝试体验，可以到这里下载配置好的Emacs配置：[emacs-c-ide-demo](https://github.com/tuhdo/emacs-c-ide-demo)

这个配置是从这篇文章里得到的：[C/C++ Development Environment for Emacs](http://tuhdo.github.io/c-ide.html#sec-2)，这篇文章写的特别好，也是我主要的参考对象之一。


先列一下要安装的package：

  * [auto-complete](https://github.com/auto-complete/auto-complete) :自动补全插件，自动补全功能的基础，在上一篇文章中已经讲解过安装方法
  * [yasnippet](https://github.com/capitaomorte/yasnippet) : 代码模板
  * [auto-complete-c-headers](https://github.com/mooz/auto-complete-c-headers) ：自动补全header name
  * [company](http://company-mode.github.io/)：complete anything，任何内容补全
  * 未完待续。。。

最近有些忙，抽空来一点点补充。。。。。
  
<!--more-->

下面分别讲解如何安装这些package和如何针对这些package添加配置代码到.emacs.d/init.el中。

# 安装package #

## yasnippet ##

[官方推荐](https://github.com/capitaomorte/yasnippet)package-install的方法，本系列的第二篇文章有安装package的方法。如果想安装最新的版本可以直接git clone --recursive https://github.com/capitaomorte/yasnippet

根据我自己的折腾体验，推荐使用git来安装最新版本。原因是即使我使用了科学上网的方法还是经常连接不到Melpa-package archive，而仅仅使用一个elpa archive安装的yasnippet版本还是0.8，并且在snippets目录下几乎没有定义好的snippet直接拿来用。

我一开始是使用了package-install的方法来安装的，在我的Emacs配置文件中加入下面两行配置来启用yasnippet的全局模式：

{% highlight lisp %}
(require 'yasnippet)
(yas-global-mode 1)
{% endhighlight %}
重启Emacs，或者使用C-x C-e来执行这两行脚本，确保配置已生效之后，新建一个.cpp文件，来查看效果。

注意，yasnippet能够扩展的关键字是在其配置文件中写好的，如果你安装的时候没有配置文件，或者配置文件不全，那么能够扩展的关键字也不会很全。拿我安装的yasnippet-0.8为例，我试图扩展while的时候，没有任何反应，我还以为是自己没有装好这个package，可是重新安装也还是这个样。后来看了[官方文档](https://github.com/capitaomorte/yasnippet#where-are-the-snippets)才知道，snippet(也就是所谓的配置文件)是放在`<yasnippet安装目录>/snippets/`文件夹下的，首先要检查在这个文件夹下是否有东西，如果没有，那么无论我在cpp文件中输入什么关键字它都不会为我做扩展的。还好，我的snippets目录下是有东西的，我进入snippets/c++-mode/下，看到了只有几个文件，而且里面只有几行文本，我看到了using,template, class几个关键字，原来如此，刚装好的yasnippet-0.8里面几乎没有定义c++-mode下的snippet，试了一下using + TAB，扩展成了using namespace std; 试了一下class，扩展成立一个class定义。看来安装没问题了，只需要扩充c++-mode下的snippets就行了。去官网看看有没有，果然，官网的c++-mode/下面有好多东西。yasnippet的[snippets这个sub module](https://github.com/AndreaCrotti/yasnippet-snippets/tree/6017e7489b4d9202ea092cfd5f1281356e3e12fe)就专门是snippet的特辑。把它们下载下来放到自己的sinppets目录就行了。因为这增加了自己下载的过程，不如git安装方式，直接敲一个命令就行了。

**小结**

安装yasnippet的两种方式：

  * git clone --recursive https://github.com/capitaomorte/yasnippe : 简单直接，但是除了下载yasnippet和snippets之外，还会下载一些可能对你没用的东西。
  * package-install方式：如果连不上Melpa源，或者即使连上了，安装成功后的目录里可能没有snippets，需要自己到官方仓库下载snippts。

这两种方式都需要在Emacs配置中加入上面提到的两句话。对于使用git下载的方式，还要记得把yasnippet所在目录加入到load-path，做法与第二篇文章中安装Markdown-mode的做法一样：

{% highlight lisp %}
(add-to-list 'load-path "yasnippet所在的目录")
{% endhighlight %}

## auto-complete-c-headers ##





## 缩进风格 ##





---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

