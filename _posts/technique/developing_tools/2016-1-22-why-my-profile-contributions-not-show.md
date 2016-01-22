---
layout: post
title: "为什么使用命令行工具进行的提交没有在github主页上显示出来？"
highlighter_style: monokai
category: tools
tags: [git]
description: ""
---

#前言

本文介绍了如何解决使用命令行工具进行的提交没有在github个人主页上显示出来的问题。

如果不希望听那么多废话，请直接通过目录跳转到`解决方法`部分。

# 问题描述, 为了不让你的粉丝离开你，让自己“绿起来”

经常使用github的人大概都知道，在你的个人资料主页贡献图(Your Profile Contributions)上，记录着你使用github的贡献行为。你今天有“贡献”，那么代表今天的那个小格子就会变成绿色，否则就是一个空白。下图是一个例子：

![contri_diagram.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/contri_diagram2.jpg)

<!--more-->

之前不是很关注这个活动图，我觉得自己的肯定是满满的一片绿色，因为我几乎每天都在使用github，每天都会有提交。“一片绿色”这件事情也没什么好炫耀的，因为我只写一个标点符号，然后提交并推送上去也算一个“贡献”。但是最近几天我发现，我的粉丝(Followers)在持续减少，这是咋回事？我看了一眼我的贡献图，竟然一片空白！难道是因为我“不够绿”，他们应该是以为我太懒，这么长时间都不知道做点事情，我为啥要关注你？可是我天天提交呀，在我的“public activity”里面也能看到活动记录。但是为什么主页的贡献图这里是一片空白。

![not_green.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/not_green.jpg)

我注意到，如果我在线上修改，通过github网页进行提交，那么“贡献”会立即在个人贡献图上显示出来。而我平时是在本地使用命令行工具来做提交和推送的，难道非要在它的网站上操作才可以？它是为了要提高自己网站的流量，鼓励程序猿们都到网页上操作吗？不应该呀，这种“强X”行为会得罪多少用户呀。

为了不能让本来就很少的粉丝离我而去，我决定解决一下自己“不够绿”的问题，我明明有提交呀！！

第一个办法，我在一个仓库的README最后，加上了一个签到字段，打算每天在线上去手动修改这个签到字段，比如今天上去，我会写一句，“2016-1-22 年会后的第二天，上午不用上班”，吐槽之后，在线提交。OK，今天变绿了。

这样就行了吗，作为一个程序猿，如果被别的同仁发现我这样搞，还不被嘲笑死。我们的长项是“懒”，我这么勤快怎么行。还是找找原因，从根本上解决问题吧。

# 解决办法

问题的解决思路其实显而易见，我在使用一个产品，发现它的功能好像有问题，我该怎么办？找客服和售后呗，如果有说明书和FAQ，先翻一翻，问题可能就搞定了。

github这么牛逼的产品当然有说明书和FAQ，关于不绿的这个问题，稍微留意一下就会看到FAQ就在活动图的下面：

![not_green_faq.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/not_green_faq.png)

点进去，根据自己的问题对症下药，我这个问题是因为：
**<font color="red">"You haven't added your local Git commit email to your profile"</font>**

即我没有把我本地git配置中的email地址添加到我的github个人资料之中，这导致我的提交不会与我的账号信息发生关联，从而导致该绿的日子没有“变绿”。

解决步骤：

**1. 确定没有变绿的提交所使用的email地址**

到你的个人资料主页，选择"public activity"选项卡：

![commit_id.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/commit_id.jpg)

点击本该变绿但没有变绿的提交id(fb9a236)，在打开的网页上，地址栏最后加上`.patch`，回车，将会显示如下内容，其中的From字段就是你本次提交所用的email

![github_email.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/git_email.jpg)

**2. 把这个email地址绑定到你的Profile**

这步很简单，点击github右上角你头像的下拉箭头，选择“Setting”，跳转到设置页面，选择左侧的“Email”，在右侧窗口就会看到添加选项了。


绑定并验证完email，回到你的个人资料主页，刷新一下就会发现：该绿的都绿了。

![green.jpg](http://7xi3zl.com1.z0.glb.clouddn.com/green.jpg)

# 参考

**[官方参考文档](https://help.github.com/articles/why-are-my-contributions-not-showing-up-on-my-profile/)**

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

