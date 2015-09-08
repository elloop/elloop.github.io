---
layout: post
title: "给Jekyll页面添加目录"
highlighter_style: monokai
category: [blog]
tags: [jekyll]
description: ""
published: true
---

## 为Jekyll页面添加目录导航

我本地的jekyll的markdown引擎使用的是redcarpet，在试过了在_config.yml里面开启redcarpet的扩展：with_toc_data选项之后，本地就不能启动jekyll了，在网上搜索发现：

>The problem here is that :with_toc_data is an option for an instance of the redcarpet renderer, and not a configuration extension. 
Unfortunately, Jekyll doesn't seem to expose this renderer option, so I don't think you'll be able to use it

意思是说 with_toc_data 这个选项不是一个可以配置在_config.yml里面的东西，并且jekyll默认也没有为我们开启这个选项。这就是导致加上那个选项之后就无法启动jekyll的原因。

那么我们想要给jekyll页面加上目录怎么办？

这里我分享给大家两个方法：

- 使用plugin + 本地发布，推送_site的方式，这也是使用jekyll插件的标准做法([请参考Jekyll的插件功能说明](http://jekyllrb.com/docs/plugins/)). [这里是别人推荐的一个生成目录的插件](https://github.com/dafi/jekyll-toc-generator).
- 如果你熟悉js的话，可以自己写一个。[请参考这个人写的js脚本](https://github.com/dafi/jekyll-toc-generator)


