---
layout: post
title: "Thinking 6-30"
highlighter_style: solarizeddark
category: [diary]
tags: [todo, question, summary]
description: ""
published: false
---

# question
- 为什么http请求后面要加上一个timestamp?
- os.system("cd build") 失效为什么?
    - solve, [solve1](http://stackoverflow.com/questions/431684/how-do-i-cd-in-python), [solve2](http://stackoverflow.com/questions/10862340/os-system-doesnt-work-in-python)

    >First, you generally don't want to use os.system - take a look at the subprocess module instead. But, that won't solve your immediate problem (just some you might have down the track) - the actual reason cd won't work is because it changes the working directory of the subprocess, and doesn't affect the process Python is running in - to do that, use os.chdir.

# summary

- book recommendation: "the art of unix programming"

- 保持清醒的头脑，从长计议，该学什么，该往哪里走？
- 总结这些年的c++知识，写成博客，坚持深入下去
- 跟其他工程师交流编程经验、想法，有什么办法能把人聚在一起，把哪里的人聚在一起，交流一下学习心得和学习方向。

- use subprocess to replace os.system, os.popen, ..., follow this [link](https://docs.python.org/2/library/subprocess.html)


# todo
- add a navigation tab for life blogs.
- a link to my github projects.
- 加入站长统计，让博客的数据对外可见。流量大的话可以考虑接入广告
