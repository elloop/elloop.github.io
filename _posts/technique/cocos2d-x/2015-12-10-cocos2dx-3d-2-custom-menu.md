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

// CCMenu是个Layer.
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

    // 菜单触摸响应的优先级 默认是kCCMenuHandlerPriority(-128)
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

    // 状态机, 在被removeChild的时候被调用
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

**CCMenu.cpp**

```c++
#include "CCMenu.h"
#include "CCDirector.h"
#include "CCApplication.h"
#include "support/CCPointExtension.h"
#include "touch_dispatcher/CCTouchDispatcher.h"
#include "touch_dispatcher/CCTouch.h"
#include "CCStdC.h"
#include "cocoa/CCInteger.h"

#include <vector>
#include <stdarg.h>

using namespace std;

NS_CC_BEGIN

static std::vector<unsigned int> ccarray_to_std_vector(CCArray* pArray)
{
    std::vector<unsigned int> ret;
    CCObject* pObj;
    CCARRAY_FOREACH(pArray, pObj)
    {
        CCInteger* pInteger = (CCInteger*)pObj;
        ret.push_back((unsigned int)pInteger->getValue());
    }
    return ret;
}

enum 
{
    kDefaultPadding =  5,
};

/***********************创建类方法*******************************/
CCMenu* CCMenu::create()
{
    return CCMenu::create(NULL, NULL);
}

CCMenu * CCMenu::create(CCMenuItem* item, ...)
{
    va_list args;
    va_start(args,item);
    
    CCMenu *pRet = CCMenu::createWithItems(item, args);
    
    va_end(args);
    
    return pRet;
}

CCMenu* CCMenu::createWithArray(CCArray* pArrayOfItems)
{
    CCMenu *pRet = new CCMenu();
    if (pRet && pRet->initWithArray(pArrayOfItems))
    {
        pRet->autorelease();
    }
    else
    {
        CC_SAFE_DELETE(pRet);
    }
    
    return pRet;
}

CCMenu* CCMenu::createWithItems(CCMenuItem* item, va_list args)
{
    CCArray* pArray = NULL;
    if( item )
    {
        pArray = CCArray::create(item, NULL);
        CCMenuItem *i = va_arg(args, CCMenuItem*);
        while(i)
        {
            pArray->addObject(i);
            i = va_arg(args, CCMenuItem*);
        }
    }
    
    return CCMenu::createWithArray(pArray);
}

CCMenu* CCMenu::createWithItem(CCMenuItem* item)
{
    return CCMenu::create(item, NULL);
}

bool CCMenu::init()
{
    return initWithArray(NULL);
}

/**********************初始化方法***************************/
bool CCMenu::initWithArray(CCArray* pArrayOfItems)
{
    if (CCLayer::init())
    {
        // 设置触摸响应优先级 
        setTouchPriority(kCCMenuHandlerPriority);
        // 单点触摸
        setTouchMode(kCCTouchesOneByOne);
        // 开启触摸
        setTouchEnabled(true);

        // 创建即启用
        m_bEnabled = true;

        CCSize s = CCDirector::sharedDirector()->getWinSize();

        // 忽略锚点
        this->ignoreAnchorPointForPosition(true);
        setAnchorPoint(ccp(0.5f, 0.5f));

        // Menu的默认大小是整个可视窗口的大小
        this->setContentSize(s);

        // 初始位置在屏幕中心, 因为忽略了锚点，所以通过它的左下角(0,0)点来定位，放在了屏幕中心
        setPosition(ccp(s.width/2, s.height/2));
        
        if (pArrayOfItems != NULL)
        {
            int z=0;
            CCObject* pObj = NULL;
            CCARRAY_FOREACH(pArrayOfItems, pObj)
            {
                // 添加“零件”，都是CCMenuItem类型的，在addChild里面会做RTTI类型检查。
                CCMenuItem* item = (CCMenuItem*)pObj;
                this->addChild(item, z);
                z++;
            }
        }
    
        // 默认没有选中任何“零件”
        m_pSelectedItem = NULL;

        // 初始状态为等待被摸
        m_eState = kCCMenuStateWaiting;
        
        // 开启级联透明和颜色
        setCascadeColorEnabled(true);
        setCascadeOpacityEnabled(true);
        
        return true;
    }
    return false;
}

// 重写addChild, 防止用户往CCMenu里塞不是CCMenuItem的东西
void CCMenu::addChild(CCNode * child)
{
    CCLayer::addChild(child);
}

void CCMenu::addChild(CCNode * child, int zOrder)
{
    CCLayer::addChild(child, zOrder);
}

void CCMenu::addChild(CCNode * child, int zOrder, int tag)
{
    // 重写addChild, 防止用户往CCMenu里塞不是CCMenuItem的东西
    CCAssert( dynamic_cast<CCMenuItem*>(child) != NULL, "Menu only supports MenuItem objects as children");
    CCLayer::addChild(child, zOrder, tag);
}

void CCMenu::onExit()
{
    // 在触摸过程中被移除，清空“零件”的选中状态
    if (m_eState == kCCMenuStateTrackingTouch)
    {
        if (m_pSelectedItem)
        {
            m_pSelectedItem->unselected();
            m_pSelectedItem = NULL;
        }
        
        m_eState = kCCMenuStateWaiting;
    }

    CCLayer::onExit();
}

void CCMenu::removeChild(CCNode* child, bool cleanup)
{
    // 移除时候也在检查是不是CCMenuItem
    CCMenuItem *pMenuItem = dynamic_cast<CCMenuItem*>(child);
    CCAssert(pMenuItem != NULL, "Menu only supports MenuItem objects as children");
    
    if (m_pSelectedItem == pMenuItem)
    {
        m_pSelectedItem = NULL;
    }
    
    CCNode::removeChild(child, cleanup);
}

/**************************触摸事件相关代码********************************/
void CCMenu::setHandlerPriority(int newPriority)
{
    CCTouchDispatcher* pDispatcher = CCDirector::sharedDirector()->getTouchDispatcher();
    pDispatcher->setPriority(newPriority, this);
}

// 注册单点触摸，吞噬
void CCMenu::registerWithTouchDispatcher()
{
    CCDirector* pDirector = CCDirector::sharedDirector();
    pDirector->getTouchDispatcher()->addTargetedDelegate(this, this->getTouchPriority(), true);
}

// 开始触摸j
bool CCMenu::ccTouchBegan(CCTouch* touch, CCEvent* event)
{
    CC_UNUSED_PARAM(event);
    // 已经开始触摸，或不可见，或被禁用，直接返回. 注意：此时触摸没被吞噬，其它节点能够响应此次触摸
    if (m_eState != kCCMenuStateWaiting || ! m_bVisible || !m_bEnabled)
    {
        return false;
    }

    // 在它的祖先中，任何一个是不可见的，意味着它自己也不可见，不响应触摸事件
    for (CCNode *c = this->m_pParent; c != NULL; c = c->getParent())
    {
        if (c->isVisible() == false)
        {
            return false;
        }
    }

    // 检查通过，可以进行进一步判断了

    // 判断摸在哪个“零件”上
    m_pSelectedItem = this->itemForTouch(touch);
    // 真的摸在了“零件”上
    if (m_pSelectedItem)
    {
        // 置触摸状态为： 正在被摸
        m_eState = kCCMenuStateTrackingTouch;
        // 触发零件的selected方法
        m_pSelectedItem->selected();
        // 吞噬触摸，继续监听touchMoved等事件
        return true;
    }
    return false;
}

// 松开手指，触摸结束
void CCMenu::ccTouchEnded(CCTouch *touch, CCEvent* event)
{
    CC_UNUSED_PARAM(touch);
    CC_UNUSED_PARAM(event);
    // 校验触摸状态
    CCAssert(m_eState == kCCMenuStateTrackingTouch, "[Menu ccTouchEnded] -- invalid state");

    // 最后的触摸点是否落在了某个“零件”上？
    if (m_pSelectedItem)
    {
        // 松开按钮，调用其unselected方法
        m_pSelectedItem->unselected();
        // activate将调用CCMenuItem的回调函数
        m_pSelectedItem->activate();
    }
    // 重置触摸状态
    m_eState = kCCMenuStateWaiting;
}

void CCMenu::ccTouchCancelled(CCTouch *touch, CCEvent* event)
{
    CC_UNUSED_PARAM(touch);
    CC_UNUSED_PARAM(event);
    CCAssert(m_eState == kCCMenuStateTrackingTouch, "[Menu ccTouchCancelled] -- invalid state");
    if (m_pSelectedItem)
    {
        m_pSelectedItem->unselected();
    }
    m_eState = kCCMenuStateWaiting;
}

// 在菜单上移动手指
void CCMenu::ccTouchMoved(CCTouch* touch, CCEvent* event)
{
    CC_UNUSED_PARAM(event);
    // 校验状态
    CCAssert(m_eState == kCCMenuStateTrackingTouch, "[Menu ccTouchMoved] -- invalid state");

    // 现在，触摸点移动到哪个“零件”了？
    CCMenuItem *currentItem = this->itemForTouch(touch);

    // 如果新的“零件”和刚才选中的“零件”不一样
    // 不一样包括多种情形：
    // 1. 从一个“零件”移动到了空白处；
    // 2. 从空白处，移动到了某个“零件”
    // 3. 从一个“零件”移动到另一个“零件”
    if (currentItem != m_pSelectedItem) 
    {
        if (m_pSelectedItem)
        {
            // 第1种或第3种情形
            // 取消当前“零件”的选中状态
            m_pSelectedItem->unselected();
        }

        // 更新新的“零件”选中状态，可能变为空
        m_pSelectedItem = currentItem;
        if (m_pSelectedItem)
        {
            // 第2或3种情形，新“零件”选中
            m_pSelectedItem->selected();
        }
    }
}

/************************排列“零件”**********************************/
void CCMenu::alignItemsVertically()
{
    this->alignItemsVerticallyWithPadding(kDefaultPadding);
}

void CCMenu::alignItemsVerticallyWithPadding(float padding)
{
    float height = -padding;
    if (m_pChildren && m_pChildren->count() > 0)
    {
        CCObject* pObject = NULL;
        CCARRAY_FOREACH(m_pChildren, pObject)
        {
            CCNode* pChild = dynamic_cast<CCNode*>(pObject);
            if (pChild)
            {
                height += pChild->getContentSize().height * pChild->getScaleY() + padding;
            }
        }
    }

    float y = height / 2.0f;
    if (m_pChildren && m_pChildren->count() > 0)
    {
        CCObject* pObject = NULL;
        CCARRAY_FOREACH(m_pChildren, pObject)
        {
            CCNode* pChild = dynamic_cast<CCNode*>(pObject);
            if (pChild)
            {
                pChild->setPosition(ccp(0, y - pChild->getContentSize().height * pChild->getScaleY() / 2.0f));
                y -= pChild->getContentSize().height * pChild->getScaleY() + padding;
            }
        }
    }
}

void CCMenu::alignItemsHorizontally(void)
{
    this->alignItemsHorizontallyWithPadding(kDefaultPadding);
}

void CCMenu::alignItemsHorizontallyWithPadding(float padding)
{
    float width = -padding;
    if (m_pChildren && m_pChildren->count() > 0)
    {
        CCObject* pObject = NULL;
        CCARRAY_FOREACH(m_pChildren, pObject)
        {
            CCNode* pChild = dynamic_cast<CCNode*>(pObject);
            if (pChild)
            {
                width += pChild->getContentSize().width * pChild->getScaleX() + padding;
            }
        }
    }

    float x = -width / 2.0f;
    if (m_pChildren && m_pChildren->count() > 0)
    {
        CCObject* pObject = NULL;
        CCARRAY_FOREACH(m_pChildren, pObject)
        {
            CCNode* pChild = dynamic_cast<CCNode*>(pObject);
            if (pChild)
            {
                pChild->setPosition(ccp(x + pChild->getContentSize().width * pChild->getScaleX() / 2.0f, 0));
                 x += pChild->getContentSize().width * pChild->getScaleX() + padding;
            }
        }
    }
}

void CCMenu::alignItemsInColumns(unsigned int columns, ...)
{
    va_list args;
    va_start(args, columns);

    this->alignItemsInColumns(columns, args);

    va_end(args);
}

void CCMenu::alignItemsInColumns(unsigned int columns, va_list args)
{
    CCArray* rows = CCArray::create();
    while (columns)
    {
        rows->addObject(CCInteger::create(columns));
        columns = va_arg(args, unsigned int);
    }
    alignItemsInColumnsWithArray(rows);
}

void CCMenu::alignItemsInColumnsWithArray(CCArray* rowsArray)
{
    vector<unsigned int> rows = ccarray_to_std_vector(rowsArray);

    int height = -5;
    unsigned int row = 0;
    unsigned int rowHeight = 0;
    unsigned int columnsOccupied = 0;
    unsigned int rowColumns;

    if (m_pChildren && m_pChildren->count() > 0)
    {
        CCObject* pObject = NULL;
        CCARRAY_FOREACH(m_pChildren, pObject)
        {
            CCNode* pChild = dynamic_cast<CCNode*>(pObject);
            if (pChild)
            {
                CCAssert(row < rows.size(), "");

                rowColumns = rows[row];
                // can not have zero columns on a row
                CCAssert(rowColumns, "");

                float tmp = pChild->getContentSize().height;
                rowHeight = (unsigned int)((rowHeight >= tmp || isnan(tmp)) ? rowHeight : tmp);

                ++columnsOccupied;
                if (columnsOccupied >= rowColumns)
                {
                    height += rowHeight + 5;

                    columnsOccupied = 0;
                    rowHeight = 0;
                    ++row;
                }
            }
        }
    }    

    // check if too many rows/columns for available menu items
    CCAssert(! columnsOccupied, "");

    CCSize winSize = CCDirector::sharedDirector()->getWinSize();

    row = 0;
    rowHeight = 0;
    rowColumns = 0;
    float w = 0.0;
    float x = 0.0;
    float y = (float)(height / 2);

    if (m_pChildren && m_pChildren->count() > 0)
    {
        CCObject* pObject = NULL;
        CCARRAY_FOREACH(m_pChildren, pObject)
        {
            CCNode* pChild = dynamic_cast<CCNode*>(pObject);
            if (pChild)
            {
                if (rowColumns == 0)
                {
                    rowColumns = rows[row];
                    w = winSize.width / (1 + rowColumns);
                    x = w;
                }

                float tmp = pChild->getContentSize().height;
                rowHeight = (unsigned int)((rowHeight >= tmp || isnan(tmp)) ? rowHeight : tmp);

                pChild->setPosition(ccp(x - winSize.width / 2,
                                       y - pChild->getContentSize().height / 2));

                x += w;
                ++columnsOccupied;

                if (columnsOccupied >= rowColumns)
                {
                    y -= rowHeight + 5;

                    columnsOccupied = 0;
                    rowColumns = 0;
                    rowHeight = 0;
                    ++row;
                }
            }
        }
    }    
}

void CCMenu::alignItemsInRows(unsigned int rows, ...)
{
    va_list args;
    va_start(args, rows);

    this->alignItemsInRows(rows, args);

    va_end(args);
}

void CCMenu::alignItemsInRows(unsigned int rows, va_list args)
{
    CCArray* pArray = CCArray::create();
    while (rows)
    {
        pArray->addObject(CCInteger::create(rows));
        rows = va_arg(args, unsigned int);
    }
    alignItemsInRowsWithArray(pArray);
}

void CCMenu::alignItemsInRowsWithArray(CCArray* columnArray)
{
    vector<unsigned int> columns = ccarray_to_std_vector(columnArray);

    vector<unsigned int> columnWidths;
    vector<unsigned int> columnHeights;

    int width = -10;
    int columnHeight = -5;
    unsigned int column = 0;
    unsigned int columnWidth = 0;
    unsigned int rowsOccupied = 0;
    unsigned int columnRows;

    if (m_pChildren && m_pChildren->count() > 0)
    {
        CCObject* pObject = NULL;
        CCARRAY_FOREACH(m_pChildren, pObject)
        {
            CCNode* pChild = dynamic_cast<CCNode*>(pObject);
            if (pChild)
            {
                // check if too many menu items for the amount of rows/columns
                CCAssert(column < columns.size(), "");

                columnRows = columns[column];
                // can't have zero rows on a column
                CCAssert(columnRows, "");

                // columnWidth = fmaxf(columnWidth, [item contentSize].width);
                float tmp = pChild->getContentSize().width;
                columnWidth = (unsigned int)((columnWidth >= tmp || isnan(tmp)) ? columnWidth : tmp);

                columnHeight += (int)(pChild->getContentSize().height + 5);
                ++rowsOccupied;

                if (rowsOccupied >= columnRows)
                {
                    columnWidths.push_back(columnWidth);
                    columnHeights.push_back(columnHeight);
                    width += columnWidth + 10;

                    rowsOccupied = 0;
                    columnWidth = 0;
                    columnHeight = -5;
                    ++column;
                }
            }
        }
    }

    // check if too many rows/columns for available menu items.
    CCAssert(! rowsOccupied, "");

    CCSize winSize = CCDirector::sharedDirector()->getWinSize();

    column = 0;
    columnWidth = 0;
    columnRows = 0;
    float x = (float)(-width / 2);
    float y = 0.0;

    if (m_pChildren && m_pChildren->count() > 0)
    {
        CCObject* pObject = NULL;
        CCARRAY_FOREACH(m_pChildren, pObject)
        {
            CCNode* pChild = dynamic_cast<CCNode*>(pObject);
            if (pChild)
            {
                if (columnRows == 0)
                {
                    columnRows = columns[column];
                    y = (float) columnHeights[column];
                }

                // columnWidth = fmaxf(columnWidth, [item contentSize].width);
                float tmp = pChild->getContentSize().width;
                columnWidth = (unsigned int)((columnWidth >= tmp || isnan(tmp)) ? columnWidth : tmp);

                pChild->setPosition(ccp(x + columnWidths[column] / 2,
                                       y - winSize.height / 2));

                y -= pChild->getContentSize().height + 10;
                ++rowsOccupied;

                if (rowsOccupied >= columnRows)
                {
                    x += columnWidth + 5;
                    rowsOccupied = 0;
                    columnRows = 0;
                    columnWidth = 0;
                    ++column;
                }
            }
        }
    }
}

// 判断触摸点落在哪个“零件”上
CCMenuItem* CCMenu::itemForTouch(CCTouch *touch)
{
    // 获得当前触摸点的OpenGL坐标
    CCPoint touchLocation = touch->getLocation();

    // 遍历所有“零件”
    if (m_pChildren && m_pChildren->count() > 0)
    {
        CCObject* pObject = NULL;
        // m_pChildren是所有“零件”的集合，他们是如何排序的呢？在CCNode中，是按照zOrder从大到小排序的，zOrder大的“零件”在前面; zOrder相同的，后添加的在前面，优先判断被摸状态
        CCARRAY_FOREACH(m_pChildren, pObject)
        {
            CCMenuItem* pChild = dynamic_cast<CCMenuItem*>(pObject);

            // 忽略掉不可见或者被禁用的“零件”
            if (pChild && pChild->isVisible() && pChild->isEnabled())
            {
                // 将触摸点坐标转换到该“零件”的节点坐标系下
                CCPoint local = pChild->convertToNodeSpace(touchLocation);

                // 得到“零件”的矩形轮廓, (0, 0, width, height)
                CCRect r = pChild->rect();
                r.origin = CCPointZero;

                // 判断触摸点转换为“零件”的节点坐标之后，是否在矩形轮廓内
                if (r.containsPoint(local))
                {
                    // 在，那就是这个“零件”被摸了，返回它
                    return pChild;
                }
            }
        }
    }

    return NULL;
}

NS_CC_END
```

