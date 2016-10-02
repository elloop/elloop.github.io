---
layout: post
title: "【APUE 学习笔记】0: Unix开发环境搭建"
category: [linux, c++]
tags: [linux, shell]
description: ""
---

# 前言

本文介绍了如何为Unix环境下C/C++系统编程搭建开发环境:


- 操作系统: macOS 10.11.5

- 开发工具：Vim 7.4(patches: 1-1952) + YCM( YouCompleteMe ) + Clang++

- 编译构建：CMake 3.0+

- 调试工具：Xcode和GDB/LLDB

<!--more-->

# 关于OS

macOS已被验证为是Unix，所以在此系统做Unix开发是可行且适合的。

# 开发工具

若是在Windows平台做C++开发那恐怕没有哪个工具的开发效率能比得上vs + va （+ vim插件）。 最近传说vs可以支持远程调试linux下的代码，笔者没有做尝试，虽然跟vs有比较深厚的感情，但是, 你懂的，本来使用unix对程序员来说就更有一种“仪式感”。更何况这是要开发unix程序。

macOS上的IDE我用过Xcode，QtCreator, CLion，CodeBlock，能用，但是作为一个追求效率和“逼格”的程序员，做到自己定制的工具才是最舒服的。尤其是习惯了vim或者emacs编辑效率的人，恨不得一切都用他们习惯的编辑器来搞定, 对于这种人来说，如果要他们在写代码过程中时不时地拿鼠标点点，我相信他们一定会非常地不爽。

就拿Xcode来说，写代码过程中最常见的行为，至少有下面这几项是必须要用鼠标或者需要手离开主键盘区的（需要按上下左右箭头键的时候）

- 跳转到某个函数的定义，要按住cmd+鼠标左键

- 在一个cpp文件内导航到某个函数，ctrl + 6, 输入函数名字，在列表里按上下键选择或鼠标点击

- 在一个cpp内，我想向下或者向上翻页，需要鼠标滚动 或者你的键盘有翻页键，但是还是要离开主键盘区

- 在一个cpp内，我要搜索某个字符串，cmd + f，输入字符串，回车，回车 。。。 或者 cmd + g， cmd + g， 搜到之后，再按ESC。

- 选中某一段文本，粘贴到另一个地方，或者删除一块文本，需要鼠标拖拽选中

如果你没有掌握Xcode中的常见快捷键，那更是需要依赖鼠标（比如emacs系的那些光标导航键，删除和召回键，构建，运行，停止等等快捷键）。

你可能说这是“矫情”， 但我觉得这不是矫情，这是————懒! (然而，伟人说过，“懒”是程序员的美德。;-) .

这几年来, 我vim用的比较多，从大学毕业开始就陆续的在尝试各种vim补全插件，我主要目的是学习和练习C++程序，因此找到一款能媲美vs+va的c++补全能力（和代码阅读跳转）的插件是我的一大目标，尝试过OmniComplete，ClangComplete，YouCompleteMe，再之前的记不清了，目前为止YCM算是比较满意的了，只是不喜欢它安装之后.vim目录会变得那么大。。。(200多M)

在习惯了vim之后，让我再写代码中经常去碰鼠标那真的是很难受，右手真的懒得从J键上拿走，然后过不了3秒又拿回来。。。这是我不使用IDE最大的原因，我想一切操作都用键盘来实现, vim有这种能力，且不止于此。

我一直在用vim和YouCompleteMe来写c++的“玩具”程序，编译器是macOS上Xcode工具链自带的Clang++编译器(对c++的标准支持还是很不错的，而且编译速度和提示信息也很人性化, 还记得在看《深入理解c++11新特性》那本书的时候，标准里的好多新特性只有在Clang上才能测试，它是跟进c++标准比较快的，相对于vc++, g++和其它。所以一直以来对它也比较有好感).

我自己对这套开发工具的使用是感觉对我的帮助很大的，因此在这里分享给朋友们。不多说了，看下使用这套工具来开发的效果图吧：

- include 头文件补全

![ycm-header.gif](http://7xi3zl.com1.z0.glb.clouddn.com/ycm-header.gif)

- api 补全

![ycm-api.gif](http://7xi3zl.com1.z0.glb.clouddn.com/ycm-api.gif)

# 编译构建，使用CMake

如果你写过Makefile, 那么你很容易喜欢上CMake. CMake和Makefile的关系有点像高级语言和低级语言的关系，比如C和汇编。

CMake抽象层次更高，仅需寥寥几行指令就能搞定一堆cpp文件的构建问题。这里不打算细说CMake. 主要说一下CMake给我带来的方便之处：

1. 构建过程是可编程的，且语法简单，内置函数丰富, 只需很少的精力就能维护c++项目的多平台构建, 整个工程的构建仅需保存在一个CMakeLists.txt中，易于维护，易于把构建过程集成到shell脚本中，实现项目一键构建运行。

2. CMake生成的`compile_commands.json`文件可以用作YCM的补全数据库. 在CMake中为了程序构建配置的header search path等信息，可以被YCM重用，免去再为了代码补全重新进行配置的过程。

# 调试工具

由于大家大部分人都是用IDE的调试器长大的，GDB给我们的印象是很难用，黑乎乎的命令行窗口，还要记住一些命令才能玩的通，像个黑盒子谁也不知道程序在里面跑成了什么德行。虽然隐约觉得这货很牛逼，但是我们中的大多数还是敬而远之。

但是，

GDB有个TUI你知道吗？ 像下面这样，是不和GUI很像。

GDB里面有个python你知道吗？ 调试也是可编程的了，这下你高兴了吗？

GDB可以让程序倒着运行你知道吗？ 黑科技你要不试一试?

如果你不知道上面说的这些，那建议你看下相关视频，比如这个：['Become a GDB Power User' - Greg Law [ACCU 2016]](https://www.youtube.com/watch?v=713ay4bZUrw).

其实，学习使用GDB和学习使用vim，emacs等等工具是一个道理，开始的不习惯和坚持会换来以后效率上和解决问题能力上质的飞跃。


# 工具的安装和配置

## CMake 

使用Homebrew来安装即可：`brew install cmake`

如需安装Homebrew看下面的参考链接：

参考链接：

- [Homebrew - The missing package manager for macOS](http://brew.sh/)

## vim

参考：

- [安装MacVim](http://blog.csdn.net/elloop/article/details/51760992)

- [升级mac内置的vim](http://blog.csdn.net/elloop/article/details/51762303)

## YCM

YCM的安装算是整个环境搭建过程中最繁琐的一个步骤，但是不难，按照官方指南来就可以。

参考: [mac上安装YCM](https://github.com/Valloric/YouCompleteMe#mac-os-x)

## vim的其它插件

如今的vim插件安装和管理都变得很简单了，仅需一份好用的.vimrc就可以搞定大部分插件的安装。对于c++的开发我常用到的插件包括：YCM， Ultisnips， CtrlP等，出了YCM，其他的插件安装十分简单，仅需要github上搜索这些插件关键字，它们觉得部分都支持Vundle或者Pathogen安装方式，在README里已经写得很清楚了。


## Clang++ 和 LLDB

如果你已经安装了Xcode，那么编译器和调试器应该是已经可用了，如果命令行里输入这两个命令没有反应的话，那么再安Xcode command line tools就好了:

`xcode-select --install`

Xcode工具链里带的c++编译器和调试器都是LLVM系的，如果想用GNU GCC系列，那么可以通过Homebrew来安装，然后配置下env。

关于开发环境的安装配置本文说的并不是很详细，重点是说明这种工具链的可行性，之后抽空把我的环境配置整理测试一下，再分享出来。

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

