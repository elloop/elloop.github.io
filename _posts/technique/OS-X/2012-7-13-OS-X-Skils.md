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

```bash
defaults write com.apple.screencapture disable-shadow -bool true
````

- 复默认：

```bash
defaults write com.apple.screencapture disable-shadow -bool false
```

- 改变文件格式：

```bash
defaults write com.apple.screencapture type <format>
#format可选择的格式有：png (默认)、pdf、jpg、jp2 (JPG2000)、gif、tif (TIFF)、bmp、pict、tga
```

- 变截图路径：

```bash
defaults write com.apple.screencapture location <path>
#注意：默认的路径是桌面：~/Desktop
```

5、改变文件名方式：

```bash
defaults write com.apple.screencapture name <string>
```

