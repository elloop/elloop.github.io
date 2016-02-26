---
layout: post
title: "【积水成渊-逐步定制出自己的Emacs神器】1：Emacs入门"
category: tools
tags: [git]
description: ""
---

#前言

<!--本系列文章的目录在这里。该系列文章的目的是通过逐渐的学习和借鉴别人的Emacs配置，最终打造一个适合于自己的Emacs编辑器，提高做事的效率。-->

本文介绍了Emacs编辑器的入门知识，看完本文读者会知道Emacs的基本用法以及如何通过Emacs来学习Emacs。

作者使用的Emacs版本是24.3。

# 下载和安装 #

# 如何学习Emacs #

## 入门必看：Emacs Tutorial ##

进入Emacs Tutorial的方法：`C-h t`，即Ctrl+h，然后按t。

Tutorial里面你会掌握基本的键盘操作和Emacs里面的一些基本概念。

## Emacs Info 和 Emacs Manual ##

Emacs Info是一个菜单列表，下面我叫它Info Mode，它列出了Emacs的一些关键部分，鼠标单击菜单项即可进入帮助文档页面。Info Mode定义了很多快捷键用来在Info系统里导航，使用`C-h m`来查看这些快捷键(`C-h m`命令的作用是：查看当前Mode的帮助信息)。

比如，m在Info Mode里是选择菜单的意思，按下m，在下方的小窗口中(minibuffer)，Emacs会问你：你要选哪个菜单项？，然后等待你的输入，你输入：Emacs RET, 这样就进入了Emacs Manual。

Emacs Manual就是Emacs编辑器的帮助手册。里面有对Emacs个方面的详细介绍，要掌握Emacs对这个手册的学习和参考当然是很重要也是很方便的。Emacs Manual仍然是在Info Mode下，因此你可以继续使用Info Mode下的快捷键来浏览。这就是所谓的“在Emacs中学习Emacs”。

## Self Documentation ##

对于工作中的我们来说，学习东西通常是边用边学，不大可能有人整天在Emacs Manual里学习。在使用过程中会产生很多疑问，比如忘记了某个命令的含义、忘记了某个Mode下的快捷键、想知道某个变量的含义等等，这个时候你不需要Google，只要问Emacs就好了。

Emacs是一个“自文档化”的软件(Self-Documenting)，任何你能看到的东西，比如：命令、按键序列、菜单项，或者是某个出现在文档里的术语，这些东西都可以在Emacs内部找到答案，你只需使用`C-h`前缀开头的几个命令就能知道任何问题的答案。它们的使用方法如下：

## EmacsWiki ##

## 入门视频教程 ##


---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**









