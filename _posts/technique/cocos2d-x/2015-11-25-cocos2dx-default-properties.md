---
layout: post
title: "[cocos2d-x源码剖析]1: 源代码项目结构划分"
highlighter_style: solarizeddark
category: [cocos2d-x]
tags: [cocos2d-x, game]
description: ""
published: false
---

##前言
本文总结了cocos2d-x中与图形渲染相关的常用组件，给出其在cocos2d-x继承体系中的类图、默认属性等信息。这里说的组件主要是指跟图形渲染相关的东西，比如Node、Scene、Layer等等, 默认属性是指在调用create()方法之后的属性。同时，结合类图总结了它们之间的继承等关系。

## 2.x版本 (从2.2.3总结而来）

下面把组件件分成几类：**基本组件**，**“原子”组件**， **复合组件**

- 基本组件

指那些最为基础的组件，通常作为其他可见元素的父容器，其本身通常是不可见的。

|**控件**|**锚点**|**忽略锚点**|**contentSize**|**position**|
|:-------|:-------|:-----------|:----|:---|
|Node| (0,0) | false| (0, 0)|(0, 0)|
|NodeRGBA|同Node|同Node|同Node|同Node|
|Scene|(0.5, 0.5)|true|同Node|同Node|
|Layer|(0.5, 0,5)|true|同Node|同Node|
|LayerRGBA|同Layer|同Layer|同Layer|同Layer|
|LayerColor|同LayerRGBA|同LayerRGBA|同LayerRGBA|同LayerRGBA|
|LayerGradient|同LayerColor|同LayerColor|同LayerColor|同LayerColor|
|LayerMultiplex|同Layer|同Layer|同Layer|同Layer|
|Sprite|同NodeRGBA|同NodeRGBA|同NodeRGBA|同NodeRGBA|


