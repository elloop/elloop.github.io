---
layout: post
title: "【cocos2d-x 学习与应用总结】最近一段时间使用cocos2d-x lua的总结"
category: [cocos2d-x]
tags: [cocos2d-x, game]
published: true
description: ""
---

# 前言

本文总结了近期使用cocos2d-x lua过程中的一些思考和收获。


## 1. lua里的的"双向继承"与传统的面向对象的单向继承的区别

问题引入：

在使用lua开发的时候，不知你有没有写过像下面这样的代码：

**Parent.lua**

{% highlight lua %}
local Parent = class("Parent")

function Parent:ctor()
    self:addChild(cc.Node:create())
end

return Parent
{% endhighlight %}

Parent是一个普通的class，它没有继承任何父类，并且自己也仅有一个ctor()方法，我却在它的ctor()函数里调用了Node类的addChild方法

在c++里，这可以肯定编译不会通过，Parent自己和其虚表里都不会有这个addChild方法，甚至虚表都可能没有。

但是在lua里，我如果像下面这样：

<!--more-->

**Child.lua**

{% highlight lua %}
local Child = class("Child", require("Parent"), function() return display.newLayer() end)
return Child
{% endhighlight %}

定义了一个class叫Child, 继承了上文的Parent, 并且指定了一个实例创建函数，使得Child被create之后即是一个Layer

定义了Child之后，像下面写代码来使用Child，Parent的ctor方法就不会报错:

{% highlight lua %}
local c = Child:create()
{% endhighlight %}

Child:create()会调用Child的ctor，因为其自身并未定义，因此会去调用Parent的ctor （原因请参见cocos2d-x lua的functions.lua里面的class方法）

Parent成功执行了ctor，并且通过调用self:addChild(cc.Node:create())为Layer添加了一个空白Node。

<font color="red">这里对addChild的调用就是lua里“面向对象”的与众不同之处，addChild其实是子类Child的方法，</font>

<font color="red">在Parent被Child继承之前，Parent:ctor里面的addChild就是undefined，</font>

<font color="red">Parent被Child继承之后，Parent里的addChild就是ok的了，看起来就像是Parent继承了Child一样，这就是我所说的"双向继承。"</font>

lua 玩的溜的同学可能一眼就能看出，这个现象其实就是lua使用`__index`和metatable来模拟面向对象带来的副作用。lua里这种可以"自作主张的面向对象方式"有利有弊，好在提高了编码的灵活性，坏在乱用之后会产生上面这种"双向继承"的滑稽场面，可读性变差。

(我不是闲的蛋疼要这么写lua，这是实际项目中的发现。当项目代码结构变的复杂，谁敢保证不会失足呢)

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

