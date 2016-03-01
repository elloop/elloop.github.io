---
layout: post
title: "【积水成渊-逐步定制自己的Emacs神器】3：为Emacs安装扩展"
category: tools
tags: [emacs]
description: ""
---

# 前言 #

本文介绍了如何使用Emacs的Package-Mode来为其安装扩展包，讲解如何添加新的Package源和如何安装Package。以安装一个新的主题包Solarizd和Markdown编辑扩展Markdown-Mode为例进行讲解。

# 查看Package列表：list-packages #

使用M-x list-packages命令可以查看所有packages的列表，此时Emacs进入Package Menu Mode。Emacs列出了所有可以安装、已经安装、可以更新的Package，使用C-h m来了解更多的操作帮助。



## Package源：package-archives ##

这个package列表是从网上down下来的，这个下载地址，Emacs里的专业叫法叫`Package Archives`，我称它为Package源。使用

`C-h v package-archives` 来查看package源这个变量的值，默认情况下，只有一个源，这导致Emacs的list-packages列表里包的数量不是很多。

## 添加Packag源 ##

`M-x customize-variable RET package-archives` : 还记得第二篇文章里的定制操作吧，使用customize-variable来修改这个package源变量。敲这个命令的时候记得多用TAB不用都敲。

进入之后可以看到当前的package源，点击下面的`INS`按钮来插入新的package源，输入一个名字，一个url链接，大家用的比较多的是melpa，名字和url可以分别这样填：

  * name：melpa
  * url：https://melpa.org/packages
  
填好之后的界面如下所示：

保存设置之后，再次使用M-x list-packages 就会看到包的数量明显增多。

注意：melpa这个package源需要科学上网才能拿到，而且连接速度貌似不是很快，我平均要连5s左右才能连上。

下面这篇文章里推荐了大陆用户一个package源，我还没使用过，如果不能科学上网的用户，可以试试：

[`("popkit" . "http://elpa.popkit.org/packages/")`](https://www.emacswiki.org/emacs/ELPA)

# 安装新主题 #

设置好了package源，现在可以给Emacs安装新的扩展了。

M-x list-packages 进入package列表，如果你已经在这个界面，按 "r" 键来刷新，重写连接。

以安装Solarized主题为例，按C-s来搜索 "solarized".

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

