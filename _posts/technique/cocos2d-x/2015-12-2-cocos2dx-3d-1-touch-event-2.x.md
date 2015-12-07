---
layout: post
title: "【cocos2d-x 3D游戏开发】1: 2D基础回顾---触摸事件(2.x)"
highlighter_style: solarizeddark
category: [cocos2d-x]
tags: [cocos2d-x, game]
description: ""
published: true
---

前言
---

本文回顾了cocos2d-x中触摸事件的使用方法和注意事项，并给出一个带有点击缩放功能的自定义菜单类的实现。

<!--more-->

## 一个非常简单的触摸事件响应示例

在cocos2d-x中Layer是直接继承了触摸代理的类，也就是说它“天生”就带有响应触摸事件的功能. 要想启动Layer的触摸响应功能，仅需要一句代码：`setTouchEnabled(true)`

下面以hello world示例为基础，添加一下触摸的功能, 非常的简单, 请看代码：

```c++
// HelloWorldScene.h
class HelloWorld : public cocos2d::CCLayer
{
public:
    virtual bool init();  

    static cocos2d::CCScene* scene();
    
    CREATE_FUNC(HelloWorld);
};

// HelloWorldScene.cpp
CCScene* HelloWorld::scene()
{
    CCScene *scene = CCScene::create();

    HelloWorld *layer = HelloWorld::create();
    layer->setTouchEnabled(true);               // 开启触摸事件响应

    scene->addChild(layer);
    return scene;
}

bool HelloWorld::init()
{
    return CCLayer::init();
}
```

编译运行代码，并且在`CCLayer::ccTouchesBegan`, `CCLayer::ccTouchesMoved`, `CCLayer::ccTouchesEnded`等函数内添加断点，当用鼠标点击或在Layer上面做拖拽的时候，断点就会触发。

## 重写ccTouchesBegan等函数，实现自定义触摸事件响应逻辑

调用Layer的setTouchEnabled(true)之后，Layer默认开启了`标准触摸（多点触摸）`模式，触摸事件发生时，它的ccTouchesXXX()系列方法会被调用；

还有第二种模式，叫`TargetedTouch（单点触摸）`模式，通过调用`layer->setTouchMode(kCCTouchesOneByOne)`来切换为单点触摸，触摸发生时，Layer的ccTouchXXX()系列方法会被调用, 注意这里跟多点触摸的区别是没有复数的es.

我们对触摸事件感兴趣无非就是为了在发生触摸事件的时候，要自己做一些事情，这些事情就是写在响应函数里的。那么如何实现自定义的响应逻辑呢？

在Layer的ccTouchBegan函数里已经提示我们了，看下面:

```c++
bool CCLayer::ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent)
{
    if (kScriptTypeNone != m_eScriptType)
    {
        return excuteScriptTouchHandler(CCTOUCHBEGAN, pTouch) == 0 ? false : true;
    }

    CC_UNUSED_PARAM(pTouch);
    CC_UNUSED_PARAM(pEvent);
    CCAssert(false, "Layer#ccTouchBegan override me"); // 重写我！！
    return true;
}
```

相信大家自己也能想到，在HelloWorld的Layer里通过重写ccTouchBegan系列函数就能实现自定义触摸事件的响应逻辑了。

## 我不是Layer，能接收触摸事件吗？

能! 你只需要让自己成为可触摸的(Touchable).

Layer为什么能够响应触摸事件？

触摸事件发生后，为什么是ccTouchesBegan, ccTouchesMoved等函数被调用, 而不是其它函数？

触摸事件的调度过程是典型的观察者模式，和常见的消息分发系统一样，你要是对某个事件感兴趣，那么你就注册为该事件的观察者，待该事件发生，事件分发中心会通知你。你要遵循事件中心的规定，准备好接口，方便事件中心将事件分发给你。

在触摸事件分发过程中，事件中心是CCTouchDispatcher, `你`是类似Layer这种观察者（我们姑且命名它为Touchable）， 要准备好的接口由CCTouchDelegate来定义。

- 第一步，你要接收触摸事件，首先要让自己成为Touchable，这可以通过继承CCTouchDelegate来实现

- 第二步, 你要成为触摸事件的观察者，需要把自己注册到事件中心，可通过`CCTouchDispatcher::addStandardDelegate`或者`CCTouchDispatcher::addTargetedDelegate`来实现注册过程. 这两个接口只接收Touchable类型的东西，这也是第一步的原因

- 第三步, 重写CCTouchDelegate里的接口，加入自己的触摸响应逻辑代码，准备好接收触摸事件. 使用完及时把自己从事件中心移除掉.

可以通过下面的示例代码来说明这一过程：

```c++
// 定义一个Touchable
class Touchable : public cocos2d::CCTouchDelegate //, 其他类...
{
public:

    // ..... create()方法等

    // 下面八个接口均是从CCTouchDelegate里继承得到，按需要来选择重写.
    // 可选实现
    bool ccTouchBegan(CCTouch *pTouch, CCEvent *pEvent) override {return true;}
    void ccTouchMoved(CCTouch *pTouch, CCEvent *pEvent) override {}
    void ccTouchEnded(CCTouch *pTouch, CCEvent *pEvent) override {}
    void ccTouchCancelled(CCTouch *pTouch, CCEvent *pEvent) override {}

    // 可选实现
    void ccTouchesBegan(CCSet *pTouches, CCEvent *pEvent) override {}
    void ccTouchesMoved(CCSet *pTouches, CCEvent *pEvent) override {}
    void ccTouchesEnded(CCSet *pTouches, CCEvent *pEvent) override {}
    void ccTouchesCancelled(CCSet *pTouches, CCEvent *pEvent) override {}
};

// 注册到事件中心CCTouchDispatcher
void registerTouchable()
{
    auto touchDispatcher = CCDirector::sharedDirector()->getTouchDispatcher();
    // 单点触摸
    touchDispatcher->addTargetedDelegate(Touchable::create(), 0, true);
    // 多点触摸
    touchDispatcher->addStandardDelegate(Touchable::create(), 0);
}

// 移除监听
void removeTouchable()
{
    auto touchDispatcher = CCDirector::sharedDirector()->getTouchDispatcher();
    auto touchable = getTouchable();
    // 单点触摸 多点触摸都是通过此接口来移除
    touchDispatcher->removeDelegate(touchable);
}
```

