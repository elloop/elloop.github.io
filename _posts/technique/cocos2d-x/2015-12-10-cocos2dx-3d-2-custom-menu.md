---
layout: post
title: "【cocos2d-x 3D游戏开发】2: 2D基础回顾---理解CCMenu类的实现, 实现点击放大的菜单按钮"
highlighter_style: solarizeddark
category: [cocos2d-x]
tags: [cocos2d-x, game]
description: ""
published: true
---

## 前言

本文介绍了CCMenu类的实现原理，并在CCMenu的基础上稍加改造，实现了一个点击自动缩放的菜单类。

<!--more-->

## CCMenu的实现 -- 单点触摸事件很好的使用范例

在上一篇文中里回顾了cocos中单点触摸的用法和触摸事件分发机制、优先级控制等内容，也给出了自己写的小demo，其实在cocos本身就有很好的触摸事件的使用范例，其中就包括CCMenu的实现，下面我们结合引擎源代码来分析一下它的实现原理。

CCMenu本质上就是一个Touchable，并且是单点触摸的。它身上挂满了各种“零件”（各种CCMenuItem的子类），你摸它的时候，假设你摸在A点，它就判断A点落在它的哪个“零件”上, 它就会叫那个“零件”做出反应, 完成那个“零件”应该完成的任务（调用你在创建CCMenuItem子类时绑定的handler）.

**CCMenu.h:**

```c++
#ifndef __CCMENU_H_
#define __CCMENU_H_

#include "CCMenuItem.h"
#include "layers_scenes_transitions_nodes/CCLayer.h"

NS_CC_BEGIN

// 用于判断菜单被触摸的状态
typedef enum  
{
    kCCMenuStateWaiting,            // 没被摸呢
    kCCMenuStateTrackingTouch       // 正在被摸
} tCCMenuState;

enum {
    // 菜单的触摸优先级，-128, 一般人抢不过它，你要想比它先响应触摸事件，就要比-128还要小
    kCCMenuHandlerPriority = -128, 
};

class CC_DLL CCMenu : public CCLayerRGBA
{
    bool m_bEnabled;    // 禁用了吗
    
public:
    CCMenu() : m_pSelectedItem(NULL) {}

    virtual ~CCMenu(){}

    // 创建方法，最后殊途同归到：createWithArray
    static CCMenu* create();
    static CCMenu* create(CCMenuItem* item, ...);
    static CCMenu* createWithItem(CCMenuItem* item);
    static CCMenu* createWithItems(CCMenuItem *firstItem, va_list args);
    static CCMenu* createWithArray(CCArray* pArrayOfItems);

    bool init();
    // 真正的创建在这里完成，init() == initWithArray(nullptr)
    bool initWithArray(CCArray* pArrayOfItems);


    // 如何摆放自己身上的“零件”， 垂直、水平、按列对齐、按行对齐
    void alignItemsVertically();
    void alignItemsVerticallyWithPadding(float padding);
    void alignItemsHorizontallyWithPadding(float padding);
    void alignItemsInColumns(unsigned int columns, va_list args);
    void alignItemsInColumnsWithArray(CCArray* rows);
    void alignItemsInRows(unsigned int rows, ...);
    void alignItemsInRows(unsigned int rows, va_list args);
    void alignItemsInRowsWithArray(CCArray* columns);

    /** set event handler priority. By default it is: kCCMenuTouchPriority */
    void setHandlerPriority(int newPriority);

    // 重写CCNode的这一堆方法为了什么？ 就为了判断你是不是往菜单里塞了不是CCMenuItem*类型的东西.
    virtual void addChild(CCNode * child);
    virtual void addChild(CCNode * child, int zOrder);
    virtual void addChild(CCNode * child, int zOrder, int tag);
    virtual void removeChild(CCNode* child, bool cleanup);

    // CCLayer的方法，注册到触摸事件分发中心：CCTouchDispatcher
    virtual void registerWithTouchDispatcher();

    // 重点，响应单点触摸
    virtual bool ccTouchBegan(CCTouch* touch, CCEvent* event);
    virtual void ccTouchEnded(CCTouch* touch, CCEvent* event);
    virtual void ccTouchCancelled(CCTouch *touch, CCEvent* event);
    virtual void ccTouchMoved(CCTouch* touch, CCEvent* event);

    // 状态机
    virtual void onExit();

    // 暂时忽略
    virtual void setOpacityModifyRGB(bool bValue) {CC_UNUSED_PARAM(bValue);}
    virtual bool isOpacityModifyRGB(void) { return false;}
    
    // 不用说了
    virtual bool isEnabled() { return m_bEnabled; }
    virtual void setEnabled(bool value) { m_bEnabled = value; };

protected:
    CCMenuItem* itemForTouch(CCTouch * touch);      // 判断自身的哪个“零件”被摸到了
    tCCMenuState m_eState;                          // 触摸状态，
    CCMenuItem *m_pSelectedItem;                    // 被摸到的那个“零件”
};

NS_CC_END

#endif//__CCMENU_H_
```


## source codes

**源代码仓库地址: [cocos2d-x-cpp-demos-2.x](https://github.com/elloop/cocos2d-x-cpp-demos-2.x/blob/master/Classes/pages/TouchTestPage.cpp), 是本人写的一个小型Demo框架，方便添加测试代码或者用来开发游戏，如果觉得有用请帮忙点个Star，谢谢**

---------------------------
**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**欢迎访问[github博客](http://elloop.github.io)，与本站同步更新**

