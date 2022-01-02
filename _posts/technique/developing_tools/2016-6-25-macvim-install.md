---
layout: post
title: "安装Macvim"
category: tools
tags: vim 
description: ""
---

# 前言

本文记录了一次安装Macvim遇到的问题和解决办法，并提到了如何从终端启动Macvim。

## brew install macvim 成功，但启动报错

今天重装了Mac系统(10.11.5 El Capitan，你问Mac居然也重装系统？我只是想要一块干净的硬盘。). 折腾完系统，在装回Macvim的时候遇到了问题。

我是使用Hombrew来安装的，在安装过程中brew下载了一些依赖的包。最后安装完成，在执行完`brew linkapps macvim`生成一个链接到Applications目录之后，我立马敲了`mvim`来启动Macvim, 让我吃惊的是，居然报错了！

{% highlight c++ %}
Fatal Python error: PyThreadState_Get: no current thread
{% endhighlight %}

这是我在iterm2窗口中看到的错误信息，虽然Macvim跑起来了，但是很明显python报错了，这意味着vim中使用Python的插件可能都会不能工作, 确实如此YouCompleteMe首当其冲，事实证明，后来我在逐个注释掉`.vimrc`中用到了Python的插件以排查问题的时候，把YCM注释掉了Python就不报错了。

于是google了一下报错信息，果然在YCM的issue里有关于这个问题的讨论，YCM作者一直在甩锅：

>Just tried using the latest MacVim on my OS X Mountain Lion and everything works. So this is somehow caused by your machine configuration in some way, sorry.

大意就是："别特么来烦我，这明显是你Mac系统配置问题，去换一个官方最新的Macvim版本吧。"

看了好几个关于这个问题的issue最后看到了YCM作者最关键的一个回答:

>The version of Python that YCM is linked to when being built and the version of Python linked into your Vim binary have to match, yes. If they don't, a problem like the one you're experiencing might ensue.

意思是："构建YCM使用的Python版本必须和构建Vim使用的Python版本必须匹配，否则就可能出来这个问题。"

<!--more-->

## 重新构建YCM

根据上面那个回答，我要使用和构建Macvim一样版本的Python来构建YCM。因为在安装Macvim的时候，brew下载了新版的Python(2.7.11), 我在iterm2里也确实能看到当前版本的Python正是brew下载下来这个2.7.11。系统自带的Python版本是2.7.10(/usr/bin/python), 如果brew在构建Macvim过程中使用的是其下载的新版Python，那么我也使用这个新版的Python来重新构建YCM就行了。

构建YCM的过程略去不谈，比较顺利，因为之前构建过。重点是结果！！MD，还是会报：

{% highlight c++ %}
Fatal Python error: PyThreadState_Get: no current thread
{% endhighlight %}
'
这TM是因为我在转入Emacs+Evil的报应吗，Macvim开始耍脾气罢工了是吗, 我装完系统先装的你呀。

我靠，我可不会放弃，毕竟好几年的感情了，不能出了毛病就不管它了。

继续google解决方案, 因为是通过brew来安装的vim，因此brew也加入了搜索关键字。于是找到了下面这个很有用的线索：

[MacVim doesn't link to brewed python correctly](https://github.com/Homebrew/legacy-homebrew/issues/17908)

我只大概扫了一眼，仅需知道，brew安装Macvim时是有可能出现Python版本链接错乱的情况的。

没必要再去看brew的东西了，听YCM作者的，去Macvim官方网站搞个新包算了。

## 卸载Macvim 下载官网新版

从brew中卸载掉macvim： `brew uninstall macvim`

到[官网](http://macvim-dev.github.io/macvim/)下载了最新的dmg：

![macvim_dmg.png](https://github.com/elloop/elloop.github.io/blob/master/blog_pictures/Screen%20Shot%202016-06-26%20at%2001.07.25.png)

直接拖到Applications文件夹，双击打开，安静的没有任何报错。

## 启动Macvim的几种方式

看来brew也不是一直靠谱的，原来到官网下个新包就解决了问题。接下来虽然可以不报错的打开Macvim了，但是仅能通过双击文件Macvim.app的图标才能启动Macvim，那么如何从命令行里启动它呢？

下面介绍三种从命令行打开Macvim的方式：

假设，你把Macvim.app放置在了默认的位置，即：/Applications

那么你会发现下面两个文件：

/Applications/MacVim.app/Contents/MacOS/MacVim

/Applications/MacVim.app/Contents/MacOS/Vim

**这就分别对应两种在命令行中启动Macvim的方式：**

- /Applications/MacVim.app/Contents/MacOS/Vim -g file ...

- open -a MacVim file ...

如果觉得每次输入那么长的路径太麻烦，那么可以在你的`~/.profile`中添加一个别名，比如我用zsh，那么我在我的~/.zshrc中添加了这样一条：

{% highlight c++ %}
alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g'
{% endhighlight %}

**第三种方式是最灵活的方式：使用mvim脚本**

在上面的图中可以看到，下载来的Macvim包里有一个mvim文件，它是一个脚本文件，执行mvim文件，它会去几个常见的地方去搜索MacVim.cpp:

~/Applications              

~/Applications/vim

/Applications               

/Applications/vim

/Applications/Utilities     

/Applications/Utilities/vim

如果你没有把MacVim.app拖入Applications文件夹，而是放在了其它地方，那么只要设置这个环境变量：`VIM_APP_DIR` 指向你的MacVim.app的存放目录即可。

为了能在任意命令行中打开Macvim，你需要把mvim这个脚本拷贝到PATH里包含的路径里面。比如，我是把mvim拷贝到了/usr/local/bin/目录下了。因为brew安装的应用也是在这个目录下，这个路径已经配置在PATH中了。

更多的启动说明可以在Macvim中输入：`:h macvim-start`来查看。

---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

