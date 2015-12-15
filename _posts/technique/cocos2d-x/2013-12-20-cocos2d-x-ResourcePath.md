---
layout: post
title: "[掌握Cocos2d-x系列]-3 Cocos2d-x 资源路径"
category: [c++, cocos2d-x]
tags: [c++, cocos2d-x]
description: "cocos2d-x学习"
---

{{ page.title }}

# FileUtils
## DefaultResRootPath
- FileUtilsWin32: DefaultResRootPath 设置为工作目录，或者exe所在目录(V3.x)
- iOS: 怎么设置？
- android: 怎么设置？

## SearchPathArray
资源的搜索路径数组, 通过addSearchPath()来添加，如果是相对路径，那么会和DefaultResRootPath拼接在一起，然后放进SearchPathArray

