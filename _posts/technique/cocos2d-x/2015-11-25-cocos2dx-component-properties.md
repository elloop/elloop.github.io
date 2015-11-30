---
layout: post
title: "cocos2d-x: 常用组件默认参数"
highlighter_style: solarizeddark
category: [cocos2d-x]
tags: [cocos2d-x, game]
description: ""
published: true
---

前言
---

本文总结了cocos2d-x常用渲染类的默认属性和它们之间的继承关系，并对比了2.x和3.x在相关方面之间的一些差别。
**注意**：默认参数的含义是在使用create()方法返回的对象那个时间点的属性。

## V2.X (conclude from 2.2.3 source codes)

###Node类

|**类型**|**锚点**|**忽略锚点**|**contentSize**|**position**|**直接父类**|**备注**|
|:-------|:-------|:-----------|:----|:---|:------|:------------|
|CCNode| (0,0) | false| (0, 0)|(0, 0)| CCObject ||
|CCNodeRGBA|同CCNode|同CCNode|同CCNode|同CCNode| CCNode ||
|CCDrawNode| 同CCNode | 同CCNode| 同CCNode|同CCNode| CCNode ||
|CCAtlasNode| 同CCNode | 同CCNode| 同CCNode|同CCNode| CCNode ||

###Scene & Layer

|**类型**|**锚点**|**忽略锚点**|**contentSize**|**position**|**直接父类**|**备注**|
|:-------|:-------|:-----------|:----|:---|:------|:------------|
|CCScene|(0.5, 0.5)|true|winSize|同CCNode| CCNode ||
|CCLayer|(0.5, 0,5)|true|winSize|同CCNode| CCNode ||
|CCLayerRGBA|同CCLayer|同CCLayer|同CCLayer|同CCLayer| CCLayer ||
|CCLayerColor|同CCLayerRGBA|同CCLayerRGBA|默认winSize, 可指定大小create|同CCLayerRGBA| CCLayerRGBA ||
|CCLayerGradient|同CCLayerColor|同CCLayerColor|同CCLayerColor|同CCLayerColor| CCLayerColor ||
|CCLayerMultiplex|同CCLayer|同CCLayer|同CCLayer|同CCLayer| CCLayer ||


###Sprite

|**类型**|**锚点**|**忽略锚点**|**contentSize**|**position**|**直接父类**|**备注**|
|:-------|:-------|:-----------|:----|:---|:------|:------------|
|CCSprite|(0.5, 0.5)|同CCNodeRGBA|pTexture->getContentSize()|同CCNodeRGBA| CCNodeRGBA ||
|CCSpriteBatchNode|同CCNode|同CCNode|同CCNode|同CCNode| CCNode ||


### Label类

|**类型**|**锚点**|**忽略锚点**|**contentSize**|**position**|**直接父类**|**备注**|
|:-------|:-------|:-----------|:----|:---|:------|:------------|
|CCLabelAtlas|同CCAtlasNode|同CCAtlasNode|同CCAtlasNode|同CCAtlasNode| CCAtlasNode ||
|CCLabelBMFont|(0.5, 0.5)|同CCSpriteBatchNode|(0, 0)|同CCSpriteBatchNode| CCSpriteBatchNode ||
|CCLabelTTF|同CCSprite|同CCSprite|同CCSprite|同CCSprite| CCSprite ||
|CCTextFieldTTF|同CCLabelTTF|同CCLabelTTF|同CCLabelTTF|同CCLabelTTF| CCLabelTTF ||

### Menu类

|**类型**|**锚点**|**忽略锚点**|**contentSize**|**position**|**直接父类**|**备注**|
|:-------|:-------|:-----------|:----|:---|:------|:------------|
|CCMenu|(0.5, 0.5)|true|winSize|winSize/2| CCLayerRGBA ||
|CCMenuItem|(0.5, 0.5)|同CCNodeRGBA|同CCNodeRGBA|同CCNodeRGBA| CCNodeRGBA ||
|CCMenuItemToggle|同CCMenuItem|同CCMenuItem|同CCMenuItem|同CCMenuItem| CCMenuItem ||
|CCMenuItemLabel|同CCMenuItem|同CCMenuItem|同CCMenuItem|同CCMenuItem| CCMenuItem ||
|CCMenuItemFont|同CCMenuItemLabel|同CCMenuItemLabel|同CCMenuItemLabel|同CCMenuItemLabel| CCMenuItemLabel ||
|CCMenuItemAtlasFont|同CCMenuItemLabel|同CCMenuItemLabel|同CCMenuItemLabel|同CCMenuItemLabel| CCMenuItemLabel ||
|CCMenuItemSprite|同CCMenuItem|同CCMenuItem|m_pNormalImage contentSize|同CCMenuItem| CCMenuItem ||
|CCMenuItemImage|同CCMenuItemSprite|同CCMenuItemSprite|m_pNormalImage contentSize|同CCMenuItemSprite| CCMenuItemSprite ||