可以看到CCMenu的实现还是比较清晰、简单的，它本身作为一个CCMenuItem的容器，响应单点触摸事件，判断哪个item被点击，并调用其对应方法完成菜单消息响应，核心在于对触摸事件的处理，坐标点的判断。

## 点击缩放功能的菜单按钮

在实际的游戏开发中，最常用的CCMenuItem要属CCMenuItemImage了，在HelloWorld的Demo中可以看到，要创建一个关闭按钮通常是这样写：

```c++
CCMenuItemImage *pCloseItem = CCMenuItemImage::create(
                                        "CloseNormal.png",
                                        "CloseSelected.png",
                                        this,
                                        menu_selector(HelloWorld::menuCloseCallback));
```

其中用到了两张图片，第一张是按钮在正常状态下的图片，第二张是被点击时候的选中状态的图片。如果两种状态下按钮的图片是相近的那最好就只用一张，正常和选中都用同一个图片，然后在按钮被按下的时候让它有一个放大的效果，恢复正常之后再自动恢复原来的缩放。这样就节省了一张图片素材。

那么如果要实现一个点击缩放的菜单按钮该如何做呢？

我们知道CCMenuItemLabel在被选中的时候是有一个缩放效果的，它的selected和unselected方法是这样：

```c++
void CCMenuItemLabel::selected()
{
    if(m_bEnabled)
    {
        CCMenuItem::selected();
        
        CCAction *action = getActionByTag(kZoomActionTag);
        if (action)
        {
            this->stopAction(action);
        }
        else
        {
            m_fOriginalScale = this->getScale();
        }
        
        // 缩放到原始尺寸的1.2倍
        CCAction *zoomAction = CCScaleTo::create(0.1f, m_fOriginalScale * 1.2f);
        zoomAction->setTag(kZoomActionTag);
        this->runAction(zoomAction);
    }
}

void CCMenuItemLabel::unselected()
{
    if(m_bEnabled)
    {
        CCMenuItem::unselected();
        this->stopActionByTag(kZoomActionTag);
        // 缩放回原来的尺寸
        CCAction *zoomAction = CCScaleTo::create(0.1f, m_fOriginalScale);
        zoomAction->setTag(kZoomActionTag);
        this->runAction(zoomAction);
    }
}
```

