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

本文回顾了cocos2d-x 2.x中触摸事件的使用方法和注意事项，侧重于单点触摸事件。

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
    // 单点触摸, 第一个参数是Touchable， 第二个整数代表优先级(数字越小优先级越高)， 第三个参数表示是否吞噬触摸事件
    touchDispatcher->addTargetedDelegate(Touchable::create(), 0, true);
    // 多点触摸, 第一个参数是Touchable， 第二个参数是优先级
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

在刚才描述的触摸事件分发过程中，开发者可见的类有：事件分发中心CCTouchDispatcher, 触摸响应代理CCTouchDelegate

要响应触摸事件就继承CCTouchDelegate, 并且在CCTouchDispatcher中注册自己即可。

其实，在触摸事件分发过程中还有一个类很关键，它对逻辑开发者是透明的，它负责触摸事件优先级和是否吞噬事件的控制。它就是`CCTouchHandler`. 它有两个子类，分别是负责处理标准多点触摸的handler：`CCStandardTouchHandler`和单点触摸handler：`CCTargetedTouchHandler`.

CCTouchHandler就像一个适配器，它内部含有一个Touchable, 同时添加了优先级和触摸吞噬控制的功能。

下面的类图给出了触摸事件分发过程中三个主要类之间的关系:

![触摸事件类图](http://7xi3zl.com1.z0.glb.clouddn.com/CCTouch3.png)

这个过程的重点是CCTouchDispatcher, 它的内部保存两个触摸处理器队列，一个m_pStandardHandlers保存所有注册来的标准触摸处理器；另一个m_pTargetedHandlers保存单点触摸处理器。

CCTouchDispatcher通过遍历两个处理器队列来实现触摸事件分发，通过每个处理器的handler->getDelegate()来取得Touchable(CCTouchDelegate)对象，进而调用ccTouchesBegan等函数。

## 分发机制

在cocos2d-x 2.x版本中，触摸事件的分发机制是这样的：

**1. 优先级不同的情况下，优先级高的代理会最先得到调度，优先级是一个整数，越小意味着优先级越高**
**2. 优先级相同的情况下，后注册的代理会先得到调度，与元素的显示层级没有关系**

这两点可以从CCTouchDispatcher的添加代理函数里得到证明：

来看一下触摸代理的分发过程：

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

从上面这段代码可以看到，对于TargetedTouch单点触摸是按照线性顺序来遍历分发的，那么排在队列前面的自然就会先分发

再看一下处理器是怎么排队的：

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

可以看到优先级高的会排在前面，优先级相同的，后来者会排在前面。因此，不难总结出上面提到的两条结论。

## 陷阱！！你以为你小我就摸不到你？

请看下面一个小例子，看看它的结果会让你吃惊吗？

**HelloWorldScene.h: **

```c++
#ifndef __HELLOWORLD_SCENE_H__
#define __HELLOWORLD_SCENE_H__

#include "cocos2d.h"

class HelloWorld : public cocos2d::CCLayer
{
public:
    virtual bool init();  
    static cocos2d::CCScene* scene();
    CREATE_FUNC(HelloWorld);
};

// 定义一个Touchable类型，它继承了彩色layer类，方便演示效果。彩色layer是Layer的子类，因此彩色layer本身也是Touchable的
class TouchableLayer : public cocos2d::CCLayerColor
{
public:
    static TouchableLayer* create();
    bool init();

    bool ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent) override ;
    void ccTouchMoved(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent) override {}
    void ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent) override {}
    void ccTouchCancelled(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent) override {}
};

#endif // __HELLOWORLD_SCENE_H__
```

头文件很简单，在HelloWorldScene下面加了一个TouchableLayer类，用来接收触摸事件. 下面是实现文件：

**HelloWorldScene.cpp: **

```c++
#include "HelloWorldScene.h"

USING_NS_CC;

CCScene* HelloWorld::scene()
{
    CCScene *scene = CCScene::create();
    HelloWorld *layer = HelloWorld::create();
    scene->addChild(layer);
    return scene;
}

bool HelloWorld::init()
{
    if (!CCLayer::init())
    {
        return false;
    }

    // 添加TouchableLayer对象到父Layer。注意：这里仅开启了子layer的touch响应，父Layer并没有开启触摸.
    TouchableLayer  *layer = TouchableLayer::create();
    layer->setTouchEnabled(true);
    layer->setTouchMode(kCCTouchesOneByOne);    // 单点触摸
    addChild(layer);

    return true;
}

TouchableLayer* TouchableLayer::create()
{
    auto self = new TouchableLayer();

    if (self && self->init())
    {
        self->autorelease();
        return self;
    }

    return nullptr;
}

bool TouchableLayer::init()
{
    // 初始化为一个大小为: 100 x 100 的红色不透明layer.
    return (CCLayerColor::initWithColor(ccc4(255, 0, 0, 255), 100, 100));
}

// 为了演示简单，仅重写了touchBegan方法，让红色方块原地旋转360度
bool TouchableLayer::ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{
    auto rotate = CCRotateBy::create(0.5, 360);
    runAction(rotate);
    return false;
}
```

接下来运行代码， 效果如下图所示：

![TouchableLayer](http://7xi3zl.com1.z0.glb.clouddn.com/TouchableLayer.png)

现在请考虑: 

1. 点击红色方块，它会旋转吗？

2. 点击屏幕右半部分的黑色区域，红色方块会旋转吗?

第一个问题，相信大家都能答对，它会旋转，因为开启了触摸。

第二个问题呢，我们知道TouchableLayer的contentSize是100 x 100, 那么点击右半部分，肯定已经超出了contentSize, 也就是点击在了TouchableLayer的外面，它还会响应吗？

![ClickInRed](http://7xi3zl.com1.z0.glb.clouddn.com/ClickInRed.gif)

![ClickInBlack](http://7xi3zl.com1.z0.glb.clouddn.com/ClickInBlack.gif)

看效果图，答案是还会旋转！这可能有些出乎我们的预料，因为刚接触触摸事件，很容易把这个小红方块看成一个GUI概念里的按钮，我点在它的外面，它怎么还会响应呢？我刚接触这个地方的时候也很差异，但是你要知道，cocos是个游戏引擎，并不是GUI框架，它主要关心图形的绘制渲染，比GUI框架更加“底层化”，如果要实现一个GUI按钮的效果，那也需要你自己来处理触摸事件，判断点击范围，就是需要自己包装出来一个按钮出来。看看CCMenu对触摸事件的处理你就会明白这一过程了。

总结一下，这个例子要说的就是:

<font color="red">触摸事件的响应是和Touchable对象的大小没关系的</font>，哪怕你只是一个像素点，只要你注册了触摸事件，那么我点击屏幕的任何位置你都会收到响应。(前提是这个触摸事件没有被高优先级处理器吞噬掉)

## 触摸综合实例 

下面的小实例，演示了如何自定义响应触摸事件的类、触摸事件的分发顺序、单点触摸事件的吞噬.  

![TouchTestPage](http://7xi3zl.com1.z0.glb.clouddn.com/TouchTestPage_副本.png)

如图所示，一个父Layer中包含了1个小的彩色方块layer，和3只狗狗。(上面两个按钮分别是回测试主页和退出)

Layer和三只狗都注册了触摸事件，注册的时间先后顺序是dog1, dog2, dog3, Layer. 其中dog1, dog2, dog3是从左至右的顺序编号的。

这四个触摸代理注册的优先级只有dog1是-1，拥有最高优先级，dog2, dog3, Layer都是0. 4个代理都指定了swallow为true, 也就是说如果有一个代理处理了一个触摸事件，那么其它优先级低的代理就不会收到这个触摸事件

按照上文所述的事件分发机制(优先级高的在前，相同优先级后注册的在前)可以知道, 它们4个的触摸响应顺序会是： dog1 > Layer > dog3 > dog2

例子中的触摸代码逻辑是，如果触摸点在对应物体内部那么就处理该事件，否则不处理，即在ccTouchBegan()里面返回false.

- 彩色方块：

    - 点击在内部，并拖拽，会跟随鼠标移动, 且ccTouchBegan中返回true，吞噬掉该事件。

    - 点击在外部，没反应。不吞噬

- 3只狗：

    - 点击在其内部，会旋转90度，并在ccTouchBegan中返回true，代表处理了该事件，吞噬掉。

    - 否则，点击在外部, 收到touchBegan的消息时，会进行抖动，并在ccTouchBegan里返回false，代表不处理该事件，也不会吞噬。


**操作1：触摸空白处**

![TouchLayer](http://7xi3zl.com1.z0.glb.clouddn.com/TouchEmpty.gif)

没有点在任何一只狗内，也没有触摸在彩色方块内，因此事件一直向下转发，三只狗均触发touch，发生抖动.

**操作2：触摸dog1**

![Touchdog1](http://7xi3zl.com1.z0.glb.clouddn.com/touchdog1.gif)

触摸在dog1， dog1旋转并吞噬事件，其它2只狗没触发touch.

**操作3：触摸彩色方块**

![Touchcolor](http://7xi3zl.com1.z0.glb.clouddn.com/touchlayer.gif)

根据优先级，dog1先触发事件发生抖动且不吞噬，接着彩色方块触发触摸可以拖动，同时吞噬触摸，dog2, dog3没有触发touch

**操作4：触摸dog3**

![Touchdog3](http://7xi3zl.com1.z0.glb.clouddn.com/touchdog3.gif)

dog1优先级最高总是被触发发生抖动且不吞噬，dog3触发在内部，旋转且吞噬触摸, dog2没有触发touch


**操作5：触摸dog2**

![Touchdog2](http://7xi3zl.com1.z0.glb.clouddn.com/touchdog2.gif)

dog1优先级最高总是被触发发生抖动且不吞噬，dog3触发并抖动不吞噬，dog2触发touch, 旋转，吞噬。

**操作6：把彩色方块放在dog1下面，并拖拽**

![dragdog1](http://7xi3zl.com1.z0.glb.clouddn.com/dragdog1.gif)

因为触摸点在dog1内部，所以被dog1优先截获触摸并吞噬。彩色方块无法拖拽。dog2, dog3也不会触发touch.

**操作6：把彩色方块放在dog2和dog3下面，并拖拽**

![dragdog2_3](http://7xi3zl.com1.z0.glb.clouddn.com/dragdog2_3.gif)

彩色方块的优先级 > dog3 > dog2, 所以虽然彩色方块显示在dog2和dog3的下面，但是触摸响应是优先于2只狗的，因此可以实现拖拽，且吞噬了触摸事件，dog2和dog3既不会旋转也不会抖动。同时能看到dog1还是能够触发touch，因为它的优先级是最高的

触摸代理的优先级，是可以通过`CCTouchDispatcher的setPriority(int nPriority, CCTouchDelegate *pDelegate)`接口来动态改变的, 在`CCMenu::setHandlerPriority(int newPriority)`函数里能看到setPriority使用.

下面是代码的实现

**TouchTestPage.h**:

```c++
#ifndef CPP_DEMO_PAGES_MENU_PAGE_H
#define CPP_DEMO_PAGES_MENU_PAGE_H

// 忽略不认识的包含文件, 是Demo框架里的东西
#include "cocos2d.h"
#include "pages/SuperPage.h"
#include "pages/RootPage.h"
#include "util/StateMachine.h"
#include "LogicDirector.h"
#include "message/Message.h"

// 父Layer
class TouchTestPage 
    : public SuperPage
    , public State<RootPage>
    , public cocos2d::CCTouchDelegate
{
public:
    CREATE_FUNC(TouchTestPage);

    void loadUI() override;
    void unloadUI() override;

    void onEnterState() override;
    void onExecuteState() override;
    void onExitState() override;

    virtual bool ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
    virtual void ccTouchMoved(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
    virtual void ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
    virtual void ccTouchCancelled(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
protected:
    TouchTestPage();
    ~TouchTestPage();

private:
    bool                isTouchingColorLayer_;
    cocos2d::CCPoint    touchBeginPoint_;
};

// 狗狗类，它是Touchable, 同时也是精灵
class Dog : public cocos2d::CCTouchDelegate, public cocos2d::CCSprite
{
public:
    static Dog* create(const char *name);
    bool initWithString(const char *name);
    cocos2d::CCRect rect() const;

    virtual bool ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
    virtual void ccTouchMoved(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
    virtual void ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
    virtual void ccTouchCancelled(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent);
protected:
    Dog();
    ~Dog();
};
#endif
```

**TouchTestPage.cpp**:

```c++
#include "pages/TouchTestPage.h"
#include "PageManager.h"
#include "util/StringUtil.h"

USING_NS_CC;

bool touchTestPageRegistered = PageManager::getInstance()->registerPage(
    "TouchTestPage", TouchTestPage::create());

void TouchTestPage::loadUI()
{
    // 父Layer开启touch，它注册到CCTouchDispatcher是在loadUI执行完毕，因此父Layer的注册顺序是最后一个.
    setTouchEnabled(true);
    setTouchMode(kCCTouchesOneByOne);

    auto winSize = CocosWindow::size();
    auto origin = CocosWindow::origin();

    CCSize colorLayerSize(winSize.width / 4, winSize.height / 4);
    auto colorLayer = CCLayerColor::create(CocosUtil::randomC4b());
    colorLayer->setContentSize(colorLayerSize);
    colorLayer->setPosition(CocosWindow::center() -
                            CCPoint(colorLayerSize.width / 2, colorLayerSize.height / 2));
    ADD_CHILD(colorLayer);

    // 从左到右，三只狗
    for ( int i = 1; i < 4; ++i )
    {
        auto dog = Dog::create("DemoIcon/dog_160.png");
        CCAssert(dog, "");
        dog->setTag(i);
        auto dogSize = dog->getContentSize();
        dog->setPosition(origin +
                         CCPoint(dogSize.width / 2 + ( i - 1 ) * dogSize.width, dogSize.height / 2));

        CocosUtil::markCorners(dog);
        // dog1, dog2, dog3.
        addChild(dog, "dog" + StringUtil::toString(i));
    }

    // 注册三只狗狗的触摸事件，注意，三者均响应单点触摸，优先级分别为为-1, 0, 0, 均吞噬触摸
    auto touchDispatcher = CCDirector::sharedDirector()->getTouchDispatcher();
    touchDispatcher->addTargetedDelegate(getChild<Dog>("dog1"), -1, true);
    touchDispatcher->addTargetedDelegate(getChild<Dog>("dog2"), 0, true);
    touchDispatcher->addTargetedDelegate(getChild<Dog>("dog3"), 0, true);
}

void TouchTestPage::unloadUI()
{
    // 移除触摸监听
    auto touchDispatcher = CCDirector::sharedDirector()->getTouchDispatcher();
    touchDispatcher->removeDelegate(getChild<Dog>("dog1"));
    touchDispatcher->removeDelegate(getChild<Dog>("dog2"));
    touchDispatcher->removeDelegate(getChild<Dog>("dog3"));

    removeAllChildren();
}

void TouchTestPage::onEnterState()
{
    loadUI();
}

void TouchTestPage::onExecuteState()
{}

void TouchTestPage::onExitState()
{
    unloadUI();
}

TouchTestPage::TouchTestPage()
: isTouchingColorLayer_(false)
, touchBeginPoint_(CCPointZero)
{}

TouchTestPage::~TouchTestPage()
{}

// 父Layer的触摸响应函数
bool TouchTestPage::ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{
    auto pos = pTouch->getLocation();
    CCLOG("(%.2f, %.2f)", pos.x, pos.y);
    auto colorLayer = getChild<CCLayerColor>("colorLayer");
    if ( colorLayer )
    {
        auto posInLayer = colorLayer->convertToNodeSpace(pos) * colorLayer->getScale();
        CCLOG("in color layer: (%.2f, %.2f)", posInLayer.x, posInLayer.y);

        // 判断是否点击在彩色方块内部，如果在内部就吞噬触摸
        CCRect rect;
        rect.origin = CCPointZero;
        rect.size = colorLayer->getContentSize();
        if ( rect.containsPoint(posInLayer) )
        {
            touchBeginPoint_ = pTouch->getLocation();
            isTouchingColorLayer_ = true;
            CCLOG("touch swallowed by color layer");
            return true;    // 吞噬掉触摸事件，比父Layer优先级低的dog3， dog2将不会触发此次触摸
        }
    }
    return false;
}

void TouchTestPage::ccTouchMoved(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{
    if ( isTouchingColorLayer_ )
    {
        auto colorLayer = getChild<CCLayerColor>("colorLayer");
        if ( colorLayer )
        {
            auto posDiff = pTouch->getLocation() - pTouch->getPreviousLocation();
            colorLayer->setPosition(colorLayer->getPosition() + posDiff);
        }
    }
}

void TouchTestPage::ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{
    isTouchingColorLayer_ = false;
}

void TouchTestPage::ccTouchCancelled(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{
    isTouchingColorLayer_ = false;
}

//----------------------------------- Dog Imp ---------------------------------
Dog::~Dog()
{}

Dog::Dog()
{}

Dog* Dog::create(const char *name)
{
    auto self = new Dog();
    if ( self && self->initWithString(name) )
    {
        self->autorelease();
        return self;
    }
    CC_SAFE_DELETE(self);
    return nullptr;
}

bool Dog::initWithString(const char *name)
{
    if ( CCSprite::initWithFile(name) )
    {
        return true;
    }
    return false;
}

cocos2d::CCRect Dog::rect() const
{
    CCRect rect;
    rect.origin = CCPointZero;
    rect.size = getContentSize();
    return rect;
}

// 狗狗的触摸响应函数
bool Dog::ccTouchBegan(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{
    auto pos = pTouch->getLocation();
    CCLOG("(%.2f, %.2f)", pos.x, pos.y);
    CCLOG("in dog%d: (%.2f, %.2f)\n", getTag(),
          convertToNodeSpace(pos).x * getScaleX(), getScaleY()*convertToNodeSpace(pos).y);

    // 判断是否点在狗狗内部, 是，则旋转狗狗，同时吞噬本次触摸
    if ( rect().containsPoint(convertToNodeSpace(pos)) )
    {
        auto act = CCRotateBy::create(0.5, 90);
        runAction(act);
        CCLOG("touch swallowed by dog%d\n", getTag());
        return true;
    }
    else
    {
        // 不是点在内部，仅仅旋转狗狗
        auto shake = CCShaky3D::create(0.5, CCSize(20, 20), 5, false);
        runAction(shake);
    }
    return false;
}

void Dog::ccTouchMoved(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{}

void Dog::ccTouchEnded(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{}

void Dog::ccTouchCancelled(cocos2d::CCTouch *pTouch, cocos2d::CCEvent *pEvent)
{}
```

注意：

- 对某一个代理来说，比如dog1：

    - ccTouchBegan() { return true;} 表示dog1对此次触摸感兴趣，会继续监听touchMoved, touchEnded等，即会继续回调到ccTouchMoved等. 

    - ccTouchBegan() {return false;} 表示dog1对此次触摸不感兴趣， 不会继续回调到ccTouchMoved等函数。

- 对不同代理之间来说，比如dog1和dog3：

    - 如果dog1在CCTouchDispatcher::addTargetedDelegate(...)里面指定了，swallow为true，且在dog1的ccTouchBegan返回了true，那么这个触摸事件就会被dog1吞噬掉，dog3及比dog3更低优先级的代理都不会收到触摸事件。

    - 否则，如果dog1在addTargetedDelegate()没有指定swallow为true， 或者在ccTouchBegan里返回了false，那么触摸事件就会继续像下分发到dog3.


## 点击会变大的菜单按钮

点击缩放功能的菜单按钮放在下一篇说吧，这一篇已经很长了。

## 总结

本文回顾了cocos中单点触摸的用法和触摸事件分发机制、优先级控制等内容. 关于多点触摸没怎么用，后面用了再总结。

在触摸事件当中，还有一些其他常见问题，比如如何定制自己的Menu实现点击缩放节省美术资源、点击穿透问题、如何在拖拽Scrollview上的按钮时候也能让Scrollview滚动等。这些问题将会在后面的文章中总结。

## source codes

**源代码仓库地址: [cocos2d-x-cpp-demos-2.x](https://github.com/elloop/cocos2d-x-cpp-demos-2.x/blob/master/Classes/pages/TouchTestPage.cpp), 是本人写的一个小型Demo框架，方便添加测试代码或者用来开发游戏，如果觉得有用请帮忙点个Star，谢谢**

---------------------------
**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**欢迎访问[CSDN博客](http://blog.csdn.net/elloop)，与本站同步更新**