### extensions.

|**类型**|**锚点**|**忽略锚点**|**contentSize**|**position**|**直接父类**|**备注**|
|:-------|:-------|:-----------|:----|:---|:------|:------------|
|CCScrollView|同CCLayer|同CCLayer|同CCLayer|同CCLayer| CCLayer |kCCScrollViewDirectionBoth|
|CCScrollView.m_pContainer|(0, 0)|false|同CCLayer|(0, 0)| CCLayer ||
|CCTableView|同CCScrollView|同CCScrollView|同CCScrollView|同CCScrollView| CCScrollView |kCCScrollViewDirectionVertical|


### CCTMXTiledMap

|**类型**|**锚点**|**忽略锚点**|**contentSize**|**position**|**直接父类**|**备注**|
|:-------|:-------|:-----------|:----|:---|:------|:------------|
|CCTMXTiledMap|同CCNode|同CCNode|max(childSize)|同CCNode| CCNode ||

### Particle 

|**类型**|**锚点**|**忽略锚点**|**contentSize**|**position**|**直接父类**|**备注**|
|:-------|:-------|:-----------|:----|:---|:------|:------------|
|CCParticleSystem|同CCNode|同CCNode|同CCNode|同CCNode| CCNode ||
|CCParticleBatchNode|同CCNode|同CCNode|同CCNode|同CCNode| CCNode ||
|CCParticleSystemQuad|同CCParticleSystem|同CCParticleSystem|同CCParticleSystem|同CCParticleSystem| CCParticleSystem ||
|CCParticleSun|同CCParticleSystemQuad|同CCParticleSystemQuad|同CCParticleSystemQuad|winSize/2| CCParticleSystemQuad |太阳|
|CCParticleSpiral|同CCParticleSystemQuad|同CCParticleSystemQuad|同CCParticleSystemQuad|winSize/2| CCParticleSystemQuad |螺旋|
|CCParticleSnow|同CCParticleSystemQuad|同CCParticleSystemQuad|同CCParticleSystemQuad|(winSize.width/2, winSize.height/2 + 10)| CCParticleSystemQuad |下雪|

其它粒子效果属性请参考[CCParticleExamples.h](https://github.com/cocos2d/cocos2d-x/blob/cocos2d-x-2.2.3/cocos2dx/particle_nodes/CCParticleSystem.cpp).

### CCTransitionScene

|**类型**|**锚点**|**忽略锚点**|**contentSize**|**position**|**直接父类**|**备注**|
|:-------|:-------|:-----------|:----|:---|:------|:------------|
|CCTransitionScene|同CCScene|同CCScene|同CCScene|同CCNode| CCScene ||
|CCTransitionFade|同CCTransitionScene|同CCTransitionScene|同CCTransitionScene|同CCTransitionScene| CCTransitionScene ||

其他过渡场景类请参考：[CCTransition.cpp](https://github.com/cocos2d/cocos2d-x/blob/cocos2d-x-2.2.3/cocos2dx/layers_scenes_transitions_nodes/CCTransition.cpp)

## 3.X 和 2.x 的主要不同 (以3.2为例)
0. NodeRGBA被标记为deprecated. 因此，之前继承自CCNodeRGBA的类都会有变化，比如下文将提到的Sprite, MenuItem.
1. Scene可通过createWithSize指定contentSize的方式来创建. 
2. LayerColor不再继承LayerRGBA, 而是直接继承Layer. LayerRGBA被标记为deprecated. LayerColor与Layer一样，默认的contentSize是winSize, 其子类LayerGradient也是如此。
3. Sprite不再继承自CCNodeRGBA, 而是直接继承Node。初始的锚点设置为(0.5, 0.5) (默认的变换锚点为中心), 是在initWithTexture这个初始化方法里做的属性赋值，其它几个初始化方法，最终调用的都是initWithTexture(Texture2D *texture, const Rect& rect, bool rotated).
4. LabelBMFont的初始contentSize为_label->getContentSize(). _label为其member变量，类型为Label.
5. LabelTTF不再继承CCSprite, 而是继承Node. 内部包含一个Label类型的member变量_renderLabel.
6. TextFieldTTF不再继承CCLabelTTF, 而是继承Label.
7. Menu不再继承CCLayerRGBA, 而是继承Layer.