按照相同的处理方式，我可以copy一份CCMenuItemImage的实现，改个名字，然后按照CCMenuItemLabel的方式重写selected和unselected方法就可以实现和CCMenuItemLabel同样的缩放效果，但是这里会有一个问题，我实现了一个新的CCMenuItemImage达到了缩放的效果，那对于它的父类CCMenuItemSprite呢，其实跟CCMenuItemImage是一个东西，只是创建方式是传入Sprite，而不是纹理的名字，对于它也要缩放，那还要实现一遍CCMenuItemSprite的翻版，对于新定义的按钮，要缩放也要重写selected和unseleceted，加入的内容也都是相同的，即CCScaleTo的action动作。与其每个CCMenuItem的子类都重写一遍加入缩放代码，还不如在顶层只搞一次。顶层在哪里，我们从CCMenu的源码中已经看到，是CCMenu的触摸响应里调用的CCMenuItem的selected和unseleceted等方法，那么干脆在CCMenu里加上缩放行不行。

下面我自己copy了一份CCMenu的实现，改名为Menu，为避免名字冲突放在一个单独的命名空间里，暂且叫这个namespace为`elloop`.

下面就是这个Menu类的实现代码：

**自定义菜单类Menu.h, 仅列出改动的部分，其它部分跟CCMenu.h是一样的:**

