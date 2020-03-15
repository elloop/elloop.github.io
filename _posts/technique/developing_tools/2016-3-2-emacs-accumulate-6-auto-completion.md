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

本文提到的几个package(或mode)：

  * ido-mode
  * [auto-complete](https://github.com/auto-complete/auto-complete) 
  * [company](http://company-mode.github.io/)
  * [yasnippet](https://github.com/capitaomorte/yasnippet)

<!--more-->

# 缓冲区名字补全: ido-mode #

在使用C-x b或者M-x dired输入缓冲区名字或者路径名字的时候，需要记住使用过的缓冲区或者文件目录的结构，这使得用户要输入记住和输入很多东西，增加了使用Emacs的困难程度。

ido-mode解决了这个问题，它会在我切换缓冲区或者要使用C-x C-f查找文件的时候，自动为我列出匹配项目，我仅需键入有限的几个输入，或者根本不用输入，直接使用C-s向后选择ido-mode给提供的选项，使用C-r向前选择，然后回车即可选中。

要打开ido-mode，使用M-x customize，然后搜索ido，找到ido-mode打开即可，你可以让它只作用于buffer补全或者只作用于文件补全，也可以同时作用。

要想让ido-mode支持模糊匹配，还需要打开：Ido Enable Flex Matchin。

# auto-complete 补全 #

auto-complete这个package是很多以auto-complete-开头的其它package的基础，所以要想使用这个系列的补全插件要先安装auto-complete。

根据我的使用情况auto-complete package可以在一下两个package archive(package源，见第三篇文章)找到：

  * ("melpa" . "https://melpa.org/packages/")
  * ("marmalade" . "http://marmalade-repo.org/packages/")

确保添加了上面任何一个package archive之后，执行：

`M-x package-install RET auto-complete RET` 进行安装。

也可以使用前面第三篇文章里，使用M-x list- package进入包安装界面，搜索auto-complete来进行安装。

# company-mode ：complete anything #

[company](https://github.com/company-mode/company-mode)是Emacs中一个文本补全框架，正如其名字，它可以补全任何东西。使用也很简单。

网上有关于company和auto-complete功能比较的讨论：[More info about how this compares to auto-complete](https://github.com/company-mode/company-mode/issues/68)

具体使用哪个更合适，我现在还没有结论，要自己尝试后才能知道哪个更适合自己。

# yasnippet: template complete #

[yasnippet](https://github.com/capitaomorte/yasnippet)跟Vim中的UltiSnip很像，可以自己定义补全模板，定义模板中光标的停留地点和跳转顺序等。

yasnippet甚至支持在自定义模板的时候嵌入Elisp代码。

yasnippet针对每个mode可以有一套补全的模板，模板文件在yasnippet/snippets/下面，按照mode名字单独存放。

---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

