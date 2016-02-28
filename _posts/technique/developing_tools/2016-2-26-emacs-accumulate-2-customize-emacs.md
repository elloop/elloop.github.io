---
layout: post
title: "【积水成渊-逐步定制自己的Emacs神器】2：基本的定制Emacs"
category: tools
tags: [emacs]
description: ""
---

# 前言 #

本文介绍了如何定制Emacs的外观和如何组织Emacs配置文件以做到“一处配置随处可用”。外观定制部分仅举个例子，包括：菜单栏、工具栏、滚动条、主题，重在讲解定制方法，读者一旦掌握定制的方法，就可以做更多的定制。

<!--more-->

定制Emacs有两种方式：
  * 通过Emacs的Cusmtomize系统，类似传统软件的GUI操作
  * 通过修改Emacs配置文件(.emacs或者init.el，后面介绍这个配置文件)

第一种方式其实也是在修改Emacs配置文件，只不过是Emacs自动修改的。对于初学者或者是不喜欢去手动操作配置文件的用户，使用Customize系统是更好的选择

# 去掉菜单栏、工具栏、滚动条 #

所有的定制操作有一个统一的入口

# Load Path
 
check your load-path: C-h v load-path RET

i think when you install packages via package-mode, the installed package's info is auto added into load-path.

