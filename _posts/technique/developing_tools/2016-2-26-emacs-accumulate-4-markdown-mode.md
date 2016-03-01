---
layout: post
title: "Emacs-Markdown-mode"
category: tools
tags: [emacs]
description: ""
---

# Usage #

## Hyperlinks: prefix = `C-c C-a` ##

  * prefix + l : insert a link.`[text](url)`.
  * prefix + L : insert a link form `[a][b]`.
  * prefix + u : bare url.
  * prefix + f : footnote.footnote is an extension to Markdown.
  * prefix + w : `[[WikiLink]]`. also an extension to Markdown.

## Images: prefix = `C-c C-i` ##

  * prefix + i : 

<!--more-->

## Styles: prefix = `C-c C-s` ##

  * prefix + e: italic.
  * prefix + s : `<strong>`.
  * prefix + c : inline code. `<code>`.
  * prefix + k : `<kbd>` tags.
  * prefix + b : blockquote.
  * prefix + p : similarly for inserting performatted code blocks. 缂╄繘鐨刢ode block.

## Heading: prefix = `C-c C-t` ##

  * prefix + h : auto style, determined by the previous heading.
  * prefix + H : similarly.
  * prefix + 1 to 6 : 
  * prefix + ! : S-1
  * prefix + @ : S-2
  
  `C-c C-k` to kill heading and `C-y` to yank back.

## Horizontal Rules: `C-c -` ##

## Markdown and Maintenance Commands: prefix = `C-c C-c` ##

  * prefix + m : run Markdown on the current buffer and show output in another buffer.
  * prefix + p : preview
  * prefix + e : export
  * prefix + o : open
  * prefix + l : Press
  * prefix + v : 
  * prefix + w : 
  * prefix + c : check undefined references.
  * prefix + n : renumber ordered lists.
  * prefix + ] : completes all headings and normalizes all horizontal rules.
  
<!--

# practice

[hello world](baidu.com)

[labelhere][link-label]

[link-label]: baidu.com "link-title"

<hello>

hello


![images](url)


![jlaksjdlkfaj dlkjaflkjds jlakjsdf ](long image name)

*thi si italic*


**this is strong**

`this is code` in line code

<kbd>this is kbd</kbd>

> this is backquote


    this is similarly performatted code bl


# this is auto heading #


this is not auto but H
======================

demoted by one level . use C-u C-u prefix for C-c C-t H.
--------------------


# 111111111111111111 #


## 222222222222222 ##


### 3333333333 ###


#### 444444444444 ####

##### 5555555555555 #####


###### 6666666666666E ######








-------------------------------------------------------------------------------



-------------------------------------------------------------------------------



kjaslkdjfkasdjf

-->

---------------------------

**作者水平有限，对相关知识的理解和总结难免有错误，还望给予指正，非常感谢！**

**在这里也能看到这篇文章：[github博客](http://elloop.github.io), [CSDN博客](http://blog.csdn.net/elloop), 欢迎访问**

