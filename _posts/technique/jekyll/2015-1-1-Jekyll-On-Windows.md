---
layout: post
title: Install Jekyll on Windows
category: blog
highlighter_style: monokai
tags: [jekyll, blog]
description: "install jekyll on windows"
---
{% include JB/setup %}

#步骤

## 1. 安装ruby和ruby DevKit [下载地址](http://rubyinstaller.org/downloads/), 本人使用2.0版本可行。
需要注意的两点：

- 安装ruby时候，将ruby可执行文件路径加入到环境变量中

- 解压Ruby DevKit之后，进入解压所在目录，分别执行：

```bash
ruby dk.rb init
ruby dk.rb install
```

## 2. 安装Jekyll: gem install jekyll

## 3. build and run jekyll
{% highlight bash %}
jekyll build
jekyll build --watch
jekyll build -w
jekyll serve
jekyll serve --watch
jekyll serve -w
{% endhighlight %}

---

#遇到的问题

## gem install jekyll 报错： 
*Error*
{% highlight bash %}
ERROR: Could not find a valid gem 'jekyll' (>= 0), here is why:
Unable to download data from https://rubygems.org/ - 
Errno::ETIMEDOUT: Operation timed out - connect(2) (https://rubygems.org/latest_specs.4.8.gz)
{% endhighlight %}

*Solution*

https://rubygems.org/ 可能被墙了，使用http://ruby.taobao.org这个源。

{% highlight bash %}
$ gem sources --remove https://rubygems.org/
$ gem sources -a http://ruby.taobao.org/
$ gem sources -l
*** CURRENT SOURCES ***
http://ruby.taobao.org  
$ gem install jekyll
{% endhighlight %}

---

#参考

- [英文详细教程链接](http://jekyll-windows.juthilo.com/)

