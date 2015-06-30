---
layout: post
title: Xcode Skill
category: tools
tags: [c++, Xcode]
description: "Xcode skills"
---

# 常用快捷键
**简称：command == cm, shift == /s, control = /c, option(alt) == /a**
用空格代替+, left = mouse left

|                   *cmd*              |              *function*               |
|--------------------------------------|------------------------------------------|
| cm 0(1~8)               |toggle left(swith between left sub windows) |
| /c (1~6)                |     swith between jumpbar |
| cm /a 0                 |     toggle utility panel         |
| cm /a (1~6)             |     switch between inspector   |
| cm /c /a (1~4)          |     switch between libraries |
| /a left                 |     open in assistant editor          |

# 使用陷阱

- 区分逻辑分组与Finder中实际存在的文件夹

    在Xcode编辑区正上方的导航栏会看到当前文件到逻辑路径，比如cocos->2d->actions->CCActionInterval.h
于是，你在你的头文件里试图包含这个文件: 

    ```c++
    // no such file
    #include "cocos/2d/actions/CCActionInterval.h"
    ```

    但是编译器会提示你找不到文件，此时打开CCActionInterval.h, 使用快捷键`command + shift + j`在项目导航面板中找到这个文件，可以看到在Xcode的导航面板中的确看到CCActionInterval.h在2d/actions文件夹下，但是你在actions上鼠标右键，"show in finder"却发现，在finder中并不存在actions这个文件夹，即它只是个逻辑上的分组，并不是物理存在于文件系统的，因此正确的包含头文件的写法应该是以文件系统里文件的所在位置为准，即: 


    ```c++
    // right
    #include "cocos/2d/CCActionInterval.h"
    ```


