---
layout: post
title: "Cocos2d-x 常见问题及解决方案"
category: [cocos2d-x]
tags: [cocos2d-x]
description: "cocos2d-x学习"
---

## 总论

**Q1**: cocos开发中，需要考虑哪些方面的问题？

**A1**:

- 资源预加载，时机

## 界面渲染

**1**: removeAllChildren()和removeAllChildrenWithCleanup(bool)有何区别？

**A**: removeAllChildren() == removeAllChildrenWithCleanup(true).


**2.  帧循环过程及同步、异步调用何时何地发生**

比如，我对一个子节点调用一个函数f(), 在f内，让子节点runAction(ScaleTo(0.1, 1.2)), 紧接着在调用f()下面的代码里设置子节点的缩放到1.5, 那么最后的缩放会是多大？1.2 还是1.5, runAction的动作执行一定是在f()调用发生后那段代码之后执行吗？它是在下一帧才开始执行scaleto动作吗？


**A:** 


