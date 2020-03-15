---
layout: post
title: "Xcode 7.3编译的cocos2d-x程序崩溃问题"
category: tools
tags: Xcode
description: "Xcode skills"
---

# 前言

本文记录了一次Xcode编译生成的cocos程序离奇崩溃问题，及其解决方案。

# 问题所在

3月21日，Apple发布了Xcode 7.3版本和iOS 9.3系统。这意味着我们这次程序的版本需要支持iOS 9.3系统，这两天开始出iOS的设备包。由于Xcode 7.2不能连接iOS 9.3的真机进行调试，因此，为了以后的调试工作，必须要升级Xcode到7.3。这一升级不要紧，原来使用Xcode 7.2编译的项目，转到7.3版本的Xcode编译出来就莫名其妙的崩溃了。

崩溃仅仅发生在Release版本的程序中，Debug版本的并没有崩溃。观察发现，每次崩溃的地点都发生在cocos2d-x引擎中，CCMenuItem.cpp的activate()方法中:

<!--more-->

![ccmenuitem_crash.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/ccmenuitem_crash.jpg)

# 尝试解决

第一反应就是编译器的原因。因为Xcode 7.2的默认编译器是LLVM 7.0，而Xcode 7.3的编译器是LLVM 7.1。在两个版本的Xcode中同时打开两个项目，对比着看了看，没有发现哪里编译器参数不一样。

也有可能是cocos2d-x的代码缺陷造成的，在尝试把发生崩溃的函数指针改成std::function类型等处理之后，还是没能解决问题。

再次把注意力集中到Xcode 编译器设置问题上，因为Debug是不崩溃的，所以在Xcode 7.3中，把Release编译器设置部分逐一改成与Debug的一致，最后找到了问题的原因：发生在Optimization Level这个编译选项上。

解决办法：把Release版本的编译器优化等级调低到：-O, O1.

![level-o1.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/level-o1.jpg)

Release版本的默认编译器优化级别是：Fastest, Smalleset，而Debug版本默认是不优化None, -O0. 至于编译器里面具体优化掉了什么造成的崩溃还不得而知，总之就是调低了优化等级或者干脆不优化就不崩溃了。但是不优化会造成二进制体积的变大或者运行速度的降低，所以选择了不崩溃的最高优化等级-O，即O1。

由于O1优化等级是Fast，即会使得程序运行效率有提升，但是二进制的大小并没有做优化。经过对比发现，在启用Smallest优化和O1优化之间, 480多个cpp文件编译之后的二进制代码大小相差为5M左右，即，使用O1级别优化较之于-Os优化二进制增加了5M左右。

# 参考

- [Xcode Compiler optimization options](https://developer.apple.com/library/mac/documentation/General/Conceptual/MOSXAppProgrammingGuide/Performance/Performance.html)

---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**


