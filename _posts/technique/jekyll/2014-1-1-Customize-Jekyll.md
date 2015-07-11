---
layout: post
title: "自定义Jekyll--使用Jekyll-Bootstrap"
highlighter_style: monokai
category: [blog]
tags: [jekyll]
description: ""
published: true
---

**jekyll version: 2.5.3**

# 关键文件介绍

## _config.yml
- 功能: jekyll的主要配置文件，这里面定义了一些关键的变量。如markdown引擎、高亮引擎、评论系统、统计系统、分享系统、Jekyll-Bootstrap(JB)等变量设置。
>从程序设计角度理解就是在这里面定义了jekyll系统用到的一些全局变量，在其他页面可以访问这里面的值。

```bash

 # This is the default format.
# For more see: http://jekyllrb.com/docs/permalinks/
permalink: /:categories/:year-:month-:day/:title

markdown: redcarpet
markdown_ext:  md
redcarpet:
    extensions: [no_intra_emphasis,tables,autolink,disable_indented_code_blocks,fenced_code_blocks]
    
exclude: [".rvmrc", ".rbenv-version", "README.md", "Rakefile", "changelog.md"]
highlighter: pygments
highlighter_style: solarizeddark
```

## atom.xml
**todo**

## index.html
博客首页

简单首页示例

```html
---
layout: page
title: elloop.github.io
tagline: Programming Things
---
{% include JB/setup %}

<h2 id="sample-posts">Posts</h2>

<ul class="posts">
</ul>
```
**todo**

## pages.html
**todo**

## archive.html
**todo**

## categories.html
**todo**

## tags.html
**todo**

# FAQ
## 1.如何在文章中输入liquid语法的文本，比如\{\% highlight c++ \%\}, \{\{ post.data }\}这种原文，而不给转义？
