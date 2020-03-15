---
layout: post
title: "【积水成渊-逐步定制自己的Emacs神器】5：回到最初，重新开始"
category: tools
highlighter_style: monokai
tags: [emacs]
description: ""
---

# 前言 #

本文介绍如何把Emacs“恢复出厂设置”，这是我们克服一切困难的终极法宝。

在前面的Emacs定制那篇文章中，我们知道了通常所有对Emacs的定制文件都在.emacs.d这个文件夹里，尤其是当你把配置文件也放在.emacs.d/init.el中。如果是这样的话，那么让Emacs回到最初就很简单了，重命名或者删掉你的.emacs.d文件夹就ok了，总之就是让Emacs找不到你的配置，它就“恢复了出厂设置”。

为什么恢复出厂设置，因为这给了你尝试别人Emacs配置的机会。

<!--more-->

除了尝试别人的Emacs设置，当你在安装一个package失败或者莫名其妙的Emacs不管用了，恢复出厂设置也是一个好办法。

比如前些天，我在安装auto-complete这个package的时候，可能是由于由使用melpa源网络连接不稳定造成的，莫名其妙的就失败了。我参考了auto-complete的Manual，尝试手动安装，byte-compile它的三个el脚本，同样得到下面的报错信息。

报错信息如下：

    Compiling file c:/Users/elloop/AppData/Roaming/.emacs.d/elpa/auto-complete-1.4/auto-complete-config.el at Wed Mar 2 18:43:51 2016
    Entering directory `c:/Users/elloop/AppData/Roaming/.emacs.d/elpa/auto-complete-1.4/'
    auto-complete-config.el:31:1:Error: Symbol's value as variable is void: closed
    
    Compiling file c:/Users/elloop/AppData/Roaming/.emacs.d/elpa/auto-complete-1.4/auto-complete-pkg.el at Wed Mar 2 18:43:52 2016
    
    Compiling file c:/Users/elloop/AppData/Roaming/.emacs.d/elpa/auto-complete-1.4/auto-complete.el at Wed Mar 2 18:43:52 2016
    auto-complete.el:49:1:Error: Symbol's value as variable is void: closed
	
在auto-compete的github上开了个[issue](https://github.com/auto-complete/auto-complete/issues/431), 半响也没有解决。后来我就使用了杀手锏：恢复出厂设置。删掉了我的.emacs.d目录，然后重新checkout下一份为安装auto-complete之前的纯净配置，然后更换了一个package源，重新输入`M-x package-install RET auto-complete RET`，这次OK了，顺利搞定。

从这次体验来看，Emacs出问题的终极解决方案似乎就是“恢复出厂设置了”。这有点类似有电脑重装系统，简单粗暴。

这一点给我的启发是：掌握了恢复出厂设置这一招，就大可放开手脚随便折腾Emacs，不要怕出错，这样才学的更快。前提是你要有配置的备份，这样就算把Emacs全都删干净了，也不会使之前折腾的配置前功尽弃。

“恢复出厂设置”这个机制还有些类似于学太极，张三丰在教张无忌学太极的时候说：“要想学会太极，就得什么都忘记”。Emacs也是这样，你学习了一段时间，觉得自己陷入了死胡同，或者是觉得进步很慢，Emacs最大的特点就是“只有你想不到，没有它做不到的”，当你陷入了自己的思维定式，感觉每天都在反复折腾自己已经学会的一点东西，这个时候，不妨删掉自己的.emacs.d，从网上找一些大师的“秘籍”，灌输到自己的Emacs之中，学习它的精髓，借鉴模仿并加以改造，重复这个过程，最终定会打造出最适合自己的Emacs神器。当然，这个过程永远没有尽头，只有更好，没有最好，你要做的就是放开手脚，不要固步自封。有时候，原地踏步还不如：回到最初，重新开始。




---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

