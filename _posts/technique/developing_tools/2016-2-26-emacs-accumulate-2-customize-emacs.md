---
layout: post
title: "【积水成渊-逐步定制自己的Emacs神器】2：基本的定制Emacs"
category: tools
tags: [emacs]
description: ""
---

# 前言 #

本文介绍了如何定制Emacs的外观和如何组织Emacs配置文件以做到“一处配置随处可用”。外观定制部分仅举个例子，包括：菜单栏、工具栏、滚动条、字体设置、主题，重在讲解定制方法，读者一旦掌握定制的方法，就可以做更多的定制。


定制Emacs有两种方式：

  * 通过Emacs的Cusmtomize系统，类似传统软件的GUI操作
  * 通过修改Emacs配置文件(.emacs或者init.el，后面介绍这个配置文件)

第一种方式其实也是在修改Emacs配置文件，只不过是Emacs自动修改的。对于初学者或者是不喜欢去手动操作配置文件的用户，使用Customize系统是更好的选择。

# 去掉菜单栏、工具栏、滚动条 #

所有的定制操作有一个统一的入口：`M-x customize RET`。进入Customize Mode之后的界面如下：

![customize.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/customize.jpg)

<!--more-->

定制的操作很简单，选择要设置的项目编辑、保存即可。关键在于如何找到要设置的项目，可以使用页面上方的搜索框来搜索要设置的选项。使用C-h m来获得使用Customize Mode的帮助信息。
以隐藏菜单栏来举例，我在search里输入"menu bar"回车，在搜索结果里将光标移动到"Menu Bar Mode"那一行行首，按TAB键，光标会自动定位到`Toggle`按钮上，按回车键来切换设置状态，设置为“off”之后，再一下TAB将光标移动到下面的`State`按钮上，按下回车，Emacs提示你保存状态，选择“1”，为以后的sessio都使用这个设置。如下图所示：

