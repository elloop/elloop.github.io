---
layout: post
title:"【积水成渊-逐步定制出自己的Emacs神器】1：Emacs入门"
category: tools
tags: [git]
description: ""
---

# 前言 #

本文介绍了Emacs编辑器的入门知识，看完本文读者会知道Emacs的基本用法以及如何通过Emacs来学习Emacs，这会让你觉得整个学习Emacs的过程都是在被“授之以渔”。

<!--本系列文章的目录在这里。该系列文章的目的是通过逐渐的学习和借鉴别人的Emacs配置，最终打造一个适合于自己的Emacs编辑器，提高做事的效率。-->

作者使用的Emacs版本是24.3。

# 下载和安装 #

Emacs的安装很简单，去[官网](https://www.gnu.org/software/emacs/)的[Obtaining](https://www.gnu.org/software/emacs/#Obtaining)部分就能看到下载的镜像地址。

# 如何学习Emacs #

<!--more-->

## 入门必看：Emacs Tutorial ##

进入Emacs Tutorial的方法：`C-h t`，即Ctrl+h，然后按t。

Tutorial里面你会掌握基本的键盘操作和Emacs里面的一些基本概念。这一步是初学者必看的基础知识，要继续往下学习之前请务必看完Tutorial并进行一些必要的练习。

## Emacs Info 和 Emacs Manual ##

在掌握了Tutorial里的基础知识后，Emacs的Info Mode会成为你主要的学习场所。

Emacs Info是一个菜单列表，下面我叫它Info Mode，它列出了Emacs的一些关键部分，鼠标单击菜单项即可进入帮助文档页面。Info Mode定义了很多快捷键用来在Info系统里导航，使用`C-h m`来查看这些快捷键(`C-h m`命令的作用是：查看当前Mode的帮助信息)。

比如，m在Info Mode里是选择菜单的意思，按下m，在下方的小窗口中(minibuffer)，Emacs会问你：你要选哪个菜单项？，然后等待你的输入，你输入：Emacs RET, 这样就进入了Emacs Manual。RET就是回车键的意思。

Emacs Manual就是Emacs编辑器的帮助手册。里面有对Emacs个方面的详细介绍，要掌握Emacs对这个手册的学习和参考当然是很重要也是很方便的。Emacs Manual仍然是在Info Mode下，因此你可以继续使用Info Mode下的快捷键来浏览。这就是所谓的“在Emacs中学习Emacs”。

## Self Documentation ##

对于工作中的我们来说，学习东西通常是边用边学，不大可能有人整天在Emacs Manual里学习。在使用过程中会产生很多疑问，比如忘记了某个命令的含义、忘记了某个Mode下的快捷键、想知道某个变量的含义等等，这个时候你不需要Google，只要问Emacs就好了。

怎么问Emacs呢？

Emacs是一个“自文档化”的软件(Self-Documenting)，任何你能看到的东西，比如：命令、按键序列、菜单项，或者是某个出现在文档里的术语，这些东西都可以在Emacs内部找到答案，你只需使用`C-h`前缀开头的几个命令就能知道任何问题的答案。它们的使用方法如下：

1. C-h k 会告诉你任何命令的帮助信息
2. 使用C-h k来询问Emacs其他帮助命令的作用，比如：C-h f, C-h v, C-h w, C-h m, C-h b, C-h a, C-h k等等。比如我要知道C-h k自己是用来干嘛的，我可以：C-h k C-h k
3. 使用C-h系列的命令来获取任何帮助
4. C-h C-h用来查看“帮助的帮助”


## EmacsWiki ##

[专门提供Emacs帮助文档和Emacs Lisp学习文档的网站](https://www.emacswiki.org)

在这里能学到Emacs Manual中没有的东西，有很多前人总结的经验。对于入门的用户，这篇文章是很有帮助的：[Self Documentation](https://www.emacswiki.org/emacs/SelfDocumentation)

## 入门视频教程 ##

Youtube上有很多Emacs的入门视频教程，你需要科学上网才能看到。这里先推荐一个做的比较好的入门视频：

[Emacs入门视频](https://www.youtube.com/watch?v=MRYzPWnk2mE)

# 彩蛋：在Emacs中玩游戏 #

C-h i 进入Info Mode, 输入mEmacs进入Emacs Manual，输入mAmusement, 进入游戏帮助界面，可以查看所有可玩的游戏。
这些游戏的进入方式是：`M-x + <game-name>`, 比如，我要玩俄罗斯方块(tetris), 我就输入：M-x tetris. 

不知道怎么玩？ 问Emacs，还记得怎么获得当前Mode下的帮助吗？ 对，`C-h m`即可。下图是Emacs中俄罗斯方块的画面和右侧的帮助信息。

![Emacs中玩俄罗斯方块.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/tetris.jpg)

# 下集预告  #

想知道在上图中我是如何把Emacs主题变成Solarized主题的吗？并且是如何去掉了菜单栏、工具栏和滚动条，有更大的空间来展示文本信息。

下一篇文章将讲解如何定制Emacs的外观，让它变成你喜欢的样子，并且讲解如何比较方便的让你的Emacs配置做到“一次配置，随处可用”。


# 有意思的链接 #

  * [为什么Emacs的快捷键设计让人容易疼痛](http://ergoemacs.org/emacs/emacs_kb_shortcuts_pain.html)
  * [如何避免使用Emacs造成的疼痛问题](http://ergoemacs.org/emacs/emacs_pinky.html)
  * [最适合Emacs的键盘](http://ergoemacs.org/emacs/emacs_best_keyboard.html)
  * [人体工学的Emacs键盘按键映射方案](https://ergoemacs.github.io/)
  * [所有解决方案都让你不爽，你就是喜欢VIM的按键风格，那就在Emacs中使用VIM：Evil Mode](https://www.emacswiki.org/emacs/Evil)


---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**
