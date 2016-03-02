---
layout: post
title: "【积水成渊-逐步定制自己的Emacs神器】4：Emacs自动补全"
category: tools
highlighter_style: monokai
tags: [emacs]
description: ""
---

# 前言 #

本文介绍了Emacs里的自动补全功能，包括其内置的缓冲区文件名补全和使用扩展package实现的文本的补全和程序代码的补全功能等。

<!--more-->

# 缓冲区名字补全: ido-mode #

在使用C-x b或者M-x dired输入缓冲区名字或者路径名字的时候，需要记住使用过的缓冲区或者文件目录的结构，这使得用户要输入记住和输入很多东西，增加了使用Emacs的困难程度。

ido-mode解决了这个问题，它会在我切换缓冲区或者要使用C-x C-f查找文件的时候，自动为我列出匹配项目，我仅需键入有限的几个输入，然后回车即可。

要打开ido-mode，使用M-x customize，然后搜索ido，找到ido-mode打开即可，你可以让它只作用于buffer补全或者只作用于文件补全，也可以同时作用。

要想让ido-mode支持模糊匹配，还需要设置：

# auto-complete 代码补全 #

根据我的使用情况auto-complete package可以在一下两个package archive(package源，见第三篇文章)找到：

  * ("melpa" . "https://melpa.org/packages/")
  * ("marmalade" . "http://marmalade-repo.org/packages/")

确保添加了上面任何一个package archive之后，执行：

`M-x package-install RET auto-complete RET` 进行安装。

也可以使用前面第三篇文章里，使用M-x list- package进入包安装界面，搜索auto-complete来进行安装。






---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

