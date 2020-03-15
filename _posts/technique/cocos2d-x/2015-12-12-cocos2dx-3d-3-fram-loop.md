---
layout: post
title: "【cocos2d-x 3D游戏开发】3: 游戏帧循环"
highlighter_style: solarizeddark
category: [cocos2d-x]
tags: [cocos2d-x, game]
description: ""
published: true
---

## 前言

高实时性是游戏区别于传统软件、应用的一个重要特征，游戏里通常有一个比较高频率的循环在处理用户输入、物理逻辑更新、业务逻辑更新以及图形渲染等工作, 以保证这种实时性的要求。我们把每一次循环叫做一帧，把每秒钟游戏更新的帧数称作“帧率(Frame Per Second)”, 也就是常说的FPS。电影的帧率通常是24FPS，cocos2d-x默认的帧率是60FPS, VR游戏中对帧率的要求则更高,通常至少要达到70~80FPS. cocos在默认情况下，每秒会进行60次游戏循环。本文将对cocos2d-x引擎中每一帧里面做了哪些事情进行介绍，总结每一帧中的几个关键操作，及它们在时间上的先后顺序。以win32环境为例，讲解一个游戏的主循环的控制流程。

<!--more-->
## <font color="red">窗口的创建及OpenGL初始化</font>

### <font color="blue">in 2.X (2.2.3)</font>

在win32平台上的cocos游戏其实就是一个win32窗口程序，跟其他应用程序一样，游戏的启动点也是在main函数里，所以要从main.cpp为起点，查看游戏的启动过程：

{% highlight c++ %}
int APIENTRY _tWinMain(HINSTANCE hInstance,
                       HINSTANCE hPrevInstance,
                       LPTSTR    lpCmdLine,
                       int       nCmdShow)
{
    UNREFERENCED_PARAMETER(hPrevInstance);
    UNREFERENCED_PARAMETER(lpCmdLine);

    // 创建一个CCApplication(子类)对象app
    AppDelegate app;

    // 创建windows窗口，在窗口的创建过程中会初始化OpenGL.
    CCEGLView* eglView = CCEGLView::sharedOpenGLView();
    eglView->setViewName("hello");
    eglView->setFrameSize(480, 320);
    
    // 调用app的run方法，启动游戏循环
    return CCApplication::sharedApplication()->run();
}
{% endhighlight %}

- AppDelegate app

这一行代码，创建了游戏中唯一的一个CCApplication单例，这个单例声明的是CCApplication*类型，但是绑定到的是子类Appdelegate app这个对象，是典型的“声明父类，new子类”的多态方式，可以从CCApplication的构造函数看到这一过程：

{% highlight c++ %}
// sharedApplication pointer    一个父类对象的指针 CCApplication*
CCApplication * CCApplication::sm_pSharedApplication = 0;

CCApplication::CCApplication()
: m_hInstance(NULL)
, m_hAccelTable(NULL)
{
    m_hInstance    = GetModuleHandle(NULL);
    m_nAnimationInterval.QuadPart = 0;
    CC_ASSERT(! sm_pSharedApplication);
    // 在构造的时候，单例指针指向了this, 
    // 由于代码里只是显示创建了Appdelegate app这个对象，而没有创建CCApplication类型的对象，因此这个this其实是在创建子类对象的地址
    // 相当于这样写，CCApplication * app = new Appdelegate();
    sm_pSharedApplication = this;           
}
{% endhighlight %}

所以游戏中唯一的CCApplication对象是其子类Appdelegate类型的. 对其虚函数的调用也都将在运行时绑定到对Appdelegate方法的调用.

- CCEGLView的创建

如果你写过win32窗口程序的话，CCEGLView这个类的结构你就会一目了然，它创建了一个windows窗口(CCEGLView::Create方法)，并在其窗口过程函数中(CCEGLView::WindowProc)处理鼠标、键盘等操作，以完成触摸模拟等事件。同时，它作为游戏的窗口部分，负责OpenGL相关的操作: 初始化, 销毁OpenGL(CCEGLView::initGL, CCEGLView::destroyGL), 交换缓冲区swapBuffers, 设置openGL视口setViewPortInPoints, 设置OpenGL裁减setScissorInPoints, 以及对缩放因子和屏幕分辨率的设置.

其中对OpenGL的功能用到了: **1. wgl API**: windows系统上的OpenGL与窗口系统之间的API接口**; **2. glew**: OpenGL扩展功能检测库，glew提供了一种高效的运行时机制来判断目标平台是否支持某些OpenGL扩展功能**

- 游戏启动，显示窗口, CCApplication::sharedApplication()->run()

游戏窗口的展示以及消息循环是在CCApplication的run函数里面：

