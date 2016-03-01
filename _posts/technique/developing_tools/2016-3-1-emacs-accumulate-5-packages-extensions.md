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

<!--more-->

![list_packages.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/list_packages.jpg)

## Package源：package-archives ##

这个package列表是从网上down下来的，这个下载地址，Emacs里的专业叫法叫`Package Archives`，我称它为Package源。使用

`C-h v package-archives` 来查看package源这个变量的值，默认情况下，只有一个源，这导致Emacs的list-packages列表里包的数量不是很多。

## 添加Packag源 ##

`M-x customize-variable RET package-archives` : 还记得第二篇文章里的定制操作吧，使用customize-variable来修改这个package源变量。敲这个命令的时候记得多用TAB不用都敲。

进入之后可以看到当前的package源，点击下面的`INS`按钮来插入新的package源，输入一个名字，一个url链接，大家用的比较多的是melpa，名字和url可以分别这样填：

  * name：melpa
  * url：https://melpa.org/packages
  
填好之后的界面如下所示：

![package_archive.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/package_archives.jpg)

保存设置之后，再次使用M-x list-packages 就会看到包的数量明显增多。

注意：melpa这个package源需要科学上网才能正常使用，而且连接速度貌似不是很快，我平均要连30s左右才能连上。如果好久都没有响应，使用万能的C-g来跳出list-packages操作。

下面这篇文章里推荐了大陆用户一个package源，我还没使用过，如果不能科学上网的用户，可以试试：

[`("popkit" . "http://elpa.popkit.org/packages/")`](https://www.emacswiki.org/emacs/ELPA)

# 安装新主题 #

设置好了package源，现在可以给Emacs安装新的扩展了。

M-x list-packages 进入package列表，如果你已经在这个界面，按 "r" 键来刷新，重写连接。

以安装Solarized主题为例，按C-s来搜索 "solarized". 如下图所示，把光标放在“Solarized”那行，按“i”键，将其标记为“要安装的”，然后按“x”键执行标记为“i”的项目，这里仅仅标记这一个。

![solarized_theme.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/solarized_theme.jpg)

安装过程中会提示你是否要执行未经安全确认的ELisp脚本之类的，选“yes”就行了。装完这个主题之后，使用`M-x customize-themes`进入主题切换界面，可以看到Solarized Dark和Solarized Light两种风格可供选择。这里假设选择了Solarized Dark主题，并且保存为长期使用。此时打开你的Emacs配置文件会看到如下内容：

{% highlight list %}
(custom-set-variables
 '(custom-enabled-themes (quote (solarized-dark)))
 '(custom-safe-themes (quote ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
{% endhighlight %}

可以看到，新安装的主题配置已经写入Emacs配置。如果你此时重启Emacs，进来后会发现主题没有保存下来。这是因为在执行这段主题配置脚本时，Solarized包还没有加载。因此要想让设置生效，需要在这段脚本上面初始化packages，在你的.emacs(或者init.el)文件最上方加入这句：

`(package-initialize)`

它会初始化packages，确保随后的配置生效。

# 安装Markdown #

这一节说一下Emacs里做笔记写博客。

如果只需要使用Emacs来记笔记，安排日程，那么毫无疑问Org-Mode是首选。网上Org-Mode的教程很多，在此不细说了。如果需要编写Markdown文件，Org-Mode可以使用命令导出为Markdown格式，网上有人说使用`C-c C-e m`可以导出Markdown，但是我使用最新版本(20160229)的Org-Mode导出时，并没有导出Markdown的选项，我猜可能是需要安装新扩展才行吧。

其实Emacs的packages中有一个Markdown-Mode package是专门为编写markdown文件设计的，虽然它没有Org-Mode那么强大，但是对于普通用户已经足够用了，这篇文章就是在Emacs的Markdown-Mode里编写的。这里是[Markdown-Mode的github链接](https://github.com/jrblevin/markdown-mode)，里面有使用说明。总体来说用起来还算顺手，不足之处是应该是对表格的支持不是很好，我没在说明中看到对表格编辑的支持。

为什么要单独说一下安装Markdown-Mode呢？

这是因为它不是通过Package系统来安装的，上面的Solarized主题的安装是通过Package系统来安装的，过程很简单，是自动的。

而Markdown-Mode的安装方式是手动的。因此把它作为手动安装扩展的一个代表来说明。在上面的Markdown-Mode的github链接中可以找到它的安装方法：

  * 第一步：clone版本库(git clone https://github.com/jrblevin/markdown-mode.git)，拿到里面的markdown.el文件，拷贝到`($HOME)/.emacs.d/elpa/markdown-mode/`路径 (自己新建目录)
  * 第二步：把markdown.el的路径加入到Emacs的load-path之内
  * 第三步：在Emacs配置文件中加入Markdown-Mode的设置代码

编辑后的Emacs配置文件中markdown-mode部分配置如下所示：

{% highlight lisp%}

;;;markdown mode

;;;; YOUR_HOME_DIR是你的Home目录。
(add-to-list 'load-path "($YOUR_HOME_DIR)/.emacs.d/elpa/markdown-mode/")

;;;; 官方的markdown-mode设置
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
  (add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
{% endhighlight %}

> 要查看自己的load-path，使用`C-h v load-path`

# 总结 #

  * 自动安装：使用M-x list-packages来查看所有packages，使用i，x等快捷键来操作packages。有些package安装之后也要自己在Emacs配置文件里做一些设置
  * 手动安装：通常需要自己拷贝文件到.emacs.d等目录，并修改Emacs配置文件


---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

