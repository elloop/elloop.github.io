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

第一种方式其实也是在修改Emacs配置文件，只不过是Emacs自动修改的。对于初学者或者是不喜欢去手动操作配置文件的用户，使用Customize系统是更好的选择。

# 去掉菜单栏、工具栏、滚动条 #

所有的定制操作有一个统一的入口：`M-x customize RET`。进入Customize Mode之后的界面如下：

![customize.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/customize.jpg)

定制的操作很简单，选择要设置的项目编辑、保存即可。关键在于如何找到要设置的项目，可以使用页面上方的搜索框来搜索要设置的选项。使用C-h m来获得使用Customize Mode的帮助信息。
以隐藏菜单栏来举例，我在search里输入"menu bar"回车，在搜索结果里将光标移动到"Menu Bar Mode"那一行行首，按TAB键，光标会自动定位到`Toggle`按钮上，按回车键来切换设置状态，设置为“off”之后，再一下TAB将光标移动到下面的`State`按钮上，按下回车，Emacs提示你保存状态，选择“1”，为以后的sessio都使用这个设置。如下图所示：

![hide-menu-bar](http://7xi3zl.com1.z0.glb.clouddn.com/hide-menu-bar.jpg)

> 小提示：在Customize Mode下，TAB键自动将光标移动到下一个按钮，S-TAB移动到上一个按钮。

对于隐藏工具栏和滚动条是一样的操作，把搜索词替换为“tool bar”和“scroll bar”即可。要关闭的两个Mode分别是：`Tool Bar Mode`和`Scroll Bar Mode`。

# Load Path
 
check your load-path: C-h v load-path RET

i think when you install packages via package-mode, the installed package's info is auto added into load-path.

