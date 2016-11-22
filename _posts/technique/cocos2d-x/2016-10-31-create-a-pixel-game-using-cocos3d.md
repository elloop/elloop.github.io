---
layout: post
title: "【cocos2d-x 3D实战】开发一款体素游戏--1. 准备工作"
category: [cocos2d-x]
tags: [cocos2d-x, game]
published: true
description: ""
---

**本系列文章记录下使用cocos2d-x开发一款体素风游戏的过程，遇到的问题，解决办法及收获。使用了cocos2d-x的3D功能，以下简称c3d**

# 前言

最近cocos官网推荐了一款使用cocos2d-x开发的3D游戏，叫《Steps》（信步），是一个乌克兰小伙的作品，是一款休闲小游戏，正是类似MineCraft那种体素（voxel）风格的，看起来效果还不错，于是自己也打算尝试搞一个这样的游戏玩玩。

本文是使用c3d开发一款体素风游戏系列的第一篇，记录了开发环境的配置和界面编辑器的选择和实验。

- 引擎：cocos2d-x 3.10

- 体素模型编辑器：[MagicaVoxel 0.98 ](https://ephtracy.github.io/)


# 1. 新建cocos工程

使用cocos命令行工具创建即可，建议使用lua类型，因为对3D效果的调试可能要频繁修改UI部分要频繁重启游戏。

# 2. 模型创建和导出

使用MagicaVoxel创建出一个3D小汽车，如下图所示：

![magicavoxel.png](http://7xi3zl.com1.z0.glb.clouddn.com/magicavoxel.png)

MagicaVoxel比较容易上手，

画刷工具有六种，

- L     画线

- C     圆

- P    

- V     自由矢量

- F     面

- B     方块

画刷操作类型有四种：

<!--more-->

- Attach   附加

- Erase    擦除

- Paint    画 （覆盖原体素）

- Move      整体移动

自己都实践操作下就知道其中区别了

YouTube上有很多系列教程，跟着视频操作很快就能上手，这里的小汽车画法是模仿下面这个视频来操作的：

[MagicaVoxel | Tutoriel FR - #2 Construisons !](https://www.youtube.com/watch?v=GEiiH74IStY)

# 3. 在cocos中加载模型、展示场景

c3d支持MagicaVoxel导出的obj格式文件，同时还支持c3b, c3t两种模型格式文件后两者是通过把fbx-conv工具由fbx文件转换而来，在cocos中使用c3b和c3t格式模型可以支持动画等特性，而直接使用obj的话不能播放动画。本文暂时直接加载obj文件，后面会使用Blender把obj转为fbx，再通过fbx-conv转换为c3b和c3t, 以便于在cocos中播放3D动画等功能。

为了简单，我直接在cpp里建了个Layer，加载上一步导出的car1.obj:

{% highlight c++ %}
#include "3d/House.h"

USING_NS_CC;

bool House::init() {
    if (Layer::init()) {
        loadModel();
        setCamera();
        return true;
    }
    return false;
}


void House::loadModel() {
    const char *modelName = "3d/car1.obj";
    auto house = Sprite3D::create(modelName);
    house->setCameraMask((unsigned int)CameraFlag::USER1);
    addChild(house);
}

void House::setCamera() {
    auto size = Director::getInstance()->getVisibleSize();
    auto camera = Camera::createPerspective(60.0, size.width / size.height, 10, 100);
    camera->setCameraFlag(CameraFlag::USER1);
    camera->setGlobalZOrder(10);
    camera->setPosition3D(Vec3(40, 40, -20));
    camera->lookAt(Vec3(0, 0, 0), Vec3(0, 1, 0));
    addChild(camera);
}

{% endhighlight %}

效果图：

![car1.png](http://7xi3zl.com1.z0.glb.clouddn.com/Snip20161101_2.png)

在下一篇文章中再加入调整摄像机的视角的触摸响应函数。

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

