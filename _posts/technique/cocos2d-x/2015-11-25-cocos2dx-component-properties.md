---
layout: post
title: "[cocos2d-x源码剖析]1: 源代码项目结构划分"
highlighter_style: solarizeddark
category: [cocos2d-x]
tags: [cocos2d-x, game]
description: ""
published: true
---

|**控件**|**锚点**|**忽略锚点**|**contentSize**|**position**|**直接父类**|
|:-------|:-------|:-----------|:----|:---|:------|
|CCNode| (0,0) | false| (0, 0)|(0, 0)| CCObject |
|CCNodeRGBA|同CCNode|同CCNode|同CCNode|同CCNode| CCNode |
|CCDrawNode| 同CCNode | 同CCNode| 同CCNode|同CCNode| CCNode |
|CCAtlasNode| 同CCNode | 同CCNode| 同CCNode|同CCNode| CCNode |
|Scene|(0.5, 0.5)|true|同CCNode|同CCNode| CCNode |
|CCLayer|(0.5, 0,5)|true|同CCNode|同CCNode| CCNode |
|CCLayerRGBA|同CCLayer|同CCLayer|同CCLayer|同CCLayer| CCLayer |
|CCLayerColor|同CCLayerRGBA|同CCLayerRGBA|同CCLayerRGBA|同CCLayerRGBA| CCLayerRGBA |
|CCLayerGradient|同CCLayerColor|同CCLayerColor|同CCLayerColor|同CCLayerColor| CCLayerColor |
|CCLayerMultiplex|同CCLayer|同CCLayer|同CCLayer|同CCLayer| CCLayer |
|CCSprite|同CCNodeRGBA|同CCNodeRGBA|同CCNodeRGBA|同CCNodeRGBA| CCNodeRGBA |
|CCSpriteBatchNode|同CCNode|同CCNode|同CCNode|同CCNode| CCNode |
|CCLabelAtlas|同CCAtlasNode|同CCAtlasNode|同CCAtlasNode|同CCAtlasNode| CCAtlasNode |
|CCLabelBMFont|同CCSpriteBatchNode|同CCSpriteBatchNode|同CCSpriteBatchNode|同CCSpriteBatchNode| CCSpriteBatchNode |
|CCLabelTTF|同CCSprite|同CCSprite|同CCSprite|同CCSprite| CCSprite |
|CCMenu|(0.5, 0.5)|true|winSize|winSize/2| CCLayerRGBA |
|CCMenuItem|(0.5, 0.5)|同CCNodeRGBA|同CCNodeRGBA|同CCNodeRGBA| CCNodeRGBA |
|CCMenuItemToggle|同CCMenuItem|同CCMenuItem|同CCMenuItem|同CCMenuItem| CCMenuItem |
|CCMenuItemLabel|同CCMenuItem|同CCMenuItem|同CCMenuItem|同CCMenuItem| CCMenuItem |
|CCMenuItemFont|同CCMenuItemLabel|同CCMenuItemLabel|同CCMenuItemLabel|同CCMenuItemLabel| CCMenuItemLabel |
|CCMenuItemAtlasFont|同CCMenuItemLabel|同CCMenuItemLabel|同CCMenuItemLabel|同CCMenuItemLabel| CCMenuItemLabel |
|CCMenuItemSprite|同CCMenuItem|同CCMenuItem|m_pNormalImage contentSize|同CCMenuItem| CCMenuItem |
|CCMenuItemImage|同CCMenuItemSprite|同CCMenuItemSprite|m_pNormalImage contentSize|同CCMenuItemSprite| CCMenuItemSprite |