```c++
#ifndef CPP_DEMO_CUSTOM_MENU_H
#define CPP_DEMO_CUSTOM_MENU_H

#include "cocos2d.h"
#include "cocos_include.h"


NS_BEGIN(elloop);           // namespace elloop {


// 这枚举去掉了 CC， 避免与CCMenu中同名枚举混淆
typedef enum  
{
    kMenuStateWaiting,          
    kMenuStateTrackingTouch
} tMenuState;


enum {
    kMenuHandlerPriority = -128,            // 去掉了kCCMenuHandlerPriority里面的CC
};

class Menu : public cocos2d::CCLayerRGBA
{
public:
    // 添加了一个缩放成员变量, 其它部分跟CCMenu.h内容完全一致
    Menu() : m_pSelectedItem(NULL), itemOriginScale_(1.f) {}
protected:
    float                   itemOriginScale_;
};

NS_END(elloop);    // }  end of namespace elloop

#endif//CPP_DEMO_CUSTOM_MENU_H
```

**自定义缩放按钮实现文件：Menu.cpp, 也仅列出改变的部分**

```c++
NS_BEGIN(elloop);

bool Menu::ccTouchBegan(CCTouch* touch, CCEvent* event)
{
    CC_UNUSED_PARAM(event);
    if (m_eState != kMenuStateWaiting || !m_bVisible || !m_bEnabled)
    {
        return false;
    }

    for (CCNode *c = this->m_pParent; c != NULL; c = c->getParent())
    {
        if (c->isVisible() == false)
        {
            return false;
        }
    }

    m_pSelectedItem = this->itemForTouch(touch);
    if (m_pSelectedItem)
    {
        m_eState = kMenuStateTrackingTouch;
        m_pSelectedItem->selected();

        // begin : 控制CCMenuItem缩放的代码
        itemOriginScale_ = m_pSelectedItem->getScale();
        m_pSelectedItem->setScale(itemOriginScale_ * 1.2);
        // end

        return true;
    }
    return false;
}

void Menu::ccTouchEnded(CCTouch *touch, CCEvent* event)
{
    CC_UNUSED_PARAM(touch);
    CC_UNUSED_PARAM(event);
    CCAssert(m_eState == kMenuStateTrackingTouch, "[Menu ccTouchEnded] -- invalid state");
    if (m_pSelectedItem)
    {
        m_pSelectedItem->unselected();
        m_pSelectedItem->activate();

        // begin : 控制CCMenuItem缩放的代码
        m_pSelectedItem->setScale(itemOriginScale_);
        // end
    }
    m_eState = kMenuStateWaiting;
}

void Menu::ccTouchCancelled(CCTouch *touch, CCEvent* event)
{
    CC_UNUSED_PARAM(touch);
    CC_UNUSED_PARAM(event);
    CCAssert(m_eState == kMenuStateTrackingTouch, "[Menu ccTouchCancelled] -- invalid state");
    if (m_pSelectedItem)
    {
        m_pSelectedItem->unselected();

        // begin : 控制CCMenuItem缩放的代码
        m_pSelectedItem->setScale(itemOriginScale_);
        // end
    }
    m_eState = kMenuStateWaiting;
}

void Menu::ccTouchMoved(CCTouch* touch, CCEvent* event)
{
    CC_UNUSED_PARAM(event);
    CCAssert(m_eState == kMenuStateTrackingTouch, "[Menu ccTouchMoved] -- invalid state");
    CCMenuItem *currentItem = this->itemForTouch(touch);
    if (currentItem != m_pSelectedItem)
    {
        if (m_pSelectedItem)
        {
            m_pSelectedItem->unselected();

            // begin : 控制CCMenuItem缩放的代码
            m_pSelectedItem->setScale(itemOriginScale_);
            // end
        }
        m_pSelectedItem = currentItem;
        if (m_pSelectedItem)
        {
            m_pSelectedItem->selected();

            // begin : 控制CCMenuItem缩放的代码
            itemOriginScale_ = m_pSelectedItem->getScale();
            m_pSelectedItem->setScale(itemOriginScale_ * 1.2);
            // end
        }
    }
}

NS_END(elloop);
```

