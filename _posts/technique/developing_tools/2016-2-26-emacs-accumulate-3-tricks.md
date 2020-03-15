---
layout: post
title: "Emacs按键、命令、小技巧-合集"
category: tools
tags: [emacs]
description: ""
---

# 前言 #

本文持续总结Emacs里的一些常用按键和命令以及小技巧。

# 按键和命令 #

## 帮助 ##

  * 查看帮助的帮助：`C-h C-h`
  * Emacs Tutorial: `C-h t`
  * Emacs Info: `C-h i`
  * 查看命令帮助：`C-h a <command-name>`
  * 查看当前mode帮助：`C-h m`
  * 查看某个变量的值：`C-h v <command-name>`


## 编辑 ##

  * 行号开关：`M-x global-linum-mode`
  * 跳转到指定行：`M-gg`

<!--more-->

## 窗口(window) ##

  * 关闭其他窗口：`C-x 1`
  * 水平分割当前窗口：`C-x 2`
  * 垂直分割当前窗口：`C-x 3`
  * 关闭当前窗口：`C-x 0`
  * 关闭当前缓冲区(窗口还在)：`C-x k`
  * 在窗口间移动光标：`C-h o` (字母o)
  * 清除所有无用缓冲区：`M-x clean-buffer-list`

## 外观和显示 ##

  * 更换字体：`M-x customize-group RET basic-faces RET, Default Subgroup`
  * 切换主题：`M-x customize-themes`
  * 定制入口：`M-x customize`
  * 定制分组入口：`M-x customize-group`
  * 调整当前buffer字体大小：`C-x C-+`, `C-x C--`. `C-g`退出设置。
  * 设置当前buffer缩进风格：`C-c . <RET> STYLE <RET>`, STYLE可以用TAB来查看。

## 包和扩展 ##

  * 查看所有packages：`M-x list-packages`
  * 修改package源：`M-x customize-variable RET package-archives`


# 技巧 #

  * 禁用windows上的滴滴提示声：`(setq visible-bell 1`) 或者 `(setq ring-bell-function 'ignore)`
  * 区分同名buffer：`M-x customize-group RET uniquify RET` 修改uniquify buffer name style

## yes-no-p -> y-or-n-p ##

---------------------------



**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

