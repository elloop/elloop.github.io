---
layout: post
title: OS X Skills
highlighter_style: monokai
category: programming
tags: [OS X]
description: ""
---

# Finder

## Show Paths in Finder
- Finder菜单栏 ：显示 ：显示／隐藏路径栏

- 显示完整路径：
  - 开：

    ```bash
    defaults write com.apple.finder PathBarRootAtHome -bool TRUE;killall Finder
    ```

  - 关：

    ```bash
    defaults delete com.apple.finder PathBarRootAtHome;killall Finder
    ```

- 在finder顶部显示完整路径
  - 开：
  
    ```bash
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool TRUE;killall Finder
    ```

  - 关：

    ```bash
    defaults delete com.apple.finder _FXShowPosixPathInTitle;killall Finder
    ```
  
  >*Tip*: 右键点击顶部路径任意位置，会弹出路径列表，可切换至任意层级的父目录

- [参考文章](http://www.cnet.com/au/how-to/how-to-copy-a-file-path-in-os-x/)

## 常用快捷键

- Shift + Command + G：定位到指定路径(Path)

- Shift + Command + A：定位到应用程序(Applications)

- Shift + Command + C：定位到计算机(Computer)

- Shift + Command + D：定位到桌面(Desktop)

- Shift + Command + I： 定位到 iDisk

- Shift + Command + K：定位到网络(Network)

- Shift + Command + T：添加当前目录到 Dock 最喜爱部分

- Shift + Command + U：定位到实用工具(Utilities)

