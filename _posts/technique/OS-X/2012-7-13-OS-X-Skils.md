---
layout: post
title: "OS-X 使用经验总结"
highlighter_style: monokai
category: programming
tags: [OS-X]
description: ""
---

# 前言

本文持续更新总结OS X系统的一些操作技巧。

## Finder

### Show Paths in Finder

- 在Finder中显示路径栏: `Finder菜单栏 -> 显示 -> 显示／隐藏路径栏`

- 路径栏显示完整路径：

```bash
# 开：
defaults write com.apple.finder PathBarRootAtHome -bool TRUE;killall Finder

# 关：
defaults delete com.apple.finder PathBarRootAtHome;killall Finder
```

- 在Finder顶部显示完整路径

```bash
# 开：
defaults write com.apple.finder _FXShowPosixPathInTitle -bool TRUE;killall Finder

# 关
defaults delete com.apple.finder _FXShowPosixPathInTitle;killall Finder
```
  
>Tip: 右键点击顶部路径任意位置，会弹出路径列表，可切换至任意层级的父目录

- [参考文章](http://www.cnet.com/au/how-to/how-to-copy-a-file-path-in-os-x/)

<!--more-->

### Finder常用快捷键

- Shift + Command + G：定位到指定路径(Path)

- Shift + Command + A：定位到应用程序(Applications)

- Shift + Command + C：定位到计算机(Computer)

- Shift + Command + D：定位到桌面(Desktop)

- Shift + Command + I： 定位到 iDisk

- Shift + Command + K：定位到网络(Network)

- Shift + Command + T：添加当前目录到 Dock 最喜爱部分

- Shift + Command + U：定位到实用工具(Utilities)

- Command + up ：返回到上一层目录

- Command + down ：打开文件(夹)


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

快捷键功能修改：打开终端，输入以下命令完成不同的功能：

- 截屏时不带阴影：

```bash
defaults write com.apple.screencapture disable-shadow -bool true
```

- 改变文件格式：

```bash
defaults write com.apple.screencapture type <format>
#format可选择的格式有：png (默认)、pdf、jpg、jp2 (JPG2000)、gif、tif (TIFF)、bmp、pict、tga
```

- 改变截图路径：

```bash
defaults write com.apple.screencapture location <path>
#注意：默认的路径是桌面：~/Desktop
```

- 改变文件名方式：

```bash
defaults write com.apple.screencapture name <string>
```


## Terminal

### 修改默认shell后没有生效？

为什么执行了`chsh -s $(which zsh)`之后，$SHELL也已经变成/bin/zsh了，但是打开的Terminal窗口还是默认的bash？答案在这里，请看下图：

![why_zsh_not_show.png](http://7xi3zl.com1.z0.glb.clouddn.com/why_zsh_not_show.png)

即：需要到终端的偏好设置中改变shell的打开方式, 让它作为登录shell来打开即可。

>zsh很强大，安装很简单，参考官方github或者池建强的博客:[终极shell](http://macshuo.com/?p=676)

### 如何在vim中执行zsh的别名命令，比如我要在当前目录新建一个文件夹: `:!mkdir temp`，使用zsh的alias可以简写为`md temp`，如何在vim中直接使用zsh的简写命令呢，即做到`:!md temp` ?

### 如何把当前路径重定向到剪切板，比如`pwd > clipboard`，是否有clipboard这个变量，这样就方便在Terminal中复制当前路径了？

的确有在命令行操作剪切板的命令：

在OS X上：

- [pbcopy](https://developer.apple.com/library/mac/documentation/Darwin/Reference/ManPages/man1/pbcopy.1.html): 在命令行下，拷贝内容到剪切板.

- [pbpaste](https://developer.apple.com/library/prerelease/mac/documentation/Darwin/Reference/ManPages/man1/pbpaste.1.html): 输出剪切板内容到命令长标准输出

解决上面题目里的问题，复制当前路径到剪切板：`pwd | pbcopy`这样就行了，使用command + v就可以粘贴到别的地方了。

在X window系统有`xclip`.

## Launchpad

- 有些app已经删掉了还出现在Launchpad中，怎么办？去~/Applications下面找找吧，看看删不掉的图标是不是在这里。

## FAQ

- 如何修改某种类型文件的默认打开方式

右键菜单 - > 简介里可以看到

- 查看多个文件占用的容量 ctrl + command + i

- 快速关机 正常左上角苹果 option键，(按住option键菜单项一般都会有些变化，记住这个规律)

- 调整声音的时候，系统会发出“嘟嘟”的声音，按住shift键就没了

- 同时按shift+option， 可以4分1格调节（这个同样适用键盘背光和屏幕亮度）

- 把多个文件归类到一个文件夹中：选中你想要的文件 按control＋command＋n

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**