**自定义菜单类的使用方法**

```c++

// 正常的方式来创建三个CCMenuItem, 两个CCMenuItemImage, 一个CCMenuItemLabel
// 从左到右水平排列

auto menuItemImage1 = CCMenuItemImage::create(
        "DemoIcon/home_small.png", "DemoIcon/home_small.png",
        this,menu_selector(TouchTestPage::menuCallback));

auto menuItemImage2 = CCMenuItemImage::create(
        "DemoIcon/home_small.png", "DemoIcon/home_small.png",
        this, menu_selector(TouchTestPage::menuCallback));

menuItemImage2->setPosition(CCPoint(menuItemImage1->getContentSize().width, 
            0));

auto label = CCLabelTTF::create("hello", "arial.ttf", 20);
auto menuItemLabel = CCMenuItemLabel::create(label);
menuItemLabel->setPosition(CCPoint(menuItemImage2->getPositionX() + menuItemImage1->getContentSize().width, 0));

// 指定使用elloop命名空间下的Menu.
using elloop::Menu;
// Menu的创建方式跟CCMenu的创建方式完全一样
Menu *menu = Menu::create(menuItemImage1, menuItemImage2, menuItemLabel, nullptr);
ADD_CHILD(menu);
```

代码中之所以加上一个CCMenuItemLabel类型的按钮是为了测试，本身就带有缩放功能的CCMenuItem会不会和带有缩放功能的Menu父容器产生冲突，是否会产生叠加放大的效果？

下面是运行截图：

![CustomMenu](http://7xi3zl.com1.z0.glb.clouddn.com/CustomMenu.gif)

从图中能看到，两个CCMenuItemImage是可以实现自动缩放效果的，CCMenuItemLabel的缩放动作也没有与Menu的缩放发生冲突(这是为什么？涉及到Action的更新，在后面总结到动作系统的时候再做出分析)。

此外，如果觉得Menu固定的把CCMenuItem放大到1.2不够灵活，可以把数字抽离成一个成员变量，并设置setter来灵活控制缩放比例.

测试的代码，跟上一篇文章的代码放在了一起，在TouchTestPage.cpp中。感兴趣的朋友可以到代码仓库瞅瞅。

## <font color="red">源码</font>

- [缩放按钮Menu的实现](https://github.com/elloop/cocos2d-x-cpp-demos-2.x/blob/master/Classes/customs/Menu.cpp)

- [缩放按钮Menu的使用范例](https://github.com/elloop/cocos2d-x-cpp-demos-2.x/blob/master/Classes/pages/TouchTestPage.cpp)

---------------------------
**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**欢迎访问[github博客](http://elloop.github.io)，与本站同步更新**