回答上面那两个问题：
1. Layer为什么能够响应触摸事件？ ： 因为它继承了CCTouchDelegate, 它是Touchable, 并且通过调用setTouchEnabled(true)把自己注册到了事件中心CCTouchDispatcher.(setTouchEnabled只是打开了一个开关，真正的注册过程发生在Layer成为running状态的时候，请查看Layer::onEnter和Layer::registerWithTouchDispatcher).

2. 为什么是ccTouchesBegan等函数得到调用？ 因为它们是事件中心CCTouchDispatcher规定的事件接收接口(查看CCTouchDispatcher::touches方法可以看到对Touchable的回调过程)，它通过CCTouchDelegate来实现这一约束。

后面会有自己实现的Touchable类型例子，这里就不贴示例代码了。

## 触摸事件分发系统类图

在cocos2d-x中触摸事件分为两类：

|俗称|术语|对应的处理器|对应的触摸事件队列|Layer里为此定义的枚举类型|事件响应函数特征|
|:----|:---|:----|
|多点触摸|StandardTouch| CCStandardTouchHandler|m_pStandardHandlers|kCCTouchesAllAtOnce|ccTouchesBegan等，复数形式|
|单点触摸|TargetedTouch| CCTargetedTouchHandler|m_pTargetedHandlers|kCCTouchesOneByOne|ccTouchBegan, 单数形式|


## 分发机制

在cocos2d-x 2.x版本中，触摸事件的分发机制是这样的：

**1. 优先级不同的情况下，优先级高的代理会最先得到调度，优先级是一个整数，越小意味着优先级越高**
**2. 优先级相同的情况下，后注册的代理会先得到调度，与元素的显示层级没有关系**

这两点可以从CCTouchDispatcher的添加代理函数里得到证明：

```c++
// pHandler: 要插入到队列里的代理； 
// pArray：  现存代理队列；
void CCTouchDispatcher::forceAddHandler(CCTouchHandler *pHandler, CCArray *pArray)
{
    // 要插入到代理队列里的下标
    unsigned int u = 0;

    CCObject* pObj = NULL;
    // 遍历队列里现存的代理, 比较优先级
    CCARRAY_FOREACH(pArray, pObj)
     {
         CCTouchHandler *h = (CCTouchHandler *)pObj;
         if (h)
         {
             // 如果新代理的优先级数值比现存的大，那么插入的下标会往后递增.
             // (数值越大优先级越低, 也就是说优先级越低，那么下标越往后递增)
             // 这里是 <, 而不是 <=, 因此碰到相同优先级的代理，小标不在递增，所以说相同优先级的，后来者，插在前面.
             if (h->getPriority() < pHandler->getPriority())
             {
                 ++u;
             }
 
             if (h->getDelegate() == pHandler->getDelegate())
             {
                 CCAssert(0, "");
                 return;
             }
         }
     }

    // 把新代理插入到下标u处.
    pArray->insertObject(pHandler, u);
}
```

再来看代理的分发过程：

```c++
void CCTouchDispatcher::touches(CCSet *pTouches, CCEvent *pEvent, unsigned int uIndex)
{
    // ... 此处省略一些代码

    // 以单点触摸事件的分发为例
    CCTargetedTouchHandler *pHandler = NULL;
    CCObject* pObj = NULL;

    // 线性顺序遍历代理队列
    CCARRAY_FOREACH(m_pTargetedHandlers, pObj)
    {
        pHandler = (CCTargetedTouchHandler *)(pObj);

        if (! pHandler)
        {
            break;
        }

        bool bClaimed = false;
        if (uIndex == CCTOUCHBEGAN)
        {
            bClaimed = pHandler->getDelegate()->ccTouchBegan(pTouch, pEvent);

            if (bClaimed)
            {
                pHandler->getClaimedTouches()->addObject(pTouch);
            }
        } else
            if (pHandler->getClaimedTouches()->containsObject(pTouch))
            {
                // moved ended canceled
                bClaimed = true;

                switch (sHelper.m_type)
                {
                    case CCTOUCHMOVED:
                        pHandler->getDelegate()->ccTouchMoved(pTouch, pEvent);
                        break;
                    case CCTOUCHENDED:
                        pHandler->getDelegate()->ccTouchEnded(pTouch, pEvent);
                        pHandler->getClaimedTouches()->removeObject(pTouch);
                        break;
                    case CCTOUCHCANCELLED:
                        pHandler->getDelegate()->ccTouchCancelled(pTouch, pEvent);
                        pHandler->getClaimedTouches()->removeObject(pTouch);
                        break;
                }
            }
    }
    // ... 此处省略一些代码
}
```

从上面的添加代理，按下标顺序添加；以及分发事件时，按照下标递增的线性顺序分发，不难推导出上面的两条结论.


            cocos2d-x中触摸事件的分发是由CCTouchDispatcher来负责的，它是一个单例类可通过CCDirector来获得其指针。

            在cocos2d-x 2.x中，触摸事件的分发机制有个“潜规则”：相同优先级的情况下，先添加的代理会先被调度。而不是按照在界面上的层级（zorder)由上到下的顺序来分发。