![hide-menu-bar](http://7xi3zl.com1.z0.glb.clouddn.com/hide-menu-bar.jpg)

> 小提示：在Customize Mode下，TAB键自动将光标移动到下一个按钮，S-TAB移动到上一个按钮。

对于隐藏工具栏和滚动条是一样的操作，把搜索词替换为“tool bar”和“scroll bar”即可。要关闭的两个Mode分别是：`Tool Bar Mode`和`Scroll Bar Mode`。


# 更换字体 #

字体的设置可以按如下操作进行：

1. M-x customize-group RET basic-faces RET，进入了Customize Group的Basic Faces设置分组，将光标移动到Default那一行，按回车键，展开Default分组：

![basic_faces.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/basic_faces.jpg)

2. 可以看到Font Family那项就是字体的名称，光标移动到那行的行首，按TAB键会自动定位到名称编辑框里进行修改，可以根据需要修改其它的设置。修改之后，点击State按钮，类似之前修改菜单栏的操作一样，要对修改进行保存，要为以后的session都使用这个字体那就根据提示输入“1”即可。

# 更改主题 #

在介绍如何安装Package之前，这篇文章只讲如何在Emacs自带的主题直接进行切换。

如果只是临时想修改主题，那么可以这么操作：输入`M-x customize-themes RET`, 会看到Emacs自带的十几种主题，光标移动到某个主题，然后按回车键，当前的session就会切换到对应主题。如果想在Emacs重启后仍然保留需要点击上面的保存按钮。

![customize_themes.gif](http://7xi3zl.com1.z0.glb.clouddn.com/customize_themes.gif)


# 自定义操作小结 #

前面介绍的定制操作提到了三种进入设置页面的方法，第一种是通过M-x customize RET，进入设置的主页面，然后使用搜索功能，定位到具体的设置选项。

第二种是使用M-x customize-group然后进入Basic Faces分组。

第三种是直接进入主题设置页面：M-x customize-themes。

通常某个具体的设置项都对应着Emacs的一个变量，在熟悉了设置项之后，则可以直接定位到具体的设置页面，比如假设我知道了控制菜单栏显示的变量叫：`menu-bar-mode`，那么我可以使用:

`M-x customize-variable RET menu-bar-mode RET` 直接进入菜单栏设置界面。

综上所述，我们目前掌握的进行定制操作的命令分为以下四类：

  * M-x customize : 进入设置主页，通过搜索来导航
  * M-x customize-group ：按分组来设置，需要指定分组名，需要对设置分组有一定的了解
  * M-x customize-variable ：定位到具体的某个变量，需要对要设置的项的变量名熟悉
  * M-x customize-themes ：以设置主题为代表的这类命令，对Emacs某个方面进行设置的命令，需要对设置系统比较熟悉
  
# 让你的Emacs个性化设置随处可用 #

当你的Emacs配置复杂到一定程度以后，让你在另一台设备上重新设置一遍是很费精力的。就像你希望你的浏览器书签可以在任何设备上可用一样，你也希望你最喜欢的Emacs个性化设置也一样随处可用，这不是什么难事，有很多办法。

在介绍如何做到这一点之前，首先要确定的是，我们的Emacs配置文件在哪里？

默认情况下，你的Emacs配置文件是在($HOME)/.emacs这个文件里的。如果找不到这个目录和文件，请参考下面那节“我的配置文件在哪里”。

安装的扩展Package等文件是放在($HOME)/.emacs.d/这个目录下的。你也可以把.emacs文件重命名为init.el, 然后把它也放在.emacs.d这个文件夹下，这样就维护一个目录就行了。

因此，($HOME)/.emacs.d/这个文件夹就是你的私人Emacs定制内容，让它随处可用即可。用U盘、云盘啥都行，很多人都把.emacs.d建成一个独立仓库托管在github上，在实现了云端存储的同时，还方便版本管理，记录每次的修改，所以建议使用这个方案。

# 使用别人的优秀配置，站在巨人的肩膀上 #

Emacs诞生已经30来年了，使用Emacs的大牛很多，也有很多大牛把自己的配置挂在网上分享出来，它们是很好的学习参考对象。可以把这些优秀的配置下载下来，在使用中体会它的精妙，并逐渐改造成更适合你自己的配置，这会为你节省大量的精力，并且更容易走在正确的路上。

这个链接是Ergoemacs网站推荐的一些适合Coding的配置，同时也提到了适合初学者的配置：

[Emacs: What's the Best Setup for Coding {Python, Java, C++, Web Dev, …}](http://ergoemacs.org/emacs/emacs_whats_best_setup_for_xyz.html)

下面这个链接是一些使用Emacs的名人列表，有精力的话可以去网上搜他们的配置：

[Famous Emacs Users (that are not famous for using Emacs)：著名的Emacs用户(不是因为使用Emacs而出名)](http://wenshanren.org/?p=418)

使用Emacs.d关键字来搜索github，按Star数量降序排列应该会找到优秀的emacs配置。（我还未尝试）

# 我的配置文件在哪里？ #

`C-h v user-init-file` 就会看到你使用的配置文件是啥了，你的配置文件就在那里。如果你对Emacs只进行了上面的几个配置，那么现在打开这个配置文件，内容大致是这个样子的：

{% highlight list %}
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(menu-bar-mode nil)
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 120 :width normal :foundry "outline" :family "Monaco")))))
{% endhighlight %}

可以看到你刚才进行的几项配置都保存在这里了(menu-bar-mode是菜单栏，scroll-bar-mode是滚动条，最下面的是字体设置），每次Emacs启动的时候会执行这个lisp脚本来加载你的定制选项。

> C-h v对应的命令叫：describe variable，也可以使用：M-x describe-variable 来启动这个命令，M-x 是启动命令的万能钥匙，以C-h v类似的按键来发送命令是一种快捷方式！

# 推荐的.emacs.d(不定期更新) #

  * [magnars/.emacs.d](https://github.com/magnars/.emacs.d/): emacs rocks系列视频的配置，文档齐全，可以当做学习参考之用
  * [tuhdo/emacs-c-ide-demo](https://github.com/tuhdo/emacs-c-ide-demo)：C/C++开发环境demo，可参考作者的[博客](http://tuhdo.github.io/c-ide.html#sec-2)，可以把Emacs打造成一个功能完备的C++ IDE，可以在Emacs中高效的浏览Linux Kernel源代码。

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

