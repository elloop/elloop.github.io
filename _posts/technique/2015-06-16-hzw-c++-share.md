---
layout: post
title: Hzw Share 2
published: false
category: c++
tags: [c++, programming]
description: "technique conference"
---

#《海贼王项目组技术会议》-编程修养及c++基础回顾
---

|时间|内容|主讲人|
|:---|:-----:|------:|
|2015年6月16日|海贼客户端c++技术分享|季宝鹏|


#如何衡量编程能力 - 编程能力计算公式
##编程能力=

$$\sum_1^n(codeAmount_i\times difficulty_i) + \sum_1^n(sourceCode_i\times difficulty_i) + \sum_1^n(book_i\times difficulty_i)$$

##三个方向平衡发展: 写的多了遇到瓶颈，要反思看别人的代码来提升。同时要看书，看懂，会用。
- 写代码，多反思，不要只是拷贝粘贴，注意代码风格、重构。
- 看代码：好的源码，比如lua源码、一些国内外大牛的代码（云风、google、facebook开源项目等等），一些参考链接：
    - [云风的后端框架](https://github.com/cloudwu/skynet)
    - [google protobuf 源码](https://github.com/google/protobuf)
    - [facebook folly](https://github.com/facebook/folly)
    - [notepad++ 源码](https://github.com/notepad-plus-plus/notepad-plus-plus)
    在github上搜c++关键字，按照star数排序，star多的一般都是牛逼的代码。
- 看书：侯捷翻译的一些c++经典教材、《重构》、《设计模式》、《算法导论》多写练，多思考。

#c++基础巩固
从《Effective c++》摘取常用的几条：
## 尽量用const/inline 代替\#define
避免这样的宏造成的副作用

{% highlight c++ %}
#define max(a,b) ((a) > (b) ? (a) : (b))
int a = 5, b = 0;
max(++a, b); // a 的值增加了2 次
max(++a, b+10); // a 的值只增加了1 次
{% endhighlight %}

## 尽量用<iostream>而不用<stdio.h>
scanf,printf他们不是类型安全的，而且没有扩展

## 确保对象、变量使用前已经初始化

## 尽量用new和delete, 而不用malloc和free
- 和项目中其它代码不一致
- new delete 会调构造析构, malloc free不会调构造析构

## new delete 使用相同形式

{% highlight c++ %}
int * a = new int(10);  // 确保变量使用前初始化
delete a;

int * ary = new int[10];
delete [] ary;
{% endhighlight %}

## Item45: 弄清楚C++在幕后为你所写、所调用的函数

{% highlight c++ %}
class Empty {

};

等价于：

class Empty {
public:
    Empty() {}                      // 默认构造函数
    Empty(const Empty& other) {}    // copy构造函数
    ~Empty() {}                     // 析构函数

    Empty& operator = (const Empty& other) { return this; } // 赋值操作符
    Empty* operator&() { return this; }             // 取址运算符
    const Empty* operator&() const { return this; }

};
{% endhighlight %}

## 管理好你的内存
- 野指针
使用已经被释放内存的指针去做事情，这是大部分程序崩溃的主要原因。
拿项目中的例子来说：

{% highlight c++ %}
class A :  public CCBContainer::CCBContainerListener {
    CCBContainer * mAniCcb;
public:
    A() {
        mAniCcb = CCBContainer::create();
		mAniCcb->loadCcbiFile("ChoicePic1");
		mAniCcb->setListener(this);
        mInstruction->addChild(mAniCcb);
    }
    virtual void onAnimationDone(const std::string& animationName) {
        OtherClass::Get()->next();
    } 
};

class OtherClass {
public:

    ...

    void next() {
        mInstruction->removeAllChildren();      // mAniCcb 被release掉了
    }
};

class CCBContainer {
public:

    ...

    void _animationDone()
    {
        onAnimationDone(mActionManager->getLastCompletedSequenceName());
        if (mCCBContainerListener)
        {
            // 调A::onAnimationDone(...) -> OtherClass::next() -> mAniCcb released.
            mCCBContainerListener->onAnimationDone(mActionManager->getLastCompletedSequenceName());

            // 再次使用mAniCcb的mCCBTag变量，mAniCcb已经被释放，其成员mCCBTag已经不可用，此处崩溃!
            mCCBContainerListener->onAnimationDone(mActionManager->getLastCompletedSequenceName(), this, mCCBTag);
        }
    }
};

调用方式：
A * a = new A();
a->runAnimation("timeline")
{% endhighlight %}

- 内存泄露
*container为类的成员变量的时候，则要retain，析构函数里release.*
上面的例子就是犯了这错误造成的：
    - mAniCcb 是A的成员变量，因此构造函数里应该retain, 析构函数里release.

## 避免返回内部数据的句柄
- 容易造成对象内部数据的破坏，比如部分数据失效，这种问题不好查
- 无解的问题

{% highlight c++ %}
class A {
public:
    // 定义一个函数f，它可以修改a指向的内容，但不能修改a。
    int * f1() { return a;}   // 不行
    int&  f2() { return *a; } // 最为接近，但是避免不了用取地址符&，并释放掉a的内存
private:
    int *a;
};
{% endhighlight %}

## 避免使用临时对象的引用或地址
- 参见下面的`杂项讨论`部分的问题3.

## 区分何时需要深Copy
- 深Copy就是内存拷贝, 要为需要动态分配内存的类声明一个拷贝构造函数和赋值操作符，在其中实现内存copy. 重新读Primer和effective c++.

## 杂项讨论
- 问题1：为何拷贝构造函数的参数不能使用对象，而需要使用引用?

{% highlight c++ %}
class A {
public:
    A(A other);
};

int main() {
    A a1;
    A a2(a1);
}
A a2(a1)这句会导致stack overflow.
原因：无穷递归调用A(A other)这个copy构造函数。
分析：函数调用首先要传参，把实参a1传给copy构造函数的other形参，很明显，这一步涉及到对象的copy，即这一步本身需要调用A(A other), 这样就已经形成了自身调用，将永远不能调完。
{% endhighlight %}

- 问题2：下面的代码为何会崩溃, operator=()的写法是否存在问题？

{% highlight c++ %}
class A {
public:
    A() : a_(new int(0)) { }
    ~A() { delete a_; }
    A& operator = (const A& other) {
        _a = other.a_;
        return *this;
    }
private:
    int * a_;
};

void f() {
    const A a1;
    const A a2;
    a2 = a1;
}

int main() {
    f();
}
{% endhighlight %}

- 问题3：下面的代码能通过编译吗，存在风险吗？

{% highlight c++ %}
class A {
public:
    A(string s) : s_(s) {}
private:
    string& s_;
    const int i_;
};
{% endhighlight %}


