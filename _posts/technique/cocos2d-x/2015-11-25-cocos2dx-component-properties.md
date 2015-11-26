---
layout: post
title: "[cocos2d-x源码剖析]1: 源代码项目结构划分"
highlighter_style: solarizeddark
category: [cocos2d-x]
tags: [cocos2d-x, game]
description: ""
published: false
---

- Node及其直接子类

|**控件**|**锚点**|**忽略锚点**|**contentSize**|**position**|
|:-------|:-------|:-----------|:----|:---|
|CCNode| (0,0) | false| (0, 0)|(0, 0)|
|CCNodeRGBA|同CCNode|同CCNode|同CCNode|同CCNode|
|CCDrawNode| 同CCNode | 同CCNode| 同CCNode|同CCNode|
|CCAtlasNode| 同CCNode | 同CCNode| 同CCNode|同CCNode|

|Scene|(0.5, 0.5)|true|同CCNode|同CCNode|
|Layer|(0.5, 0,5)|true|同CCNode|同CCNode|
|LayerRGBA|同Layer|同Layer|同Layer|同Layer|
|LayerColor|同LayerRGBA|同LayerRGBA|同LayerRGBA|同LayerRGBA|
|LayerGradient|同LayerColor|同LayerColor|同LayerColor|同LayerColor|
|LayerMultiplex|同Layer|同Layer|同Layer|同Layer|
|Sprite|同CCNodeRGBA|同CCNodeRGBA|同CCNodeRGBA|同CCNodeRGBA|


