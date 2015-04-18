---
layout: post
title: Learning Cocos From Samples
---
{{page.title}}

##UI Components
- TableView
*ask*
拖动TableView(Scrollview)上的菜单不会滚动的问题
*answer*
customize menu control and override registerWithTouchDispatcher(), set priority to 1 instead of default 0.

