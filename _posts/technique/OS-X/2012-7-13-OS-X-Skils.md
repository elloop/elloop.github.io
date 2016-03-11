---
layout: post
title: "OS-X 使用经验总结"
highlighter_style: monokai
category: programming
tags: [OS-X]
description: ""
---

## Finder

### Show Paths in Finder

- Finder菜单栏 ：显示 ：显示／隐藏路径栏

- 显示完整路径：

  - 开：

{% highlight bash %}
    defaults write com.apple.finder PathBarRootAtHome -bool TRUE;killall Finder
{% endhighlight %}

  - 关：

{% highlight bash %}
    defaults delete com.apple.finder PathBarRootAtHome;killall Finder
{% endhighlight %}

- 在finder顶部显示完整路径

  - 开：
  
{% highlight bash %}
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool TRUE;killall Finder
{% endhighlight %}

  - 关：

{% highlight bash %}
    defaults delete com.apple.finder _FXShowPosixPathInTitle;killall Finder
{% endhighlight %}
  
  >*Tip*: 右键点击顶部路径任意位置，会弹出路径列表，可切换至任意层级的父目录

- [参考文章](http://www.cnet.com/au/how-to/how-to-copy-a-file-path-in-os-x/)

<!--more-->

### 常用快捷键

- Shift + Command + G：定位到指定路径(Path)

- Shift + Command + A：定位到应用程序(Applications)

- Shift + Command + C：定位到计算机(Computer)

- Shift + Command + D：定位到桌面(Desktop)

- Shift + Command + I： 定位到 iDisk

- Shift + Command + K：定位到网络(Network)

- Shift + Command + T：添加当前目录到 Dock 最喜爱部分

- Shift + Command + U：定位到实用工具(Utilities)

## 截屏

|**快捷键**|**说明**|
|---|----|
|Shift+Command+3|截取全屏幕至桌面|
|Shift+Command+4|截取部分屏幕至桌面|
|Shift+Command+4+空格|截取窗口或原件至桌面|
|Shift+Command+4 然后Esc| 退出截屏|
|Shift+Command+Control+3| 截取全屏幕至剪贴板|
|Shift+Command+Control+4| 截取部分屏幕至剪贴板|
|Shift+Command+Control+4+空格| 截取窗口或原件至剪贴板|
|Shift+Command+4 拉出选框 然后 空格|移动选框|
|Shift+Command+4 然后 Shift |保持选框高度（宽度），修改宽度（高度）|
|Shift+Command+4 然后 Option |保持选框中心，修改半径|

快捷键功能修改：打开“应用程序－》实用工具－》终端”，输入以下命令完成不同的功能：

- 截屏时不带阴影：

{% highlight bash %}
defaults write com.apple.screencapture disable-shadow -bool true
{% endhighlight %}

- 改变文件格式：

{% highlight bash %}
defaults write com.apple.screencapture type <format>
#format可选择的格式有：png (默认)、pdf、jpg、jp2 (JPG2000)、gif、tif (TIFF)、bmp、pict、tga
{% endhighlight %}

- 变截图路径：

{% highlight bash %}
defaults write com.apple.screencapture location <path>
#注意：默认的路径是桌面：~/Desktop
{% endhighlight %}

- 改变文件名方式：

{% highlight bash %}
defaults write com.apple.screencapture name <string>
{% endhighlight %}


## Terminal

为什么执行了`chsh -s $(which zsh)`之后，SHELL也已经变成/bin/zsh了，但是打开的Terminal窗口还是默认的bash？答案在这里，请看下图：

![why_zsh_not_show.png](http://7xi3zl.com1.z0.glb.clouddn.com/why_zsh_not_show.png)

即：需要到终端的偏好设置中改变shell的打开方式, 让它作为登录shell来打开即可。

ps: zsh的安装很简单，参考官方github或者池建强的博客:[终极shell](http://macshuo.com/?p=676)


## Launchpad

- 有些app已经删掉了还出现在Launchpad中，怎么办？去~/Applications下面找找吧，看没用的都干掉

