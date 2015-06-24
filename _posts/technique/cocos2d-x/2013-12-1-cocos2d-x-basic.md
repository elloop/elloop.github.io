---
layout: post
title: "[掌握Cocos2d-x系列]-1 Cocos2d-x 基本概念"
category: [c++, cocos2d-x]
tags: [c++, cocos2d-x, OpenGL ES ]
description: "cocos2d-x学习"
---

# cocos2d-x 基础概念学习

## 渲染
- OpenGL ES 2.0

##coordinate
- 第一种划分方式
    - *OpenGL坐标系*
        cocos2d-x使用的是OpenGL坐标系，跟数学里的数轴x，y方向一致。

    - *屏幕坐标系*
        x轴向右，y轴向下。注意：触摸时间Touch传入的位置信息使用的是屏幕坐标，cocos会把触摸点坐标转换为OpenGL坐标。
    - *转换*
        - convertToUI(): GL -> UI屏幕
        - convertToGL(): UI屏幕 -> GL
        - Touch: 
            - getLocation() : 获得GL坐标
            - getLocatinInView(): 获得UI坐标

- 第二种划分方式
    - *节点坐标系*
        每个对象都有一个自己的坐标系，叫做节点坐标系。对象移动或改变方向，坐标系随之改变。

    - *世界坐标系* 
        也叫绝对坐标系, setPosition() 使用的是相对于父亲的节点坐标系，而非世界坐标系，绘制屏幕的时候cocos会把节点坐标系映射成世界坐标系坐标。

    - *节点<->世界坐标转换*
        - 节点 -> 世界:
            - convertToWorldSpace()
            - convertToWorldSpaceAR()
        - 世界 -> 节点
            - convertToNodeSpace()
            - convertToNodeSpaceAR()

##labels
- TTF
    创建简单，但是不适合频繁更改的文本。因为在更新时，整理纹理都要使用字体渲染方法重新创建，分配新纹理，释放旧纹理需要消耗时间。
- BMFont
    适用于需要频繁修改文本内容，可以单个字单独控制动作、效果等，相当于一个sprite。
- Atlas
    字符图集。类似BMFont, 但是要求图片中的字符必须按ASCII顺序连续排列。

## Questions
- 1. 父节点设置了忽略锚点，那么它所有的子节点相对于它也忽略锚点吗？