{% highlight c++ %}
int CCApplication::run()
{
    PVRFrameEnableControlWindow(false);

    // Main message loop:
    MSG msg;
    LARGE_INTEGER nFreq;
    LARGE_INTEGER nLast;
    LARGE_INTEGER nNow;

    QueryPerformanceFrequency(&nFreq);
    QueryPerformanceCounter(&nLast);

    // Initialize instance and cocos2d.
    if (!applicationDidFinishLaunching())    // Appdelegate::applicationDidFinishLaunching
    {
        return 0;
    }

    CCEGLView* pMainWnd = CCEGLView::sharedOpenGLView();
    pMainWnd->centerWindow();
    ShowWindow(pMainWnd->getHWnd(), SW_SHOW);       // 显示游戏窗口

    // 游戏循环 窗口消息循环
    while (1)
    {
        if (! PeekMessage(&msg, NULL, 0, 0, PM_REMOVE))
        {
            // Get current time tick.
            QueryPerformanceCounter(&nNow);

            // 离下一帧还有没有剩余时间，有的话就睡一会.
            if (nNow.QuadPart - nLast.QuadPart > m_nAnimationInterval.QuadPart)
            {
                nLast.QuadPart = nNow.QuadPart;
                CCDirector::sharedDirector()->mainLoop();       // 游戏里的操作在CCDirector的mainLoop方法里
            }
            else
            {
                Sleep(0);
            }
            continue;
        }

        if (WM_QUIT == msg.message)
        {
            // Quit message loop.
            break;
        }

        // Deal with windows message.
        if (! m_hAccelTable || ! TranslateAccelerator(msg.hwnd, m_hAccelTable, &msg))
        {
            TranslateMessage(&msg);
            DispatchMessage(&msg);
        }
    }

    return (int) msg.wParam;
}
{% endhighlight %}

### <font color="blue">in 3.X (3.9)</font>

// todo: add 3.x

## <font color="red">帧循环中做了什么 CCDirector::mainLoop()</font>

### <font color="blue">in 2.X (2.2.3)</font>

{% highlight c++ %}
void CCDisplayLinkDirector::mainLoop(void)
{
    if (m_bPurgeDirecotorInNextLoop)
    {
        m_bPurgeDirecotorInNextLoop = false;
        purgeDirector();                                // 游戏结束，销毁director
    }
    else if (! m_bInvalid)
     {
         drawScene();                                   // 绘制
     
         CCPoolManager::sharedPoolManager()->pop();     // 释放自动对象
     }
}
{% endhighlight %}

mainLoop里做了两件事情：1. 绘制；2.释放自动释放池里的对象

自动释放池那部分不必细说，它是在释放那些调用了autorelease()方法的CCObject对象，每一帧结束的时候都会调.

drawScene()是帧循环中的重头戏：

{% highlight c++ %}
void CCDirector::drawScene(void)
{
    calculateDeltaTime();  // 计算帧时间间隔

    if (! m_bPaused)
    {
        m_pScheduler->update(m_fDeltaTime);     // 调度器 CCScheduler的update
    }

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);     // opengl 状态重置

    if (m_pNextScene)
    {
        setNextScene();                         // 是否切换新Scene? 退出当前Scene， 显示下一Scene
    }

    kmGLPushMatrix();                           // 复制当前栈顶的模型视图矩阵MV 

    if (m_pRunningScene)
    {
        m_pRunningScene->visit();               // 绘制当前Scene
    }

    // draw the notifications node
    if (m_pNotificationNode)
    {
        m_pNotificationNode->visit();           // 绘制通知节点
    }
    
    if (m_bDisplayStats)
    {
        showStats();                            // 显示drawCall次数，FPS，SPF三个数值label
    }
    
    kmGLPopMatrix();                            // 弹出栈顶模型视图矩阵MV

    m_uTotalFrames++;

    // swap buffers
    if (m_pobOpenGLView)
    {
        m_pobOpenGLView->swapBuffers();         // 绘制完成，交换缓冲区
    }
    
    if (m_bDisplayStats)
    {
        calculateMPF();                         // 计算SPF， 即每帧消耗的时间
    }
}
{% endhighlight %}

在drawScene函数中最主要的两个部分是：

**1. CCScheduler调度器的update** : update中会涉及到动作的更新，及一些自定义scheduler的更新, 我们通常的业务逻辑就是在第二部分自定义的scheduler中完成的。动作(CCActionManager)更新具有最高的优先级，因为它在注册scheduler的时候，`m_pScheduler->scheduleUpdateForTarget(m_pActionManager, kCCPrioritySystem, false);`, 使用了kCCPrioritySystem, 它被定义为最小整数，因此也就最先被调度.


**2. m_pRunningScene->visit()** : 在处理完动作、用户逻辑之后，在当前帧，界面上的元素位置已经确定，此时，调用m_pRunningScene->visit()绘制当前的Scene，遍历这个Scene的UI树，对每个节点进行绘制. 绘制结束交换缓冲区从而完成界面渲染工作。

下面这张图总结了一帧循环中的主要工作：

![GameFrameLoop.png](http://7xi3zl.com1.z0.glb.clouddn.com/GameFrameLoop.png)


### <font color="blue">in 3.X (3.9)</font>

// todo: add 3.x.

---------------------------


**欢迎访问[github博客](http://elloop.github.io)，与本站同步更新**

